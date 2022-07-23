## 创建docker group
```
groupadd docker
```
## 添加用户到 组
```
sudo usermod -aG docker $USER
```

## 当前用户切换到docker组
```
newgrp docker
```
## 修改docker配置权限

```
 sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
 sudo chmod g+rwx "$HOME/.docker" -R
```


## 不使用sudo测试
```
docker run hello-world
```

