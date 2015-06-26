# docker-lamp
Docker化LAMP

## 镜像特点

- 2015/6/26 继承基础镜像docker-ubuntu

## 使用方法

- 获取代码并构建

        git clone https://github.com/Dockerlover/docker-lamp.git
        cd docker-lamp
        docker build -t docker-lamp .

- 运行容器

docker run -d -it --name lamp -p 8080:80 -p 3306:3306 docker-lamp
