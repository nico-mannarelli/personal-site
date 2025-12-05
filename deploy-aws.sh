#!/bin/bash

# AWS S3 Deployment Script for personal-site
# Make sure to set your bucket name below

BUCKET_NAME="nico-mannarelli-personal-site"
REGION="us-east-1"

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
echo "✅ Deployment complete!"
echo "🌐 Your site is available at:"
echo "   http://$BUCKET_NAME.s3-website-$REGION.amazonaws.com"
echo ""
echo "💡 To add HTTPS and a custom domain, create a CloudFront distribution:"
echo "   1. Go to: https://console.aws.amazon.com/cloudfront/"
echo "   2. Create distribution"
echo "   3. Origin: $BUCKET_NAME.s3-website-$REGION.amazonaws.com"
echo "   4. Viewer protocol: Redirect HTTP to HTTPS"
echo ""





