#! /usr/bin/env bash

yarn build
cd ./public
cp -r . ../../huskyhoochu.github.io/
cd ../../huskyhoochu.github.io
git add .

# Commit changes.
msg="rebuilding site `date '+%Y-%m-%d %H:%M:%S'`"
git commit -m "$msg"

# Push source and build repos.
git push origin master
