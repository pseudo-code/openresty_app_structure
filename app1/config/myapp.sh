#!/bin/sh 
nginx_path="/usr/local/openresty/nginx/sbin/nginx"
help(){
	#print usage
	echo "USAGE: myapp.sh start/stop/reload"
	exit 0
}
error(){
	echo "$nginx_path not found."
	exit 0
}
[ -z "$1" ] && help
[ ! -x "$nginx_path" ] && error

if [ "$1" = "start" ]; then
	$nginx_path -c "/opt/app1/config/nginx.conf"
elif [ "$1" = "stop" ]; then
	ngpid=`cat /usr/local/openresty/nginx/logs/nginx.pid`
	[ -n "$ngpid" ] && kill -quit $ngpid 
elif [ "$1" = "reload" ]; then
	$nginx_path -c "/opt/app1/config/nginx.conf" -s reload
fi
