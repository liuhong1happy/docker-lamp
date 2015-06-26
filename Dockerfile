# 基础镜像
FROM docker-ubuntu
# 维护人员
MAINTAINER  liuhong1.happy@163.com
# 添加环境变量
ENV USER_NAME admin
ENV SERVICE_ID lamp
# 安装apache2、mysql、php
RUN apt-get -y install git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-mcrypt && \
  echo "ServerName localhost" >> /etc/apache2/apache2.conf

# mysql环境变量
ENV MYSQL_PASS 123456

# 配置mysql
RUN /etc/init.d/mysql start
ADD mysql.cnf /etc/mysql/conf.d/mysql.cnf
RUN rm -rf /var/lib/mysql/*
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh && sh /create_mysql_admin_user.sh

# 配置apache2
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN /etc/init.d/apache2 start

# 加载欢迎页面
RUN git clone https://github.com/fermayo/hello-world-lamp.git /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

# PHP环境变量
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

VOLUME  ["/etc/mysql", "/var/lib/mysql","/app","/etc/apache2" ]

# 默认暴露80端口
EXPOSE 80 3306
# 配置supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# 启动supervisord
CMD ["/usr/bin/supervisord"]

