#!/bin/bash

#install apache
sudo yum -y install httpd

#enable and start apache
sudo systemctl enable httpd
sudo systemctl start httpd

cd /etc/httpd/conf

echo "LoadModule proxy_module modules/mod_proxy.so" >> httpd.conf
echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> httpd.conf
echo "ProxyPass / http://${app_dnsname}:80/" >> httpd.conf
echo "ProxyPassReverse / http://${app_dnsname}:80/" >> httpd.conf

#internal-app-2103124511.us-east-1.elb.amazonaws.com

#sed -i 's/localhost/internal-app-2103124511.us-east-1.elb.amazonaws.com/g' /etc/httpd/conf/httpd.conf