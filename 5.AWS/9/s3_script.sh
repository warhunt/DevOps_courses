#!/bin/bash
s3_bucket=wolly.bucketfortestglacier

function download {
    echo `aws s3 cp s3://$s3_bucket $1 --recursive`
}

function upload {
    echo `aws s3 cp $1 s3://$s3_bucket --recursive`
}

function delete {
    echo `aws s3 rm s3://$s3_bucket --recursive`
}

echo "Available action:"
echo "  1 - Download from S3 bucket"
echo "  2 - Upload to S3 bucket"
echo "  3 - Delete from S3 bucket"

read -p "Chooise action: " action

case $action in 
    1 ) read -p "Enter destination path: " destination_path
        download $destination_path
        ;;
    2 ) read -p "Enter source path: " source_path
        upload $source_path
        ;;
    3 ) read -p "Are you sure? (y / n) " answer
        case $answer in 
            y ) delete
                ;;
            n ) ;;
            * ) echo "Invalid answer"
                exit 1
                ;;
        esac
        ;;
    * ) echo "Invalid action"
        exit 1
        ;;
esac