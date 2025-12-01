# Deploying to AWS

This guide covers two methods to deploy your Astro site to AWS.

## Option 1: AWS Amplify (Recommended - Easiest)

AWS Amplify is the easiest way to deploy your Astro site with automatic builds and deployments.

### Prerequisites
- AWS Account
- GitHub repository with your code

### Steps

1. **Push your code to GitHub** (if not already):
   ```bash
   git add .
   git commit -m "Ready for deployment"
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

2. **Go to AWS Amplify Console**:
   - Visit https://console.aws.amazon.com/amplify/
   - Click "New app" → "Host web app"
   - Select "GitHub" and authorize AWS to access your repository

3. **Configure Build Settings**:
   Amplify should auto-detect Astro, but if not, use these settings:
   
   **Build settings:**
   ```yaml
   version: 1
   frontend:
     phases:
       preBuild:
         commands:
           - npm ci
       build:
         commands:
           - npm run build
     artifacts:
       baseDirectory: dist
       files:
         - '**/*'
     cache:
       paths:
         - node_modules/**/*
   ```

4. **Deploy**:
   - Click "Save and deploy"
   - Amplify will build and deploy your site
   - You'll get a URL like: `https://main.xxxxx.amplifyapp.com`

5. **Custom Domain (Optional)**:
   - In Amplify console, go to "Domain management"
   - Add your custom domain
   - Follow the DNS configuration steps

### Benefits
- ✅ Automatic deployments on git push
- ✅ Preview deployments for pull requests
- ✅ Free SSL certificate
- ✅ CDN included
- ✅ Easy rollbacks

---

## Option 2: S3 + CloudFront (More Control)

This method gives you more control but requires manual setup.

### Prerequisites
- AWS CLI installed and configured
- AWS Account with S3 and CloudFront access

### Steps

1. **Build your site locally**:
   ```bash
   npm run build
   ```
   This creates a `dist` folder with your static site.

2. **Create an S3 bucket**:
   ```bash
   aws s3 mb s3://your-site-name --region us-east-1
   ```

3. **Enable static website hosting**:
   ```bash
   aws s3 website s3://your-site-name \
     --index-document index.html \
     --error-document 404.html
   ```

4. **Set bucket policy for public read access**:
   Create a file `bucket-policy.json`:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Sid": "PublicReadGetObject",
         "Effect": "Allow",
         "Principal": "*",
         "Action": "s3:GetObject",
         "Resource": "arn:aws:s3:::your-site-name/*"
       }
     ]
   }
   ```
   
   Apply it:
   ```bash
   aws s3api put-bucket-policy --bucket your-site-name --policy file://bucket-policy.json
   ```

5. **Upload your site**:
   ```bash
   aws s3 sync dist/ s3://your-site-name --delete
   ```

6. **Create CloudFront distribution** (for better performance and HTTPS):
   - Go to CloudFront console
   - Create distribution
   - Origin domain: `your-site-name.s3-website-us-east-1.amazonaws.com`
   - Viewer protocol policy: "Redirect HTTP to HTTPS"
   - Default root object: `index.html`
   - Create distribution

7. **Deploy script** (create `deploy.sh`):
   ```bash
   #!/bin/bash
   npm run build
   aws s3 sync dist/ s3://your-site-name --delete
   aws cloudfront create-invalidation --distribution-id YOUR_DIST_ID --paths "/*"
   ```

### Benefits
- ✅ More control over infrastructure
- ✅ Lower cost for high traffic
- ✅ Can use with CI/CD pipelines

---

## Option 3: AWS Lambda@Edge (For SSR - Not needed for your static site)

Your current site is static, so this isn't necessary. Only use if you add server-side rendering later.

---

## Quick Deploy Script

Create a simple deploy script for S3 method:

```bash
#!/bin/bash
# deploy.sh

echo "Building site..."
npm run build

echo "Uploading to S3..."
aws s3 sync dist/ s3://your-site-name --delete

echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation \
  --distribution-id YOUR_DIST_ID \
  --paths "/*"

echo "Deployment complete!"
```

Make it executable:
```bash
chmod +x deploy.sh
```

---

## Environment Variables

If you need environment variables (e.g., for API keys):

**Amplify:**
- Go to App settings → Environment variables
- Add your variables there

**S3/CloudFront:**
- Use AWS Systems Manager Parameter Store
- Or build-time environment variables in your deploy script

---

## Cost Estimate

- **Amplify**: Free tier includes 15 GB storage, 5 GB served per month
- **S3**: ~$0.023 per GB storage, $0.005 per 1,000 requests
- **CloudFront**: First 1 TB free, then ~$0.085 per GB

For a personal portfolio site, costs should be minimal (< $1/month).

---

## Troubleshooting

**Build fails in Amplify:**
- Check build logs in Amplify console
- Ensure `package.json` has correct build script
- Verify Node.js version (Amplify uses Node 18 by default)

**404 errors on direct page access:**
- Add `_redirects` file in `public/` folder:
  ```
  /*    /index.html   200
  ```

**PDF not downloading:**
- Ensure PDF is in `public/` folder
- Check file permissions
- Verify MIME types in S3/CloudFront

---

## Next Steps

1. Choose your deployment method
2. Set up your AWS account
3. Deploy!
4. Configure custom domain (optional)
5. Set up CI/CD for automatic deployments



