#!/bin/sh

echo "Zipping runtime..."
zip -r runtime.zip ./*
echo ""

echo "Updating runtime layer..."
aws lambda publish-layer-version --layer-name fpc-runtime --zip-file fileb://runtime.zip
rm runtime.zip