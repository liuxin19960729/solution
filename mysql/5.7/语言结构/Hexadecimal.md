## Hexadecimal literal1
```
Xval or 0xval  notation(标注)

```

## X前缀
```
x 前缀 可用  大小写都可以


使用x value  数字额个数必须是偶数负责,否则就会报错
set @A = X'00';
```

## 0x前缀
```
注意 0x 是区分大小写(case-sensitive)的 0X不允许这样写。 

0x 表示16进制数字的位数可以是任意位数 当他是奇数数字的时候 会被自动在天面添加0把他凑齐为偶数个数字

0x'fff'   会被解释为 0x '0fff'

mysql> SELECT 0x5461626c65, CHARSET(0x5461626c65);
+--------------+-----------------------+
| 0x5461626c65 | CHARSET(0x5461626c65) |
+--------------+-----------------------+
| Table        | binary                |
+--------------+-----------------------+


note ox4d 4d要引号  而 x'4d' 是需要 '' 引号(quote charset)的 。


16进制的字面量值可以选择字符集来这设置  introducer 和 collate(检查) clause(字句)。 
  
   for example
   SELECT _latin1 X'4D7953514C';
   SELECT _utf8 0x4D7953514C COLLATE utf8_danish_ci;
      
```

```
MySQL对待16进制的字面量值 和 BIGINIT UNSIGNED 一样的(64-bit unsinged interger)


要想使用16进制的数字处理,使用下面两种方式
    0x+0
    cast (Xva as unsigned)

16进制字面的值默认是二进制字符串



set @a1=0x4D; 16进制字面变成对应的字符字符串

set @a2=0x4D+0; 无符号10 进制的值

set @a3 = cast(0x4d as unsigned);  无符号10进制的值
mysql> select @a1,@a2,@a3;
+------+------+------+
| @a1  | @a2  | @a3  |
+------+------+------+
| M    |   77 |   77 |
+------+------+------+
1 row in set (0.01 sec)


note:X'' 的字符长度 length(X'') 未0,

set @a1=X''+0; x'' 转换成数字会变成0
mysql> select @a1;
+------+
| @a1  |
+------+
|    0 |
+------+




X'val' 符号是基于标准SQ的。
0x 是基于ODBC的的

他经常在BLOB(大量二进制数据) 列类型中使用。

string 和 数字的相互转换。

```