[official](https://dev.mysql.com/doc/refman/5.7/en/linux-installation-yum-repo.html#yum-repo-setup)
## 下载 rpm 包
```
wget https://dev.mysql.com/get/mysql80-community-release-el7-6.noarch.rpm
```
## 添加 Mysql Yum 仓库
```
yum localinstall mysql80-community-release-el7-6.noarch.rpm 
```
## 检查是否安装成功
```
yum repolist enabled | grep "mysql.*-community.*"
```

## 编辑 rep file配置版本
```
 /etc/yum.repos.d/mysql-community.repo 
```

## 选择发布系列
```
MySQL 社区服务器的不同版本系列托管在不同的子存储库中

列举仓库所有mysql相关的
yum repolist all | grep mysql

yum-config-manager 工具编辑
禁用 mysql80-community
yum-config-manager --disable mysql80-community
开启 mysql57-community
yum-config-manager --enable  mysql57-community


手动编辑
/etc/yum.repos.d/etc/yum.repos.d

name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql-2022
       file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql


enabled=1
 1开启 0进制

任何时候只开启一个版本的存储库

再次检查mysql 那些库是开启的
yum repolist enabled | grep mysql
```

## 安装 mysql
```
yum install mysql-community-server

会安装下面数据库依赖
mysql-community-server
mysql-community-client
mysql-community-common 服务器的错误消息和字符集
mysql-community-libs 共享客户端库
```

## RPM gpg签名包的添加

```
rpm 从 url 加载秘钥
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
```


## 启动服务
```
systemctl start mysqld; (default 开机子启动)
```

## 开机自启动和关闭自启动
```
systemctl enable  mysqld
systemctl disable  mysqld
```

## 获取临时密码用于修改自己的密码
```
cat  /var/log/mysqld.log  | grep "temporary password"

validate_password 
 default  1大写字母 一个小写字母 一个特殊字符  一个数字 并且 加起来 至少 8个字母。

alter user 'root'@'localhost' identified by 'LiuXin=996';
```