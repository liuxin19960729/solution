## 使用命令连接到服务器
```
mysql 客户端程序 和其他客户端的连接使用起来差不多.(mysqldump、mysqladmin或 mysqlshow)


mysql
   默认主机名是localhost. 在 Unix 上，这有一个特殊的含义，如下所述。
   Windows 上的默认用户名ODBC或 Unix 上的 Unix 登录名。
   


 mysql -p liuxin_test
    liuxin_test 选择的数据库(use liuxin_test)


如果用户没有密码
    mysql -uxxx  --skip-password



程序未指定-h 或指定-hlocalhost 
   Windows:服务器启动时shared_memory启用了系统变量以支持共享内存连接，则客户端使用共享内存进行连接
   Unix:服务端使用套接字文件进行连接
      指定套接字名称 --socket 选项或MYSQL_UNIX_PORT 环境变量可用于指定套接字名称。

  Windows -h. (--host=.) or tcp 未启动 or --socket 未指定  or host 是空,客户端使用命名管道连接
       不支持命名管道连接，或者建立连接的用户不是 named_pipe_full_access_group 系统变量指定的 Windows 组的成员，则会发生错误。

  否则连接tcp


--port -P 指定客户端的连接端口号
        要指定mysql的主机，请使用 MYSQL_HOST.
        在 Windows 上，要指定 MySQL 用户名，请使用 USER.
        要指定密码，请使用MYSQL_PWD. 但是，这是不安全的；
            不安全的环境变量
            export MYSQL_PWD=xxx
```