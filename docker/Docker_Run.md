# Docker run reference
```
在隔离的环境中Docker运行着这些进程。

一个容器就是一个在主机上运行的一个进程。

每一容器运行时有自己的文件系统,有自己的网络,有自己的进程树.

```

## General form
```
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

IMAGE 必须指定(容器需要知道从哪里去找运行的实例)

其他的值可以通过镜像开发者去设置默认值

  1.容器认证
  2.网络设置
  3.运行时内存和CPU数量
  4.后置模式

docker run [OPTIONS] 覆盖镜像开发者设置的默认值
```
## Operator exclusive options
### Detached （-d）
```
-d=false or -d不写前置模式


-d=true  or -d
后台模式
```

##  Foreground前台模式
```
default -d is not specific

note: -a没有设置默认 stderr stdout 
-a Attach to `STDIN`, `STDOUT` and/or `STDERR`
-t tty 让docker变成一个可以交互的程序 像shell 一样 
-i stdIn

note: 当从管道接收标准输入时不能使用 -t(tty)
    echo test | docker run -i busybox cat

```

## 容器认证 Container identification
```
--name 未指定名字会默认随机一个名字
--name 指定 可以在network 和 容器引用时使用

note:容器默认时桥接网络
```
## --cidfile
```
container identifier

未了实现自动化会把容器的ID写到 cidfile="" 指定的文件里面
```

## image[:tag]
```
通过指定容器+version 来精确的指定镜像
```

## Image[@digest]
```
docker run alpine@sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0 date

```

## --pid(PID 设置)
```
默认Container都是使用进程namespace
所有进程删除system 进程 view ,并且允许所有进程Ids包含PID=1的进程被重新使用

有些时候我们需要再容器中使用容器外的进程
   例如
     容器外的进程对容器内的程序 debuging tool(gdb or strace)


example
1.run htop inside a container
crate Dockerfile

FROM alpine:latest
RUN apk add --update htop && rm -rf /var/cache/apk/*
CMD ["htop"]

构建docker镜像
docker build -t myhtop  


docker run -it --rm --pid=host myhtop



or  --pid 引用其他进程
docker run -it --pid=container:my-redis my_strace_docker_image bash

```

## UTS
```
--uts

容器内部使用主机(HOST) UTS 命名空间
在UTS命名空间里 hostname 和 daomian运行的进程是可见的


```

## IPC --ipc
```
容器的IPC

””	Use daemon’s default.
“none”	 Own private IPC namespace, with /dev/shm not mounted.
“private”	Own private IPC namespace.
“shareable”	Own private IPC namespace, with a possibility to share it with other containers.
           拥有自己的命名空间可以与其他容器共享
“container: <_name-or-ID_>"	Join another (“shareable”) container’s IPC namespace.
   加入另一个容器的 IPC命名空间可以与其他容器共享
“host”	Use the host system’s IPC namespace.
        使用主机系统的命名空间

没有配置 默认的值依赖守护进程的version 和 configration

IPC(POSIX/SysVIPC) 命名空间支持 named shared memory segments ,samphores(信号量) and message queues

named shared memory segments：内存映射 而不是 网络 或者 Pipe



```

## Network settings
```
--dns=[] 给容器  设置dns 服务器(一个或多个)

--network="bridge"
      bridge： 使用默认的桥接网络栈(局域网)
          host:  docker0
          continers veth接口 
          节其他容器通信 访问 将信息传输到 docker0 在转到 其他veth接口 
      none： 没有网络
      host ：
        和主机共用网络堆栈(主机所有 intertfaces都可以对主机可用)
        mac 地址无效 host mode下
        --hostname, the --add-host, --dns, --dns-search, and --dns-option 的使用只会更改容器内部配置不会影响主机配置
        
        高性能的场景下 它的性能更加高 它使用的是主机的网络栈 而桥接使用的是 虚拟了一个类似于路由器的虚拟网络设备

        host下不需要设置端口映射

        note:赋予容器对本地的完全访问权限(例如 D-bus) 所以认为是不安全的
     container:'<network-name>|<network-id>' 连接到用户定义的网络
--network-alias=[] : Add network-scoped alias for the container  
         对动气添加网络范围的别名
--add-host: 给/etc/host(主机查询静态表)添加 一行
--mac-address="" 设置容器的mac地址
--ip=""    给容器设置ipv4
--ip6="" 给容器设置ipv6
--link-local-ip=[] 设置一个或多个本地链路地址

默认所有容器都开一网络能够向外链接
--network="none" 关闭网络 外出 和进入 

如果以要向其他容器通信只能通过默认的桥接模式(bridge).

```

## Network:Container
```
通过网络设置容器 一个容器将共享网络栈给另一个容器

note：

format:
  --network:container:docker id | docker name
note:
 --add-host --hostname --dns --dns-search --dns-option  --mac-address
 --publish --publish-all --expose  在另一个容器设置了 共享网络之后上面这些选项都会变的无效

for example:
docker run -d --name redis example/redis --bind 127.0.0.1
 
 docker run --rm -it --network container:redis example/redis-cli -h 127.0.0.1
```

## User-defined network
```
创建网络使多个网络可以使用IP地址进行相互连接
可以使用Docker 网络驱动 或者使用外部的网络驱动插件创建一个网络

简单示例:通过内部的桥接创建一个网络
 docker network create -d bridge my-net
 docker run --network=my-net -itd --name=container3 busybox
```
## Managing /etc/host
```
docker run -d=true -p80:80 --name=nginx --rm --add-host www.baidu.com:127.0.0.1  nginx 
docker exec -it nginx  cat /etc/hosts 
127.0.0.1	localhost
  ::1	localhost ip6-localhost ip6-loopback
  fe00::0	ip6-localnet
  ff00::0	ip6-mcastprefix
  ff02::1	ip6-allnodes
  ff02::2	ip6-allrouters
  127.0.0.1	www.baidu.com
  172.17.0.2	9d8aa519b516

容器是桥接模式 并且与其他容器 link , 会更新连接的名字到 /etc/host 
```

## Restart policies
```
--restart
指定docker在退出时是否应该重启

restart active 是 docker ps 查看 docker UP 或 Restaring的状态 可以是哟 docker events 来检查是否生效 


no: default
on-failure[:max-retries] : 非0状态退出(错误退出),会重启(有重试的错误限制)
always 不管退出状态如何总是重启
unless-stopped:总是重启 除非在之前 stop

每次启动都会在上一休的基础上增加延迟(2倍,初始化 100ms)
  100ms 200 400.......until on-failure limit ,or docker stop  docker rm 
在容器restart 启动期间 启动成功(10s 运行时间) ,延迟秒数又会被初始化到100ms

on-failture 指定重启次数  默认是always
docker run -d=true -p80:80 --name=nginx  --restart=on-failure:2  nginx (--rm 不能使用)

产看重启次数 已经重启了多少次
 docker inspect  -f "{{ .RestartCount }}" nginx 

查看重新启动的时间
docker inspect -f "{{ .State.StartedAt }}" my-container
```

## Exit Status
```
正确 为0
如果发生错误则是守护进程本生

docker run -p80:80 --name=nginx   nginx /bin/sh   -c  'exit 3'

启动  Foreground 模式启动 shell 进程启动程序 退出时 容器进程向 shell 进程抛出了退出码

```

## CleanUp (--rm)
```
default: 容器exit时容器的文件系统任然存在的

--rm 容器退出时删除容器 和匿名卷 (和 docker rm -v  相似)


```

### Security configuration
```

Option	Description
--security-opt="label=user:USER"	Set the label user for the container
      设置用户标签
--security-opt="label=role:ROLE"	Set the label role for the container
      设置角色标签
--security-opt="label=type:TYPE"	Set the label type for the container
    设置类型标签
--security-opt="label=level:LEVEL"	Set the label level for the container
      设计level标签
--security-opt="label=disable"	Turn off label confinement for the container
       关闭容器的标签限制
--security-opt="apparmor=PROFILE"	Set the apparmor profile to be applied to the container
   设置容器的 profile
--security-opt="no-new-privileges:true"	Disable container processes from gaining new privileges
      静止容器(进程) 或的新的特权
--security-opt="seccomp=unconfined"	Turn off seccomp confinement for the container
   
--security-opt="seccomp=profile.json"	White-listed syscalls seccomp Json file to be used as a seccomp filter
  系统调用设置白名单


--security-opt 覆盖容器默认的标签



 docker run --security-opt label=disable -it fedora bash   关闭容器的安全标签

 运行容器只能监听 svirt_apache_t 端口的容器  
 docker run --security-opt label=type:svirt_apache_t -it centos bash
 note: svirt_apache_t 自己定义POlicy

不允许容器获得新的特权(su 和 sudo 将不在工作 只能使用自己进程的特权)
docker run --security-opt no-new-privileges -it centos bash

```

## Specific an init process
```
--init 指明 初始化进程作为作为容器进程PID=1
docker守护进程在系统路径中发现 docker-init 的可执行文件
docker-init 二进制文件由 tini支持
```

## Specify custom cgroups
```
--cgroup-parent
允许创建和管理组
你可以将你定义的资源放在 parent group 下

```

## Runtime constraints on resources (在资源上进行限制)
```
-m, --memory="" 
  单位 b k m g
  最小值 4m

--memory-swap="" 
    单位 b k m g
   memory+sway = total memory 
   
--memory-reservation=""
  内存soft limit

--kernel-memory="" 内核内存限制 最小 4m

-c, --cpu-shares=0
     cpu的权重设置

--cpus=0.000
    cpu 的数量  0.000 表示没有限制
  
```