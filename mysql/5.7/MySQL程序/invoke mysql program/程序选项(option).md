## 注意
```
1.同时出现多个相同选项以最后一个选项为准
  mysql  -h www.baidu.com  -h localhost -uroot -p
  -h localhost 为最终值

 
  例外:
   mysqld -u(--user) 将以OS user的身份运行mysqld
   mysqld 仅使用指定的第一个 -u(--user)值
   这样做的目的用于安全防范

```

### 在命令行上使用选项
```
帮助消息选项
mysql --help
mysql -?


选项区分大小写
 -v -V 的含义是不相同的

-h localhost(-hlocalgost) 和 --hostname=localhost是等价的
  
  一般的选项 -x xxx 后面可以有空格而密码-p是个例外
  --password=xxxx
  (不允许存在空格)
  -pxxxxx


mysql -pxxx(密码是xxx)
mysql -p xxx(使用交互式输入密码默认选择 xxx数据库)



将一个字符串的sql语句传给 服务器
-e(--execute)
mysql -e ="xxxxxxxx"
“” 之间可以有多条执行语句  使用 ; 分开
命令处理器的功能决定了您是否可以使用单引号或双引号以及转义引号字符的语法。

```

## 使用选项文件
```
选项文件 用于配置常规的服务器启动选项的配置
好处 不需用每次配置的时候都键入它们



从上到下读取后读取的数据覆盖前面读取的选项数据
/etc/my.cnf	全局选项
/etc/mysql/my.cnf	全局选项
SYSCONFDIR/my.cnf	全局选项
$MYSQL_HOME/my.cnf	服务器特定选项（仅限服务器）
defaults-extra-file	用 指定的文件 --defaults-extra-file，如果有的话
~/.my.cnf	用户特定选项
~/.mylogin.cnf	用户特定的登录路径选项（仅限客户端)

SYSCONFDIR:CMakeSYSCONFDIR 选项指定的目录。默认情况下，这是位于编译安装目录下的目录。 etc

$MYSQL_HOME:若未设置 mysql_safe 程序启动服务器 会将 $MYSQL_HOME 设置为 DATADIR 目录.
一般DATADIR的位置  
DATADIR(不是启动时设置 --data-dir的选项) 而是编译时内置的数据位置

note: .mylogin.cnf 不是使用手动编写的而是使用 mysql_config_editor 创建的

选项文件语法

  1.
  命令行:
  --quick
  --host=localhost 
  --loose-opt_name 
  选项文件(省略命令行的-- or -)
  quick
  host=loclhost
  loose-opt_name
  2.
  # or ; 当注释
  3.[group] (选项组名不区分大小写)
  4.
  xxx= "xxx"
   在命令选项中使用空格是不正确的,但是在文件选项的中可以使用空格 
   值可以使用 “” or '' 

   注意：选项值前后的空格会去除
  
   可以使用转移字符
    \b   black space
    \t  tab
    \n  newline 换行
    \r  inter 回车
    \\  \
    \s whitespace 空格符号


```