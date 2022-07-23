## Uninstall
### 删除docker
```
sudo yum remove docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

### 删除容器和自定义配置文件
```
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

```