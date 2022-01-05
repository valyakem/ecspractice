#!/bin/sh
DEST="440153443065.dkr.ecr.us-east-1.amazonaws.com/ecspractice"
if [ aws ecr create-repository --repository-name $APP_NAME --region $AWS_DEFAULT_REGION ]; then 
    # It is a symbolic links #
    echo "Directory exist ..."
  else
    # It is a directory #
    aws ecr create-repository --repository-name $APP_NAME --region $AWS_DEFAULT_REGION
fi
