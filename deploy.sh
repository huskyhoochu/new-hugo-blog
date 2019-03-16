#! /usr/bin/env bash

now

now ls hugo-blog

list_url=`now ls hugo-blog`

old_url=`echo ${list_url} | cut -d ' ' -f15`

new_url=`echo ${list_url} | cut -d ' ' -f9`

echo -e "\nOld URL is:" ${old_url} "\n"

now rm -y ${old_url}

echo -e "\nNew URL is:" ${new_url} "\n"

now alias ${new_url} www.huskyhoochu.com
