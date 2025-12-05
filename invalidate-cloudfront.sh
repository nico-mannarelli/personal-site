#!/bin/bash

# CloudFront Cache Invalidation Script
# Use this after deploying updates to clear CloudFront cache

# Get distribution ID from user or environment variable
if [ -z "$CLOUDFRONT_DIST_ID" ]; then
  echo "🌐 CloudFront Cache Invalidation"
  echo ""
  echo "Enter your CloudFront Distribution ID:"
  echo "   (Find it in: https://console.aws.amazon.com/cloudfront/)"
  echo ""
  read -p "Distribution ID: " DIST_ID
else
  DIST_ID="$CLOUDFRONT_DIST_ID"
fi

if [ -z "$DIST_ID" ]; then
  echo "❌ Distribution ID is required"
  exit 1
fi

echo ""
echo "🔄 Invalidating CloudFront cache..."
echo "   Distribution: $DIST_ID"
echo ""

INVALIDATION_OUTPUT=$(aws cloudfront create-invalidation \
  --distribution-id "$DIST_ID" \
  --paths "/*" 2>&1)

if [ $? -eq 0 ]; then
  INVALIDATION_ID=$(echo "$INVALIDATION_OUTPUT" | grep -o '"Id": "[^"]*"' | cut -d'"' -f4)
  echo "✅ Cache invalidation created!"
  echo ""
  echo "📋 Invalidation ID: $INVALIDATION_ID"
  echo "⏳ Cache will clear in 1-2 minutes"
  echo ""
  echo "💡 To check status:"
  echo "   https://console.aws.amazon.com/cloudfront/v3/home#/distributions/$DIST_ID/invalidations"
else
  echo "❌ Error creating invalidation"
  echo "$INVALIDATION_OUTPUT"
  echo ""
  echo "💡 Make sure:"
  echo "   - AWS CLI is configured"
  echo "   - You have CloudFront permissions"
  echo "   - Distribution ID is correct"
fi




