#! /usr/bin/env bash

yarn build
cp now.json public
cd public
now
