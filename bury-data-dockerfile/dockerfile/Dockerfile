# 1.基础镜像centos
FROM centos

# 2.标识镜像信息
MAINTAINER zhangyj "zhangyj@19pay.com.cn"

# 3.复制并解压安装包
# 3.1复制nginx的安装包到 container的指定目录,并自动解压
RUN mkdir -p /usr/local/src
ADD nginx-1.16.1.tar.gz /usr/local/src
ADD apache-flume-1.9.0-bin.tar.gz /usr/local/src
ADD jdk-8u141-linux-x64.tar.gz /usr/local/src

# 4 flume配置与依赖
# 4.1 flume 配置jdk
COPY ./conf/flume-env.sh /usr/local/src/apache-flume-1.9.0-bin/conf
# 4.2 flume 依赖
COPY ./libs/* /usr/local/src/apache-flume-1.9.0-bin/lib/

# 5 安装crontab
RUN yum install -y cronie
RUN yum -y install logrotate

# 6 安装nginx
RUN useradd -M -s /sbin/nologin nginx
# 6.1 安装nginx的基础依赖
# 每个RUN指令都会在一个新的container里面运行，并提交iamge作为下一个RUN的base
RUN yum install -y gcc gcc-c++ glibc make autoconf openssl openssl-devel
RUN yum install -y libxslt-devel -y gd gd-devel pcre pcre-devel
RUN yum install -y wget httpd-tools
# 6.2 执行当前工作目录（等于cd）
WORKDIR /usr/local/src/nginx-1.16.1
# 6.3 安装nginx
RUN mkdir -p /var/cache/nginx/
RUN mkdir -p /var/run/
RUN ./configure --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --user=nginx --group=nginx --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-mail --with-mail_ssl_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic -fPIC' --with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie'
RUN make && make install
# 6.5 nginx 配置文件
COPY ./conf/nginx.conf /etc/nginx/
# 6.6 nginx 应用
COPY ./conf/burieddata-nginxapp-dyg-0.0.1-SNAPSHOT.jar /usr/local/src

# 7 设置环境变量,后续的RUN使用此变量
ENV PATH /etc/nginx/sbin:/usr/local/src/jdk1.8.0_141/bin:/usr/local/src/apache-flume-1.9.0-bin/bin:$PATH

# 8 挂载一个同享目录
VOLUME ['/usr/local/src']

# ----------------  应用配置 ------------------

# 1 设置日志切割定时任务
RUN mkdir -p /usr/local/src/logs/logroate
RUN touch /usr/local/src/logs/logroate/logroate-status
COPY ./conf/logspilt-logrotate /etc/logrotate.d/
# 定时切割日志定时任务
COPY ./conf/log-crontab /usr/local/src
WORKDIR /usr/local/src
RUN crontab log-crontab

# 2 flume 数据采集配置
COPY ./conf/flume_hcz_data.conf /usr/local/src

# 3 nginx应用日志存放目录
# 惠充值数据埋点存放目录
RUN mkdir -p /usr/local/src/logs/hcz/burydata
RUN mkdir -p /usr/local/src/logs/hcz/burydata/backup
RUN mkdir -p /usr/local/src/logs/hcz/burydata/flume
# ---------------  应用配置   ------------

# 声明端口
EXPOSE 80

ENTRYPOINT (/sbin/crond start) && (nginx) && (flume-ng agent --conf-file  /usr/local/src/flume_hcz_data.conf -c /usr/local/src/apache-flume-1.9.0-bin/conf/ --name a1 &) && (java -jar burieddata-nginxapp-dyg-0.0.1-SNAPSHOT.jar) && /bin/bash