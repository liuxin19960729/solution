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

###  Foreground前台模式
```
default -d is not specific

note: -a没有设置默认 stderr stdout 
-a Attach to `STDIN`, `STDOUT` and/or `STDERR`
-t tty 让docker变成一个可以交互的程序 像shell 一样 
-i stdIn

note: 当从管道接收标准输入时不能使用 -t(tty)
    echo test | docker run -i busybox cat

```

### 容器认证 Container identification
```
--name 未指定名字会默认随机一个名字
--name 指定 可以在network 和 容器引用时使用

note:容器默认时桥接网络
```
### --cidfile
```
container identifier

未了实现自动化会把容器的ID写到 cidfile="" 指定的文件里面
```

### image[:tag]
```
通过指定容器+version 来精确的指定镜像
```

### Image[@digest]
```
docker run alpine@sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0 date

```

### --pid(PID 设置)
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

### UTS
```
--uts

对容器设置UTS的命名空间,设置主机名(hostname)在运行进程里的命名空间里的可见域

默认情况下 所有容器 包含--network=host的容器都有他们自己的命名空间


-hostname 和 -domainname 在 UTS模式host模式下是不合法的

```

### IPC
```
容器的IPC

””	Use daemon’s default.
“none”	 Own private IPC namespace, with /dev/shm not mounted.
“private”	Own private IPC namespace.
“shareable”	Own private IPC namespace, with a possibility to share it with other containers.
“container: <_name-or-ID_>"	Join another (“shareable”) container’s IPC namespace.
“host”	Use the host system’s IPC namespace.


```