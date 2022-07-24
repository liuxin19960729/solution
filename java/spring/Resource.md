## Resource
```java
public interface Resource extends InputStreamSource {
    // 是否以物理形式存在
    boolean exists();

    boolean isReadable();
    // 是否打开流的句柄
    boolean isOpen();

    boolean isFile();

    URL getURL() throws IOException;

    URI getURI() throws IOException;

    File getFile() throws IOException;

    ReadableByteChannel readableChannel() throws IOException;

    long contentLength() throws IOException;

    long lastModified() throws IOException;

    Resource createRelative(String relativePath) throws IOException;

    String getFilename();
    //  文件完全限定名 或资源实际URL 可用于资源出错的错误输出
    String getDescription();
}


public interface InputStreamSource {

    /*
       调用者负责关闭,防止内存泄露 
    */
    InputStream getInputStream() throws IOException;//返回一个InputStgream 可以到读取数据

}

```


### 内置的Resource的实现
```
UrlResource
   用于访问 FTP HTTPS 和 文件
   ftp:xxxx
   https:xxx
   file:xxx
ClassPathResource
   使用线程上下文加载器,给定加载器 来加载资源
   
   classpath:
FileSystemResource

PathResource
  
ServletContextResource
   Web 应用程序根目录中的相对路径Resource的资源实现
   支持 stream 和 URL 进行访问

InputStreamResource
  InputStreamResource是Resource给定 的实现InputStream
  Resouce 只有在没有特定实现的时候才使用它
ByteArrayResource
  这是Resource给定字节数组的实现。它为给定的字节数组创建一个 ByteArrayInputStream。
```

### ResourceLoader
```
所有ApplicationConext 都  extends  DefaultResourceLoader

resourceLoader.getResource("xxx") 可以获得Resource对象

ClassPathXmlApplicationContext  ClassPathResource

FileSystemXmlApplicationContext实例运行相同的方法，它将返回一个FileSystemResource

WebApplicationContext，它将返回 a ServletContextResource


classpath:xx/xx/   ClassPathResources
file:///xxx/xx   URL 从文件系统夹杂 FileSystemResource
https: https://xx  URL 加载

/data/xxx   取决于底层的Application实现
```

### ResourcePatternResolve
```java
public interface ResourcePatternResolver extends ResourceLoader


public interface ResourcePatternResolver extends ResourceLoader {

    String CLASSPATH_ALL_URL_PREFIX = "classpath*:";

    Resource[] getResources(String locationPattern) throws IOException;
}
Ant(*)风格 获取Resource 实现 


classpath*:/config/beans.xml  jar 文件  和 classpath 的config/beans.xml文件


ApplicationConext 实现 ResourcePatternResolver 接口 实现全全交给代理实现类 PathMatchingResourcePatternResolver

```
### ResourceLoaderAware
```
public interface ResourceLoaderAware {

    void setResourceLoader(ResourceLoader resourceLoader);
}


AbstarctApplicationConext.prepareBeanFactory() {
     beanFactory.addBeanPostProcessor(new ApplicationContextAwareProcessor(this));//实现 ResourceLoaderAware接口的Bean,会在实例化的时候自动注入ResourceLoader对象
}



intertface ApplicationContextAware
实现ApplicationContextAware 接口的Bean都能注入ApplicationConext的对象


note classpath*： 需要视同 ResourcePatternResolver独享
```
### 资源作为依赖
```
资源模版配置
<bean id="myBean" class="example.MyBean">
    <property name="template" value="some/resource/path/myTemplate.txt"/>
</bean>

spring 帮你将字符串地址自动转化为Resource对象 some/resource/path/myTemplate.txt

强制Resource类型
ClassPathResource
<property name="template" value="classpath:some/resource/path/myTemplate.txt">
FileSystemResource
<property name="template" value="file:///some/resource/path/myTemplate.txt"/>


@Component
public class MyBean {

    private final Resource template;

    public MyBean(@Value("${template.path}") Resource template) {
        this.template = template;
    }

    // ...
}

PropertyEditor 会将字符串转化为  template.path 的 Resource的对象


 templates.path 设置问 classpath*;/xx/xx/*.txt
@Component
public class MyBean {

    private final Resource[] templates;

    public MyBean(@Value("${templates.path}") Resource[] templates) {
        this.templates = templates;
    }

    // ...
}
```