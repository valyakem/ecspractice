#!/bin/sh
DEST="14279408000.dkr.ecr.ca-central-1.amazonaws.com/testecs"
if [ aws ecr create-repository --repository-name $APP_NAME --region $AWS_DEFAULT_REGION ]; then 
    # It is a symbolic links #
    echo "Directory exist ..."
  else
    # It is a directory #
    aws ecr create-repository --repository-name $APP_NAME --region $AWS_DEFAULT_REGION
fi
