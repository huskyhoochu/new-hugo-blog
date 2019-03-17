#! /usr/bin/env bash

yum install -y wget

wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz
tar -xzf hugo_0.54.0_Linux-64bit.tar.gz

yarn install
rm -rf public
rm -rf resources
./hugo --gc
