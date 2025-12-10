#!/bin/bash

# AWS S3 Deployment Script for personal-site
# 
# Configuration:
# - Set values in .env file (copy env.example to .env)
# - Or set environment variables: AWS_S3_BUCKET, AWS_REGION, CLOUDFRONT_DIST_ID
# - Or modify the defaults below (not recommended for public repos)

# Load from .env file if it exists
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
fi

# Use environment variables (should be set in .env file)
# The script will fail if .env doesn't exist - this prevents hardcoding secrets
if [ -z "$AWS_S3_BUCKET" ] || [ -z "$AWS_REGION" ] || [ -z "$CLOUDFRONT_DIST_ID" ]; then
  echo "❌ Error: AWS configuration not found!"
  echo ""
  echo "Please create a .env file (copy env.example to .env and fill in values):"
  echo "  cp env.example .env"
  echo "  # Then edit .env with your AWS details"
  exit 1
fi

BUCKET_NAME="$AWS_S3_BUCKET"
REGION="$AWS_REGION"
# CLOUDFRONT_DIST_ID is already set from .env export above

echo "🚀 Building site..."
npm run build

if [ $? -ne 0 ]; then
  echo "❌ Build failed!"
  exit 1
fi

echo "📦 Checking if S3 bucket exists..."
if ! aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "✅ Bucket exists"
else
  echo "📝 Creating S3 bucket..."
  aws s3 mb "s3://$BUCKET_NAME" --region $REGION
  
  echo "🌐 Enabling static website hosting..."
  aws s3 website "s3://$BUCKET_NAME" \
    --index-document index.html \
    --error-document 404.html
  
  echo "🔓 Setting bucket policy for public access..."
  cat > /tmp/bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
    }
  ]
}
EOF
  aws s3api put-bucket-policy --bucket "$BUCKET_NAME" --policy file:///tmp/bucket-policy.json
  
  echo "🚫 Blocking public access settings..."
  aws s3api put-public-access-block \
    --bucket "$BUCKET_NAME" \
    --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
fi

echo "📤 Uploading site to S3..."
aws s3 sync dist/ "s3://$BUCKET_NAME" --delete --region $REGION

if [ $? -ne 0 ]; then
  echo "❌ Upload failed!"
  exit 1
fi

echo ""
echo "✅ Files uploaded to S3!"

# Invalidate CloudFront cache if distribution ID is set
if [ ! -z "$CLOUDFRONT_DIST_ID" ]; then
  echo ""
  echo "🔄 Invalidating CloudFront cache..."
  INVALIDATION_OUTPUT=$(aws cloudfront create-invalidation \
    --distribution-id "$CLOUDFRONT_DIST_ID" \
    --paths "/*" 2>&1)
  
  if [ $? -eq 0 ]; then
    INVALIDATION_ID=$(echo "$INVALIDATION_OUTPUT" | grep -o '"Id": "[^"]*"' | cut -d'"' -f4)
    echo "✅ Cache invalidation created!"
    echo "   Invalidation ID: $INVALIDATION_ID"
    echo "   ⏳ Cache will clear in 1-2 minutes"
  else
    echo "⚠️  Could not invalidate CloudFront cache automatically"
    echo "   You may need to invalidate manually:"
    echo "   https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$CLOUDFRONT_DIST_ID/invalidations"
    echo ""
    echo "   Error: $INVALIDATION_OUTPUT"
  fi
fi

echo ""
echo "✅ Deployment complete!"
echo "🌐 Your site: https://nicomannarelli.com"
echo ""





