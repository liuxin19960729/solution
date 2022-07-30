# Date and Time Literals
```
date and time format
    string '2015-07-01'  '20150721'
    number  20150721

```

## 标准SQL格式 和 ODBC格式 日期和时间
```
标准SQL
keyword + string 制定时间,ketword 和 string 之间是可选择的

date str; select date '2017-01-01' ;

time str;  select time '01:01:01' ;

timestamp str; select  timestamp  '2017-01-01 00:01:01';



ODBC格式
select  {d '2022-01-01'}
select  {t '2022-01-01'};
select  {ts '2022-01-01'};

```

## String and Numeric Literals in Date and Time Context
### MySQL认识的日期(DATE)格式
```


1. 'YY-MM-DD' and  'YYYY-MM-DD'
 mysql 允许使用宽松的分隔符,下面都允许
    '2012-12-31', '2012/12/31', '2012^12^31', and '2012@12@31


2.允许不使用分隔符日期
  'YYMMDD' 和 'YYYYMMDD'
   
   例如 '20070523' and '070523'

    but '071332' is illegal (it has nonsensical month and day parts) and becomes '0000-00-00'.
    13 月 和 32 日没有科学意义

3.数字来表示日期
    YYYYMMDD or YYMMDD
    
    for example
      19830905  830905

```
### MySQL认识的DATETIME 和 TIMESTAMP
```

String   delimiter
  'YYYY-MM-DD hh:mm:ss' or 'YY-MM-DD hh:mm:ss' 
  也是支持宽松型分隔符
   '2012-12-31 11:30:45', '2012^12^31 11+30+45', '2012/12/31 11*30*45', and '2012@12@31


String  no delimiter
    'YYYYMMDDhhmmss' or 'YYMMDDhhmmss' format
    
    '20070523091528'

    '071122129015'  90  minutes 这个值不符合科学意义 会被解释为 '0000-00-00 00:00:00'

number
  YYYYMMDDhhmmss or YYMMDDhhmmss  format
    19830905132800 and 830905132800 



datatime or timestamp 包含一个后面小数秒的比分,可以达到微妙(ms)的精确度
小数部分使用小数点(.)和其他时间分开
```

```
Date 可以使用YY(两位数的年),这个值是模棱两可的,Mysql使用解析两位数年的规则

70-99 1970-1999
00-69 2000-2069


日期 月 和日的值不是必须使用两位数的值(select date '2017-1-1'; 也可以)
相似的 对弈 time也不是必须要求两位数的(select timestamp '2017-1-1 1:1:1';)


number 格式
   8 or 14 位数的long
     会被猜测 为 YYYYMMDD or YYYYMMDDhhmmss  format
     前4位年

    6 or 12 位数的long 
        会被猜测 为 YYMMDD or YYMMDDhhmmss  format 
         
         前两位假设为年

   <6 会被当做6来 并且不足的数据会被天聪
   

   小于这些只会选择一个这些数字其中的一个来进行解释
 

 怎样解释number类型
   1.当成一个没有分隔符(no delimiters) 的字符串来进行解释。

   字符串 from  left --> right  year month day hour minute  second 来进行解释
   你不能使用比6个字符更少的字符
   如果有些月份 或其他部分没有你应该使用 0来占位
   例如 ‘1999-01-00’ ‘990300’  你可以显示的指定 00 聊表示缺少的值
```

## MySQL time日期格式
```
有分隔符

'D hh:mm:ss' 
夜可以使用下面宽松型额类型指定
'hh:mm:ss', 'hh:mm', 'D hh:mm', 'D hh', or 'ss'. 


D:表示的是天 范围[0-31]


没有分隔符
'hhmmss' 格式


```