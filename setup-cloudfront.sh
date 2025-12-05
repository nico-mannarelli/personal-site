#!/bin/bash

# CloudFront Distribution Setup Script
# This creates a CloudFront distribution with HTTPS for your S3 website

BUCKET_NAME="nico-mannarelli-personal-site"
REGION="us-east-1"
ORIGIN_DOMAIN="${BUCKET_NAME}.s3-website-${REGION}.amazonaws.com"

echo "🌐 Creating CloudFront distribution for HTTPS..."
echo "   Origin: $ORIGIN_DOMAIN"
echo ""

# Create CloudFront distribution configuration
cat > /tmp/cloudfront-config.json <<EOF
{
  "CallerReference": "personal-site-$(date +%s)",
  "Comment": "Personal site distribution for $BUCKET_NAME",
  "DefaultCacheBehavior": {
    "TargetOriginId": "S3-$BUCKET_NAME",
    "ViewerProtocolPolicy": "redirect-to-https",
    "AllowedMethods": {
      "Quantity": 2,
      "Items": ["GET", "HEAD"],
      "CachedMethods": {
        "Quantity": 2,
        "Items": ["GET", "HEAD"]
      }
    },
    "ForwardedValues": {
      "QueryString": false,
      "Cookies": {
        "Forward": "none"
      }
    },
    "MinTTL": 0,
    "DefaultTTL": 86400,
    "MaxTTL": 31536000,
    "Compress": true
  },
  "Origins": {
    "Quantity": 1,
    "Items": [
      {
        "Id": "S3-$BUCKET_NAME",
        "DomainName": "$ORIGIN_DOMAIN",
        "CustomOriginConfig": {
          "HTTPPort": 80,
          "HTTPSPort": 443,
          "OriginProtocolPolicy": "http-only",
          "OriginSslProtocols": {
            "Quantity": 1,
            "Items": ["TLSv1.2"]
          }
        }
      }
    ]
  },
  "Enabled": true,
  "PriceClass": "PriceClass_100",
  "DefaultRootObject": "index.html",
  "CustomErrorResponses": {
    "Quantity": 1,
    "Items": [
      {
        "ErrorCode": 404,
        "ResponsePagePath": "/index.html",
        "ResponseCode": "200",
        "ErrorCachingMinTTL": 300
      }
    ]
  }
}
EOF

echo "📝 Creating CloudFront distribution..."
DISTRIBUTION_OUTPUT=$(aws cloudfront create-distribution --distribution-config file:///tmp/cloudfront-config.json 2>&1)

if [ $? -eq 0 ]; then
  DISTRIBUTION_ID=$(echo "$DISTRIBUTION_OUTPUT" | grep -o '"Id": "[^"]*"' | cut -d'"' -f4)
  DOMAIN_NAME=$(echo "$DISTRIBUTION_OUTPUT" | grep -o '"DomainName": "[^"]*"' | cut -d'"' -f4)
  
  echo ""
  echo "✅ CloudFront distribution created!"
  echo ""
  echo "📋 Distribution ID: $DISTRIBUTION_ID"
  echo "🌐 Domain Name: $DOMAIN_NAME"
  echo ""
  echo "⏳ Please wait 5-15 minutes for the distribution to deploy..."
  echo "   Your site will be available at: https://$DOMAIN_NAME"
  echo ""
  echo "💡 You can check status at:"
  echo "   https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$DISTRIBUTION_ID"
  echo ""
  echo "📝 Save this information:"
  echo "   Distribution ID: $DISTRIBUTION_ID"
  echo "   HTTPS URL: https://$DOMAIN_NAME"
else
  echo "❌ Error creating distribution"
  echo "$DISTRIBUTION_OUTPUT"
  echo ""
  echo "💡 You may need to create it manually via the AWS Console:"
  echo "   1. Go to: https://console.aws.amazon.com/cloudfront/"
  echo "   2. Click 'Create distribution'"
  echo "   3. Origin domain: $ORIGIN_DOMAIN"
  echo "   4. Viewer protocol: 'Redirect HTTP to HTTPS'"
  echo "   5. Default root object: 'index.html'"
fi





