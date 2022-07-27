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


```