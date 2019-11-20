#!/bin/bash

set -e

host=foo
port=22

echo -n "login: "
read username
if [ x"$username" = x ]
then
	exit 1
fi

ssh -p"${port}" -l"${username}" "${host}"
