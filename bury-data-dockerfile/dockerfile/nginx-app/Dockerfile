# 1.基础镜像centos
FROM centos
MAINTAINER zhangyj "zhangyj@19pay.com.cn"

# 2.创建目录与资源拷贝
RUN mkdir -p /usr/local/src

# 复制并解压安装包
ADD jdk-8u181-linux-x64.tar.gz /usr/local/src
# web应用
COPY burieddata-nginxapp-dyg-0.0.1-SNAPSHOT.jar /usr/local/src

# 3 设置环境变量,后续的RUN使用此变量
ENV PATH /etc/nginx/sbin:/usr/local/src/jdk1.8.0_181/bin:$PATH

WORKDIR /usr/local/src/

# 4 声明端口
EXPOSE 8888

# 5 运行环境
CMD ["nohup","java","-jar","/usr/local/src/burieddata-nginxapp-0.0.1-SNAPSHOT.jar","&"]