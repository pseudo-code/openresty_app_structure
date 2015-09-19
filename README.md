#README

关于openresty
===============

>*OpenResty （也称为 ngx_openresty）是一个全功能的 Web 应用服务器，它打包了标准的 Nginx 核心，很多的常用的第三方模块，以及它们的大多数依赖项。*

>*OpenResty 通过汇聚各种设计精良的 Nginx 模块, 从而将 Nginx 有效的变成一个强大的 Web 应用服务器,
这样, Web 开发人员可以使用 Lua 脚本语言调动 Nginx 支持的各种 C 以及 Lua 模块,
快速构造出足以胜任 10K+ 并发连接响应的超高性能 Web 应用系统.*

[openresty官网](http://openresty.org/ "http://openresty.org/") | [中文](http://openresty.org/cn/ "http://openresty.org/cn/")



openresty构建在nginx的ngx_lua模块之上，更多nginx api for lua请查看：[ngx_lua](https://www.nginx.com/resources/wiki/modules/lua/#nginx-api-for-lua "https://www.nginx.com/resources/wiki/modules/lua/#nginx-api-for-lua")


关于本项目
============

本项目针对openresty开发，设计了一个比较完整的项目工程，在开发前期可以直接使用，省去项目搭建的工作。


目录结构说明
============

1. config 存放nginx配置(路径映射，端口等)，lua包地址<br>
  * globe_config.lua 设置mysql、redis、ssdb等相关配置信息，可以在lua代码中访问
  * app.conf 设置监听端口，映射路径等信息
  * mime.types mime类型列表
  * myapp.sh 启动脚本
  * nginx.conf nginx的配置文件

2. handler 存放lua脚本，对应具体的业务接口，同时路径对应访问地址

3. module 各种lua模块
  * resty 存放openresty提供的各种模块以及各种第三方模块
  * service 存放根据项目需要自己实现的模块

4. test 测试脚本存放目录


关于部署
========

1. 安装openresty<br>
  请查看openresty官网的安装说明
2. 下载完整的app1工程，放置到/opt目录下（可以根据自己的需要更改目录，记得更改config/nginx.conf、config/app.conf两个配置文件）
3. 启动
  ```
  nginx -c "/opt/app1/config/nginx.conf"
  ```
  或者
  ```
  /opt/app1/config/myapp.sh start
  ```
4. 测试
  访问http://localhost:18888/app1/test_json





