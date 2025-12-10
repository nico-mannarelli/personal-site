#!/bin/bash

# CloudFront Cache Invalidation for nicomannarelli.com
# Distribution Domain: dax4dijmsbfg4.cloudfront.net

# Replace YOUR_DISTRIBUTION_ID with your actual CloudFront Distribution ID
DISTRIBUTION_ID="${CLOUDFRONT_DIST_ID:-YOUR_DISTRIBUTION_ID}"

if [ "$DISTRIBUTION_ID" = "YOUR_DISTRIBUTION_ID" ]; then
  echo "❌ Please set your CloudFront Distribution ID"
  echo ""
  echo "Run this command with your Distribution ID:"
  echo "  CLOUDFRONT_DIST_ID=YOUR_DIST_ID ./invalidate.sh"
  echo ""
  echo "Or edit this script and replace YOUR_DISTRIBUTION_ID"
  echo ""
  echo "💡 To find your Distribution ID:"
  echo "   1. Go to: https://console.aws.amazon.com/cloudfront/"
  echo "   2. Find distribution with domain: dax4dijmsbfg4.cloudfront.net"
  echo "   3. Copy the Distribution ID (starts with 'E')"
  exit 1
fi

echo "🔄 Invalidating CloudFront cache..."
echo "   Distribution ID: $DISTRIBUTION_ID"
echo "   Domain: dax4dijmsbfg4.cloudfront.net"
echo ""

INVALIDATION_OUTPUT=$(aws cloudfront create-invalidation \
  --distribution-id "$DISTRIBUTION_ID" \
  --paths "/*" 2>&1)

if [ $? -eq 0 ]; then
  INVALIDATION_ID=$(echo "$INVALIDATION_OUTPUT" | grep -o '"Id": "[^"]*"' | cut -d'"' -f4)
  echo "✅ Cache invalidation created!"
  echo ""
  echo "📋 Invalidation ID: $INVALIDATION_ID"
  echo "⏳ Cache will clear in 1-2 minutes"
  echo ""
  echo "🌐 Your site: https://nicomannarelli.com"
  echo ""
  echo "💡 To check status:"
  echo "   https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$DISTRIBUTION_ID/invalidations"
else
  echo "❌ Error creating invalidation"
  echo "$INVALIDATION_OUTPUT"
  echo ""
  echo "💡 Make sure:"
  echo "   - AWS CLI is configured correctly"
  echo "   - You have CloudFront invalidation permissions"
  echo "   - Distribution ID is correct"
fi

