## Uninstall
```
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
                
```

## Install
```

1. Docker 官方推荐方法 安装Docker 仓库,便于安装升级

    sudo yum install -y yum-utils (提供 yum-config-manager 非常有用的工具)

    添加 docker仓库
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    
    安装Docker(只会安装不会启动,默认不会添加任何用户)
    sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    指定版本安装
       1.查看docker有哪些版本
          yum list docker-ce --showduplicates | sort -r
       2.根据指定的版本进行安装     
          sudo yum install docker-ce-<VERSION_STRING> docker-ce-cli-<VERSION_STRING> containerd.io docker-compose-plugin
          例 
             docker-ce.x86_64  3:18.[09.0-3].el7  [] 之间的类容就是版本号  
             docker-ce-18.09.0
2.rpm 包安装完全手动进行升级,在不能上网的系统重安装非常有用

3.在测试和开发环境中,很多用户喜欢方便的脚本安装


```
