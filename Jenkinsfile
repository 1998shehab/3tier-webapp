def approve = "no"
// arn:aws:s3:::yat-group3
def apply() {
    script {
        dir ("${params.projectPath}/terraform") { 
            echo "applying"
            sh("terraform apply -auto-approve 'tfplan'")
            //sh("terraform destroy --target -auto-approve module.ami.aws_instance.PublicWebTemplate")
            //sh("terraform destroy --target -auto-approve module.ami.aws_instance.PublicappTemplate")
            sh("aws s3 cp . s3://yat-group3/terraform/ --exclude \"*\" --include \"*.tfstat*\" --recursive")
        }
    }
}

def destroy() {
    script {
        dir ("${params.projectPath}/terraform") {
            echo "destroying"
            sh("aws s3 cp s3://yat-group3/terraform/ .  --exclude \"*\" --include \"*.tfstat*\" --recursive")
            sh("terraform destroy -auto-approve")
            sh("aws s3 cp s3://yat-group3/terraform/ . --exclude \"*\" --include \"*.tfstat*\" --recursive")
        }
    }
}


pipeline {
    agent any

    parameters {
        string(defaultValue: '/home/omar/Eng/Courses/DEPI/Technical/Project3tier/trial2/3twebapp', description: 'Please, Enter project path', name: 'projectPath')
        choice(name: 'action', choices: ['apply', 'destroy'], 
        description: 'Please, choose whether to apply or destroy the infrastructure.')
    }
    
    stages {
        stage('Checkout') {
           steps {
                dir ("${params.projectPath}") { 
                    git branch: 'main', url: 'https://github.com/omarabdelwahabmb/3twebapp.git'
                }
           }
        }
        stage('Plan') {
            steps {
                script {
                    dir ("${params.projectPath}/terraform") {
                        sh("terraform init")
                        sh("aws s3 cp s3://yat-group3/terraform/ . --exclude \"*\" --include \"*.tfstat*\" --recursive")
                        sh ("terraform plan -out tfplan")
                    }
                    approve = input (message: "Do you want to apply the plan?",
                                   parameters: [choice(name: 'approve', choices:'apply\nno',
                                   description: 'Please review the plan')])
                }
            }
        }
        stage('Build') {
            when { expression { approve == "apply" } }
            steps {
                script {
                    switch(params.action) {
                        case "apply":
                            apply()
                            break;
                        case "destroy":
                            destroy()
                            break;
                        default:
                            echo "wrong choice!"
                            break;
                    }
                }
            }
        }
        stage("decline") {
            when { expression { approve == "no" } }
            steps {
                echo "You declined applying the plan."
            }
        }
    }
}
