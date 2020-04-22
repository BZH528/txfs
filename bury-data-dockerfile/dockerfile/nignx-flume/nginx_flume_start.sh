#!/bin/bash

source /etc/profile

# 启动nginx
nginx

# 启动日志切割服务
/sbin/crond start

# 启动flume
cd /usr/local/src/apache-flume-1.9.0-bin
bin/flume-ng agent -n a1 -c conf -f conf/flume_txfs_data.conf -Dflume.root.logger=INFO,console