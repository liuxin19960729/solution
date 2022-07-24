## 下载社区版image
```
docker pull mysql/mysql-server:tag
tag: 5.6, 5.7, 8.0, or lates

docker pull  mysql/mysql-serve:5.7


需要 docker cli login 
从oracle 注册下载(Oracle Container Register)
docker pull container-registry.oracle.com/mysql/community-server:5.7
```

## 下载企业版 image
```
需要 docker cli login 
docker pull  container-registry.oracle.com/mysql/enterprise-server:tag

下载mysql arachive 文件 输出
docker load -i mysql-enterprise-server-version.tar

```

## 检查镜像是否下载成功
```
docker images 
```


## 创建镜像实例
```
docker run --name=container_name  --restart on-failure -d image_name:tag
docker run --help 
--name string    指定容器名称
--restart  重启策略  当容器存在重启
-d 后台运行容器并且 答应容器ID
```

## 由于 -d 选项是后台执行
```
docker logs mysql1 查看 mysql的日志
```

## 使用默认密码登录
```
docker exec -it mysql_1 mysql -uroot -p
```

## 修改默认密码
```
ALTER USER 'root'@'localhost' IDENTIFIED BY 'liuxin';
```

## Mysql Continer bash shell
```
docker exec mysql_1 bash
```

## 容器内部服务器数据存储地方
```
/var/lib/mysql
```

## 运行 Mysql容器并设置
```

1.通过docker选项的方式设置mysql server

docker run --name mysql1 -d mysql/mysql-server:tag --character-set-server=utf8mb4 --collation-server=utf8mb4_col

docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

设置 default charset 和 collation-server

2.通过准备的配置文件来这只mysql配置

docker inspect   (Return low-level information on Docker objects)




docker inspect mysql1
docker都是零时的当容器删除数据全部没有 , docker提供一种使有用的数据挂载到真实机器上的目录上的一个设置 
...
 "Mounts": [
            {
                "Type": "volume",
                "Name": "4f2d463cfc4bdd4baebcb098c97d7da3337195ed2c6572bc0b89f7e845d27652",
                "Source": "/var/lib/docker/volumes/4f2d463cfc4bdd4baebcb098c97d7da3337195ed2c6572bc0b89f7e845d27652/_data",
                "Destination": "/var/lib/mysql",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ],
Source 容器真实的挂载到的地方

4.另一种方式使用 --mount 选型提供绑定选项

docker run --name=mysql1 \
--mount type=bind,src=/path-on-host-machine/my.cnf,dst=/etc/my.cnf \
--mount type=bind,src=/path-on-host-machine/datadir,dst=/var/lib/mysql \
-d mysql/mysql-server:tag



note:
--mount type=bind,src=/path-on-host-machine/my.cnf,dst=/etc/my.cnf
将  dst 的地方的目录挂载src地址上


--mount mount                    Attach a filesystem mount to the container 挂载到文件系统上

/etc/cnf 服务器配置文件

```

## 创建容器运行初始化脚本
```
创建mysql并且立即执行.sh 和 .sql脚本
docker run --name=mysql1 \
--mount type=bind,src=/path-on-host-machine/scripts/,dst=/docker-entrypoint-initdb.d/ \
-d mysql/mysql-server:tag
```

## 在另一个Docker容器中连接Mysql
```
docker network create my-custom-net

将客户机和服务器放到网上 my-custom-net
docker run --name=mysql1 --network=my-custom-net -d mysql/mysql-server
docker run --name=myapp1 --network=my-custom-net -d myapp

在客户端容器里面使用 server name 作为 host来进行访问
```

## 服务器错误日志
```
服务器首次启动一般没有错误日志

1.通过挂载的方式设置挂载log_error 
 --mount type=bind src= /host-pat/log_error, dts=

2. mysql8.0   Docker environment variable MYSQL_LOG_CONSOLE is true 
  默认是 stderr 输出  通过  docker logs containername


   
配置文件错误输出的位置   
1.--log-error =/path/filename
2.在挂载到host主机上
```

## 通过MySql来进行Mysql的逻辑备份
```
1.确保 --mount type=bind  .....datadir



$> docker run --entrypoint "/bin/sh" \ 
--mount type=bind,src=/path-on-host-machine/datadir/,dst=/var/lib/mysql \
--mount type=bind,src=/path-on-host-machine/backups/,dst=/data/backups \
--rm mysql/mysql-server:8.0 \
-c "mysqldump -uadmin --password='password' --all-databases > /data/backups/all-databases.sql"


--entrypoint 容器启动之后 调用 system shell
--rm 会在退出容器后删除容器
-c在容器中执行 mysqldump 命令(sh -c 通过读取字符串被执行) 

```

## 恢复其存储的数据
```
1.确保Mysql服务器在容器中,并且你想把数据恢复到上面
2.启动一个有Mysql 服务的容器 恢复使用客户端进行对数据的恢复

```

## Know Issues
```
在容器中配置audit_log_file =xxx系统变量
使用 loose  选项 Docker不能够启动服务

```

## Docker Environment Variables
```
-e |  --env 配置环境变量

```