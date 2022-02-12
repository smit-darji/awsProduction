pipeline {
    agent any

environment {
        AWS_ACCOUNT_ID="997817439961"
        AWS_DEFAULT_REGION="ap-south-1"
        IMAGE_REPO_NAME="main-repo-smit"
        IMAGE_TAG="latest"       
        CLUSTER_NAME="main-cluster-smit"
        SERVICE_NAME="main-service-smit"
        TASK_DEFINITION_NAME="softvan-main-smit"
        DESIRED_COUNT="1"      
        REVISION =  "1"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
    }
    stages {
         stage('Trigger pipeline and clone code') {
            steps {
                echo 'Someone push code on git.'
                git branch: 'main', url: 'https://github.com/smit-darji/awsProduction.git'
                
                  sh "chmod +x -R ${env.WORKSPACE}"
                sh "./script.sh"
            }
        }
}
}
