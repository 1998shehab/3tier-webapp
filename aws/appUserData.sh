#!/bin/bash
#install node
#yum install nodejs npm --enablerepo=epel
yum install -y nodejs npm
mkdir -p /usr/src/nodejsapp
cd /usr/src/nodejsapp
npm init -y
#npm ci
npm install -y express mysql2 sequelize
npm install -y nodemon --save-dev

#DB should be created in RDS

cat > /usr/src/nodejsapp/app.js <<EOF

const express = require('express');
const { Sequelize } = require('sequelize');

const app = express();

// Connect to MySQL database from the server
// dbname = mydatabase
// username = root
// password = '12345678'
// host should be changed
const sequelize = new Sequelize('mydatabase', 'root', '12345678', {
  dialect: 'mysql',
  host: "${database}",
});

// Define a model
const User = sequelize.define('User', {
  name: Sequelize.STRING,
  email: Sequelize.STRING,
});

// Sync the model with the database
sequelize.sync();

// Middleware
app.use(express.json());

// Endpoints
app.get('/', async (req, res) => {
  const users = await User.findAll();
  res.json(users);
});

app.post('/users', async (req, res) => {
  const { id, name, email } = req.body;
  const user = await User.create({ id, name, email });
  res.json(user);
});

// Protection middleware
// app.use((req, res, next) => {
//   const token = req.headers.authorization;
//   if (token !== 'secret-token') {
//     return res.status(401).json({ message: 'Unauthorized' });
//   }
//   next();
// });

// Start the server
app.listen(80, () => {
  console.log('Server started on port 80');
});

EOF

cat > /usr/src/nodejsapp/start.sh <<EOF
#!/bin/bash
cd /usr/src/nodejsapp
node app.js
EOF

cat > /etc/systemd/system/backend.service <<EOF
[Unit]
Description=node backend service
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/usr/src/nodejsapp
ExecStart=/bin/bash /usr/src/nodejsapp/start.sh

[Install]
WantedBy=multi-user.target

EOF

systemctl enable backend.service
systemctl start backend.service

#useradd -r node

#node app.js

#jenkins
#java -war jenkins.war