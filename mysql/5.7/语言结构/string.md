## Strings
```
"string"
'string'

‘’和“” 都能表示字符串



ANSI_QUOTES mode 
  enable ,  " 就不是引号,而是字符,只能够使用'来做引号


binary string= 字符集 + 二进制的排序规则 

nonbinary = 二进制以外的字符集+字符集兼容的排序规则
binary string is unit byte.
二进制字符串单位字节

nonbinary 单位：字符 或者字符集兼容的多字符


mysql client :
  要使用16进制的数字来作为二进制字符串,依赖  --binary-as-hex
  --binary-as-hex 使用 0x标记展示二进制值


[_charset_name]'string' [collation_name] 

example 
   SELECT _latin1'string';
   SELECT _binary'string';
   SELECT _utf8'string' COLLATE utf8_danish_ci;


NO_BACKSLASH_ESCAPES:
   开启这个模式禁止使用 \ 字符，不能再字符串和表示符去作为转义字符(escape character) 
   开启这个模式会改变 like 语句 和 regexp 语句的使用,并且没有其他字符作为转义字符.



\x 不是转移字符 会作为不是转义字符被忽略 \x  =x 


转义字符不能够忽略大小写(case-sensitive),\b 被解释 backspace,\B 被解释为B

转义字符通过  指定(indicate) character_set_connection  系统变量的字符集 处理完成

即使string 前面加上(_latin1'string') 像  _latin1 一样的插入者也一样是正确的。(转义字符是ascii,任何
不同的字符集都是兼容这个的)


转义字符串

\0	
\'	
\"	
\b	
\n	
\r	
\t	
\Z	
\\	
\%	
\_


在匹配模式(pattern-matching like语句)里面 % 和 _ 是匹配字符 如字符串需要使用%和 _字符配匹配使用 escape character 
\_ 和 \%



字符串里面引用字符(quote character)使用的几种方式

  1.'xxx'
  2."xxx"
  3 '\'a\'
  4. "'a'" 'a'
  5 '"a"'  "a"
  


```