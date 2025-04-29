pipeline {
    agent any

    environment {
        EC2_USER = "ubuntu"  // Or ubuntu, depending on your AMI
        EC2_HOST = "44.213.102.243"
        EC2_KEY = credentials('ec2-ssh-private-key')  // Jenkins credential with SSH private key
        PROJECT_DIR = "/home/ubuntu/pytests/django_polls"  // Path to your Django app
    }

    //triggers {
      //  githubPush()  // Enables webhook triggering
    //}
    
    stages {
        stage('Update Code on EC2') {
            steps {
                script {
                     echo 'Hello 15'
                    // Use SSH to run commands on the EC2 instance
                    sshagent (credentials: ['ec2-ssh-private-key']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_HOST} '
                            cd ${PROJECT_DIR}
                            git pull origin main
                            source comp314/bin/activate
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
