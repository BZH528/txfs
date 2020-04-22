#!/bin/bash
#设置日志文件存放目录
logs_path="/usr/local/src/logs/nginx/"
#设置pid文件
pid_path="/var/run/nginx.pid"
#日志文件
filepath=${logs_path}"web.log"
# Source function library.
#重命名日志文件
mv ${logs_path}web.log ${logs_path}web_`date -d '-1 day' '+%Y%m%d'`.log
#向nginx主进程发信号重新打开日志
kill -USR1 `cat ${pid_path}`


# 删除3天前日志
before_3day=`/bin/date "+%Y%m%d" -d "-3 day"`
echo "remove /usr/local/src/logs/nginx/web_${before_3day}.log"
rm -rf /usr/local/src/logs/nginx/web_${before_3day}.log