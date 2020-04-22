# 1.基础镜像centos
FROM centos
MAINTAINER zhangyj "zhangyj@19pay.com.cn"

# 2.创建目录与资源拷贝
RUN mkdir -p /usr/local/src
# logroate 日志
RUN mkdir -p /usr/local/src/logs/logroate
# nginx日志
RUN mkdir -p /usr/local/src/logs/nginx

# 复制并解压安装包
ADD apache-flume-1.9.0-bin.tar.gz /usr/local/src
ADD jdk-8u181-linux-x64.tar.gz /usr/local/src
COPY nginx.repo /etc/yum.repos.d/

#设置时区
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# 3 安装nginx
RUN mkdir -p /etc/nginx/html
RUN yum install -y nginx
# nginx 配置文件
COPY nginx.conf /etc/nginx/

# 4 设置环境变量,后续的RUN使用此变量
ENV PATH /etc/nginx/sbin:/usr/local/src/jdk1.8.0_181/bin:/usr/local/src/apache-flume-1.9.0-bin/bin:$PATH

# 5 访问日志切割配置与安装
# 安装crontab
RUN yum install -y cronie
RUN yum -y install logrotate
# 设置日志历史日志定期删除
RUN touch /usr/local/src/logs/logroate/logroate-status
COPY spilt_logs.sh /usr/local/src/
COPY log-crontab /usr/local/src
WORKDIR /usr/local/src
# 定时日志历史日志定期删除
RUN crontab log-crontab

WORKDIR /usr/local/src/

# flume检查点
RUN mkdir -p /usr/local/src/apache-flume-1.9.0-bin/fileCHK
RUN mkdir -p /usr/local/src/apache-flume-1.9.0-bin/fileData

COPY nginx_flume_start.sh /usr/local/src/
RUN chmod 777 nginx_flume_start.sh
# 7 声明端口
EXPOSE 80
ENTRYPOINT ["./nginx_flume_start.sh"]