#!/bin/sh


echo "Zipping Function..."
zip function.zip ./function.pas
echo ""

echo "Updating function..."
#delete and re-create
aws lambda delete-function --function-name fpc-hello
aws lambda create-function --function-name fpc-hello --zip-file fileb://function.zip --handler function.handler --role arn:aws:iam::<your-id>:role/lambda-role --runtime provided --layers arn:aws:lambda:eu-west-1:743697633610:layer:fpc-runtime:20 

#update config and code
#aws lambda update-function-configuration --function-name fpc-hello --layers arn:aws:lambda:eu-west-1:743697633610:layer:fpc-runtime:20 --timeout 10
#aws lambda update-function-code --function-name fpc-hello  --zip-file fileb://function.zip

rm ./function.zip
echo ""

echo "Invoking Function..."
aws lambda invoke --function-name fpc-hello --payload '{"text":"Hello"}' response.txt
echo ""

echo "Full response..."
cat response.txt
rm response.txt
echo ""
