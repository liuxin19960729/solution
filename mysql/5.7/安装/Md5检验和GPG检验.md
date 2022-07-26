[official](https://dev.mysql.com/doc/refman/5.7/en/checking-gpg-signature.html)
## linux下MD5 检验包的完整性
```
md5 sum filename
```
## GPG检验
```
加密签名 检验包的完整性 和 真实性

从公钥服务器下载秘钥  3A79BD29
gpg --recv-keys 3A79BD29

将秘钥导入个人gpg秘钥环
gpg --import mysql_pubkey.asc

将秘钥导入rpm配置用来
rpm --import mysql_pubkey.asc 
```
## 将本地gpg 更具秘钥导出秘钥
```
从个人秘钥环导出指定key的秘钥  -a  创建 gpg的格式  OpenPGP format
gpg --export -a 3a79bd29 > 3a79bd29.asc

```