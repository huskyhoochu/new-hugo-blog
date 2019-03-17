#! /usr/bin/env bash

echo -e '\n\033[1;32mDeploying Start...\033[0m\n'

now

echo -e '\n\033[1;32mDone.\n\nCurrent deploy statement is:\033[0m\n'

now ls hugo-blog

list_url=`now ls hugo-blog`

old_url=`echo ${list_url} | cut -d ' ' -f15`

new_url=`echo ${list_url} | cut -d ' ' -f9`

echo -e '\nNew URL is: \033[1;35m' ${new_url} '\033[0m\n'

now alias ${new_url} www.huskyhoochu.com

echo -e '\nOld URL is: \033[1;35m' ${old_url} '\033[0m\n'

now rm -y ${old_url}

echo -e '\n\033[1;32mDone.\n\nFinal deploy statement is:\033[0m\n'

now ls hugo-blog

echo -e '\n\033[1;32mAll process is done.\033[0m\n'
