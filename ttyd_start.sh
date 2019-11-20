#!/bin/bash

port=7890

ttyd -p"${port}" --ssl \
	--ssl-cert ~/ttyd_ssl_cert/server.crt \
	--ssl-key  ~/ttyd_ssl_cert/server.key \
	bash -c    ./ttyd_login.sh
