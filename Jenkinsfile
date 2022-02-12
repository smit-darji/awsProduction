AWS_ACCOUNT_ID="997817439961"
AWS_DEFAULT_REGION="ap-south-1"
IMAGE_REPO_NAME="main-repo-smit"
IMAGE_TAG="latest_${GIT_COMMIT} "       
CLUSTER_NAME="main-cluster-smit"
SERVICE_NAME="main-service-smit"
TASK_DEFINITION_NAME="softvan-main-smit"
DESIRED_COUNT="1"
 
// login in to aws ecr
sh "aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin 997817439961.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"

// build new image
sh "docker build -t main-repo-smit ."
