pipeline {

    agent any
    
    environment {
            REPOSITORY_URI = "440153443065.dkr.ecr.us-east-1.amazonaws.com"
            AWS_DEFAULT_REGION = "us-east-1"
            APP_NAME = "ecspractice"
            VPC_ID = "vpc-502b5b2d"
            SUBNET_ID_1 = "subnet-ac0120f3"
            SUBNET_ID_2 = "subnet-52b39734"
            SUBNET_ID_3 = "subnet-ec7a58cd"
            SECURITY_GROUP_ID = "sg-072700b42430571ba"
            MY_PROFILE = "default"
            //CLUSTER_NAME = "pythontestapp"
            //SERVICE_NAME = "pythontestappsv"
            //TASK_DEFINITION_NAME = 'pythontestapp'
            IMAGE_TAG = "latest"
            //CONTAINER = "pythontestappct"
            //VPC_ID = "vpc-090bb77db170cd437"
    }
    
    stages {

        stage ('Checkout') {
            steps {
                    checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    extensions: [], 
                    userRemoteConfigs: [[credentialsId: 'valyakem', 
                    url: 'https://github.com/valyakem/ecspractice.git']]])
                }
        } 
        
        
        stage ('Tooling and Prep') {
            steps {
                   script {
                     sh 'docker --version'
                     sh "aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI"
                     //sh "ecs-cli compose down --cluster-config testecs --ecs-profile ecsprofile"
                     //sh "ecs-cli down --force --cluster-config testecs --ecs-profile ecsprofile"
                   }
            }
        }
        stage ('Send Aproval Email') {
            steps {
                mail(
                body: "Hi ${currentBuild.fullDisplayName}, please kindly login and approve the pipeline build stage. Link to pipeline  ${env.BUILD_URL} has result ${currentBuild.result}", 
                cc: "", 
                from: "nexbits@zohomail.com", 
                replyTo: "nexbits@zohomail.com", 
                subject: "Test email using mailer", 
                to: "valyakem@yahoo.co.uk"
                )
            }
        }
 
        stage ('Image Build') {
            when {
                branch '*/main'
            }
            input{
                message "Do you want to proceed for production deployment?"
            }
            steps {
                   script {
                       sh 'sudo docker build -t hello-world .'
                     //sh "aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI"
                     //sh "docker tag alpine/git:latest $REPOSITORY_URI/$APP_NAME:latest"
                     //sh "docker push $REPOSITORY_URI/$APP_NAME:latest"
                   }
            }
        }

        stage ('Create Repository') {
            when {
                branch '*/main'
            }
            steps {
                   script {
                    sh "aws ecr describe-repositories --repository-names $APP_NAME || aws ecr create-repository --repository-name $APP_NAME"
                    //sh "./createrepo.sh"
                   }
            }
        }
        
        stage ('Push to ECR') {
            when {
                branch '*/main'
            }
            steps {
                script {
                    sh "docker tag hello-world $REPOSITORY_URI/$APP_NAME"
                    sh "docker push $REPOSITORY_URI/$APP_NAME:latest"
                }
            }
        }
        

        stage ('Create Cluster') {
            when {
                branch '*/main'
            }
            steps {
                script {
                    //sh "docker compose down"
                    sh "aws iam attach-role-policy \
                        --region $AWS_DEFAULT_REGION \
                        --role-name ecsTaskExecutionRole \
                        --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

                    sh "ecs-cli configure \
                        --cluster $APP_NAME \
                        --default-launch-type FARGATE \
                        --config-name $APP_NAME \
                        --region $AWS_DEFAULT_REGION"
                    
                    sh "ecs-cli up \
                        --cluster-config $APP_NAME \
                        --vpc $VPC_ID \
                        --subnets $SUBNET_ID_1, $SUBNET_ID_2, $SUBNET_ID_3 \
                        --ecs-profile $MY_PROFILE" 

                    //sh "aws ec2 describe-security-groups \
                       // --filters Name=StageVPC,Values=$VPC_ID \
                      //  --region $AWS_DEFAULT_REGION"

                    sh "aws ec2 authorize-security-group-ingress \
                        --group-id $SECURITY_GROUP_ID \
                        --protocol tcp \
                        --port 80 \
                        --cidr 0.0.0.0/0 \
                        --region $AWS_DEFAULT_REGION"

                    sh "ecs-cli compose --project-name $APP_NAME service up \
                        --create-log-groups \
                        --cluster-config $APP_NAME \
                        --ecs-profile $MY_PROFILE"

                    sh "ecs-cli compose --project-name $APP_NAME service ps \
                        --cluster-config $APP_NAME \
                        --ecs-profile $MY_PROFILE"
                    //sh "docker compose up"
                    //sh "ecs-cli down --force --cluster-config $APP_NAME --region $AWS_DEFAULT_REGION"
                    //sh "aws ecs create-cluster --cluster-name $APP_NAME --capacity-providers FARGATE FARGATE_SPOT --region $AWS_DEFAULT_REGION"
                    //sh "ecs-cli up --cluster-config $APP_NAME --vpc $VPC_ID --subnets $SUBNET_ID_1, $SUBNET_ID_2, $SUBNET_ID_3 --force --region $AWS_DEFAULT_REGION"
                    //sh "ecs-cli up --cluster-config $APP_NAME --force --region $AWS_DEFAULT_REGION"
                    //sh "aws ec2 create-security-group --description $APP_NAME --group-name $SECURITY_GROUP_NAME --vpc-id $VPC_ID"
                    //sh "aws ec2 authorize-security-group-ingress --group-id $GroupId --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $AWS_DEFAULT_REGION"

                }
            }
        }
       // stage ('configure cluster resources') {
            //steps {
                //script{
                //  sh "docker compose down"
                //   sh "ecs-cli compose --project-name test service up --create-log-groups --cluster-config test"
                //  sh "ecs-cli compose --project-name test service ps --cluster-config test"
                   //Create cloudwatch role
                  
                   //sh "aws iam --region $AWS_DEFAULT_REGION create-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json"
                   //*sh "aws iam --region $AWS_DEFAULT_REGION attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
                   
                   // Configure the Amazon ECS CLI
                   //sh 'docker compose up'
                   //sh "ecs-cli configure --cluster testecs --default-launch-type FARGATE --config-name testecs --region $AWS_DEFAULT_REGION"
                   //sh "ecs-cli up --cluster-config testecs --ecs-profile ecsprofile"
                   //sh "aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID --region $AWS_DEFAULT_REGION"
                   //sh "aws ec2 authorize-security-group-ingress --group-id sg-024c6618781b56ec2 --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $AWS_DEFAULT_REGION"
            //    }
                
            //}
        //}
        
        //Deploy the Compose File to a Cluster



    }
}


