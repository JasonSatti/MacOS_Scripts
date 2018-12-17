#!/usr/bin/env bash
## Download Amazon s3 Bucket file
## Dakr-xv

## Location of file locally
OUTPUT_FILE="path where you want the file to be downloaded"
## Location of file on AWS s3 bucket
AWS_FILE="path of the file on the aws s3 bucket" 
## Bucket you want to download from
AWS_BUCKET="name of the bucket you want to download from"
RESOURCE="/${AWS_BUCKET}/${AWS_FILE}"
## Signature info
CONTENT_TYPE="application/x-apple-diskimage" 
DATE=`TZ=GMT date -R`
STRING_TO_SIGN="GET\n\n${CONTENT_TYPE}\n${DATE}\n${RESOURCE}"
## AWS key, secret and signature
S3_KEY="XXXXXXXXXXXXXXXXXX"
S3_SECRET="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
SIGNATURE=`echo -en ${STRING_TO_SIGN} | openssl sha1 -hmac ${S3_SECRET}\
 -binary | base64`
## Download File
curl -H "Host: ${AWS_BUCKET}.s3.amazonaws.com" \
     -H "Date: ${DATE}" \
     -H "Content-Type: ${CONTENT_TYPE}" \
     -H "Authorization: AWS ${S3_KEY}:${SIGNATURE}" \
     https://${AWS_BUCKET}.s3.amazonaws.com/${AWS_FILE} -o $OUTPUT_FILE