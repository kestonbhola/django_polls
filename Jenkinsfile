pipeline {
    agent any

    
    stage('Pre-check') {
        steps {
            echo "Pipeline reached pre-check stage."
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
