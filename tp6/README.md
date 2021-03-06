ThinkPHP 6.0
===============

> 运行环境要求PHP7.1+。

## 主要新特性

* 采用`PHP7`强类型（严格模式）
* 支持更多的`PSR`规范
* 原生多应用支持
* 更强大和易用的查询
* 全新的事件系统
* 模型事件和数据库事件统一纳入事件系统
* 模板引擎分离出核心
* 内部功能中间件化
* SESSION/Cookie机制改进
* 对Swoole以及协程支持改进
* 对IDE更加友好
* 统一和精简大量用法

## 安装

~~~
composer create-project topthink/think tp 6.0.*-dev
~~~

拿到源码后，需更新框架
~~~
composer update topthink/framework
~~~


## 部署
1、导入mysql数据库，并配mysql连接配置 ./config/database.php
2、拷贝根目录 .example.env 文件为 .env，并配置相应的参数（注意：此配置的优先级最高，如app_debug需在此配置）
3、修改应用id和密钥
    a.更换mysql.tp_app 中appid 和 app_salt
    b.更换前端代码配置 ./src/setting.js appid 和 appSecret
    注意：修改密钥之后，账号密码需重新生成



## 文档

[完全开发手册](https://www.kancloud.cn/manual/thinkphp6_0/content)

## 参与开发

请参阅 [ThinkPHP 核心框架包](https://github.com/top-think/framework)。

## 版权信息

ThinkPHP遵循Apache2开源协议发布，并提供免费使用。

本项目包含的第三方源码和二进制文件之版权信息另行标注。
