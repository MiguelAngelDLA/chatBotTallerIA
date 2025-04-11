#!/bin/bash

AWS_ACCOUNT_ID="315195286313"
REGION="us-east-2"
REPO_NAME="repo-chatbot"
IMAGE_NAME="flask"
ECR_URI="$AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME"

TAG="$1"
if [ -z "$TAG" ]; then
  TAG=$(date +%Y-%m-%d)
  echo "ℹ️  No se especificó un tag. Usando fecha actual: $TAG"
fi

echo "🛠️  Construyendo la imagen Docker..."
docker build -t $IMAGE_NAME:$TAG .

echo "🏷️  Etiquetando la imagen como $ECR_URI:$TAG"
docker tag $IMAGE_NAME:$TAG $ECR_URI:$TAG

echo "🔐 Iniciando sesión en ECR como root..."
sudo su -c "
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI
"

echo "📦 Enviando imagen $TAG a ECR..."
sudo docker push $ECR_URI:$TAG

echo "✅ Imagen $TAG enviada exitosamente a ECR."

