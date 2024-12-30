# 使用官方 PHP 镜像，带 FPM 支持
FROM php:8.4.2-fpm

# 设置时区变量
ENV TZ=Asia/Tokyo

# 安装 nginx 和其他必要工具
RUN apt-get update && apt-get install -y \
    tzdata \
    nginx \
    vim \
    curl \
    unzip \
    && docker-php-ext-install pdo pdo_mysql && apt-get install -y libmariadb-dev \
                                                && docker-php-ext-install pdo pdo_mysql mysqli \
                                                && docker-php-ext-enable pdo pdo_mysql mysqli \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
        dpkg-reconfigure -f noninteractive tzdata


# 安装 Composer（PHP 包管理器）
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 创建日志目录
RUN mkdir -p /var/log/php-fpm && mkdir -p /var/log/php

# 设置工作目录
WORKDIR /var/www/html

# 复制 PHP 项目代码到容器中
COPY ./project_dir/app ./app

# 复制 nginx, php, php-fpm 配置文件
COPY ./deploy/deploy_php/nginx.conf /etc/nginx/nginx.conf
COPY ./deploy/deploy_php/docker-fpm.ini /usr/local/etc/php/conf.d/docker-fpm.ini
COPY ./deploy/deploy_php/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

# 复制启动脚本
COPY ./deploy/deploy_php/start.sh /start.sh
RUN chmod +x /start.sh

# 设置权限
RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /var/log/php
RUN chown -R www-data:www-data /var/log/php-fpm

# 暴露 HTTP 端口
EXPOSE 80

# 使用启动脚本启动 nginx 和 php-fpm
CMD ["/start.sh"]
