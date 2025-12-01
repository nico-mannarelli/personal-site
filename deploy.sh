#!/bin/bash

# AWS S3 Deployment Script
# Make sure to set these variables:
# BUCKET_NAME - Your S3 bucket name
# DISTRIBUTION_ID - Your CloudFront distribution ID (optional)

BUCKET_NAME="your-site-name"
DISTRIBUTION_ID=""

echo "🚀 Building site..."
npm run build

if [ $? -ne 0 ]; then
  echo "❌ Build failed!"
  exit 1
fi

echo "📤 Uploading to S3..."
aws s3 sync dist/ s3://$BUCKET_NAME --delete

if [ $? -ne 0 ]; then
  echo "❌ Upload failed!"
  exit 1
fi

if [ ! -z "$DISTRIBUTION_ID" ]; then
  echo "🔄 Invalidating CloudFront cache..."
  aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*"
fi

echo "✅ Deployment complete!"



