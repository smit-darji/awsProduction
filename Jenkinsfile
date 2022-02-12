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
            }
        }
       
        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
                }
            }
        }  
        
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/smit-darji/awsProduction.git']]])
            }
        }
        
        stage('Building image') {
            steps{
                script {
                    dockerImage = docker.build "${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                }
            }
        }
        
         stage('Delete Previous Image') {
            steps{  
                script {
                    sh "aws ecr batch-delete-image --repository-name  '${IMAGE_REPO_NAME}' --image-ids imageTag=$IMAGE_TAG"
                }
            }
        }
        
        stage('Pushing to ECR') {
            steps{  
                script {
                     sh "docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:$IMAGE_TAG"
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}"
                    
                    // sh "ROLE_ARN=`aws ecs describe-task-definition --task-definition '${TASK_DEFINITION_NAME}' --region '${AWS_DEFAULT_REGION}' | jq .taskDefinition.executionRoleArn`"
                    //sh "echo 'ROLE_ARN= ' ${ROLE_ARN}"
                    
                    def ROLE_ARN= sh(script:"aws ecs describe-task-definition --task-definition '${TASK_DEFINITION_NAME}' --region '${AWS_DEFAULT_REGION}' | jq .taskDefinition.executionRoleArn", returnStatus:true)
                    //sh "echo  ROLE=${ROLE_ARN}"
                    //print ${ROLE_ARN}
                   
                   
                   def FAMILY=sh(script:"aws ecs describe-task-definition --task-definition '${TASK_DEFINITION_NAME}' --region '${AWS_DEFAULT_REGION}' | jq .taskDefinition.family", returnStatus:true)
                   //sh "echo FAMILY=${FAMILY}"
                   
                   def name=sh(script:" aws ecs describe-task-definition --task-definition '${TASK_DEFINITION_NAME}' --region '${AWS_DEFAULT_REGION}' | jq .taskDefinition.containerDefinitions[].name", returnStatus:true)
                   //sh "echo Name=${name}"
                   
                   sh "sed -i 's#ROLE_ARN#ROLE_ARN#g' task-definition.json"
                   
                 //def taskdefsh=sh(script:"aws ecs register-task-definition --cli-input-json file://task-definition.json --region='${AWS_DEFAULT_REGION}'",returnStatus:true)
                  
                  sh 'aws ecs register-task-definition --cli-input-json file://task-definition.json --region="${AWS_DEFAULT_REGION}"'
                 
                   def REVISION=sh(script:"aws ecs describe-task-definition --task-definition '${TASK_DEFINITION_NAME}' --region='${AWS_DEFAULT_REGION}' | jq .taskDefinition.revision", returnStatus:true)
                   //sh "echo Revision=${REVISION}"
                  
                  sh 'aws ecs update-service --region ap-south-1 --cluster "${CLUSTER_NAME}" --service "${SERVICE_NAME}" --task-definition "${TASK_DEFINITION_NAME}" --force-new-deployment'
                  //  sh "aws ecs update-service --cluster '${CLUSTER_NAME}' --service '${SERVICE_NAME}' --task-definition '${TASK_DEFINITION_NAME}':'${REVISION}' --desired-count '${DESIRED_COUNT}'"
                }
            }
        }
        
        
}
}
