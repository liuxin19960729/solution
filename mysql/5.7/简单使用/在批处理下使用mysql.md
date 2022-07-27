## 批处理的方式处理
```
mysql -uroot -p <mysql_bacth_1

windows,有一些特殊字符会导致文件出现问题

mysql -uroot -p -e "source batch-file";


如果sql发生错误继续向下执行
-f, --force         Continue even if we get an SQL error.



mysql < batch-file | more
将批处理的输入保存在mysql.out文件中
mysql < batch-file > mysql.out



可以使用 cron 定时调用程序

-t, --table         Output in table format.
mysql -t  输出交互式时的格式


登录进入执行sql 或 脚本
mysql> source filename;

```

