pipeline {
    agent any

    environment {
        EC2_USER = "ubuntu"  // Or ubuntu, depending on your AMI
         echo 'Hello1'
        EC2_HOST = "ip-172-31-95-3"
         echo 'Hello2'
        EC2_KEY = credentials('ec2-ssh-private-key')  // Jenkins credential with SSH private key
         echo 'Hello3'
        PROJECT_DIR = "/home/ec2-user/my-django-app"  // Path to your Django app
         echo 'Hello4'
    }

    //triggers {
      //  githubPush()  // Enables webhook triggering
    //}

    stages {
        stage('Update Code on EC2') {
            steps {
                script {
                     echo 'Hello5'
                    // Use SSH to run commands on the EC2 instance
                    sshagent (credentials: ['ec2-ssh-private-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            cd ${PROJECT_DIR}
                            git pull origin master
                            source venv/bin/activate
                            pip install -r requirements.txt
                            python manage.py migrate
                            python manage.py collectstatic --noinput
                            sudo systemctl restart gunicorn
                        '
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Code updated and app restarted successfully on EC2!"
        }
        failure {
            echo "Deployment failed."
        }
    }
}
