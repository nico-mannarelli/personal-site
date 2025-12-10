# Deployment Guide

## Quick Deploy (Recommended)

Simply run:
```bash
./deploy-aws.sh
```

This will:
1. ✅ Build your site
2. ✅ Upload to S3
3. ⚠️ Attempt CloudFront cache invalidation (may require manual step)

## Manual CloudFront Cache Invalidation

Since AWS CLI may not have CloudFront invalidation permissions, you'll need to invalidate the cache manually:

1. Go to: https://console.aws.amazon.com/cloudfront/v3/home#/distributions/YOUR_DIST_ID/invalidations
   (Get your Distribution ID from the AWS Console or your .env file)
2. Click "Create invalidation"
3. Enter `/*` in the paths field
4. Click "Create invalidation"
5. Wait 1-2 minutes for cache to clear

## What Happened Before?

**The Problem:** CloudFront caches your site for performance. When you updated files in S3, CloudFront was still serving the old cached version.

**The Solution:** After uploading to S3, you need to tell CloudFront to clear its cache (called "invalidation") so it fetches the new files.

## Configuration

For security, store your AWS configuration in a `.env` file (see `env.example`):
- Copy `env.example` to `.env`
- Fill in your AWS details
- `.env` is gitignored and won't be committed

You can also set environment variables directly:
```bash
export AWS_S3_BUCKET=your-bucket-name
export AWS_REGION=us-east-1
export CLOUDFRONT_DIST_ID=your-distribution-id
```

## Steps for Future Edits

1. Make your code changes
2. Run `./deploy-aws.sh`
3. If automatic invalidation fails, manually invalidate CloudFront cache (see above)
4. Wait 1-2 minutes and check your site

