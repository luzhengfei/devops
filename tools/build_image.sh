#!/bin/bash

# 检查参数是否完整
if [ $# -lt 5 ]; then
  echo "Usage: $0 <tag_name> <image_type> <Access Key ID> <Secret Access Key> <Account ID>"
  exit 1
fi

# 参数赋值
TAG_NAME=$1
IMAGE_TYPE=$2
AWS_ACCESS_KEY_ID=$3
AWS_SECRET_ACCESS_KEY=$4
ACCOUNT_ID=$5

# 配置区域和存储库信息
REGION="ap-northeast-1"
REPOSITORY_NAME="backend_php"

mkdir ./deploy
cp -fr ../deploy_php ./deploy
mkdir -p ./project_dir/app

# 配置 AWS CLI
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$REGION

# 创建 ECR 存储库（如果不存在）
aws ecr describe-repositories --repository-names $REPOSITORY_NAME > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "创建镜像 $REPOSITORY_NAME"
  #aws ecr create-repository --repository-name $REPOSITORY_NAME
else
  echo "镜像存在"
fi

# 登录 ECR
echo "Login ECR"
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# 构建镜像
echo "创建镜像"
docker build -t $REPOSITORY_NAME:$TAG_NAME -f ../$IMAGE_TYPE/Dockerfile .

# 标记镜像
echo "打标记"
docker tag $REPOSITORY_NAME:$TAG_NAME $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$TAG_NAME

# 推送镜像到 ECR
echo "推送中..."
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$TAG_NAME

echo "操作成功!"