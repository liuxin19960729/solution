# IOC
```
DI:依赖注入
   DI是IOC的一种模式,被翻转控制的设置对象的依赖关系,将对象与其他对象连接起来
IOC:
    是软件工程中的一种原则,将对象和程序部分控制移动到容器和框架中

    

    有哪些机制实现控制反转:
    策略设计模式
    服务定位器模式
    工厂模式
    依赖注入（DI）


BeanFactory 提供框架基本功能, Bean创建 与注册,BeanFactory 就是Bean的一个大容器(singleton bean BeanDefiniton)
ApplicationContext 提供了更多企业的特定功能(ApplicationConext是一个完整的超集)


```
##  策略设计模式
![策略模式](./img/策略模式.png)
```
概念:完成一项任务有多种不同的方式,通过环境,和选择不同的策略来完成该项目
```
## 服务定位器模式
![服务定位器模式](./img/%E6%9C%8D%E5%8A%A1%E5%AE%9A%E4%BD%8D%E5%99%A8%E6%A8%A1%E5%BC%8F.jpg)
```
JNDI(java name directory intertface)查找服务代价很高,在进行查找的时候将查找到的数据缓存起来
在次查找先去缓存查看一下是否存在
```


## 容器的概述
```
intertface ApplicationContext 提供了几个实现

 ClassPathXmlApplicationContext
 FileSystemXmlApplicationContext
 ......
```

### 配置源数据
```xml
配置源数据目的是告诉spring如何去实例化对象

bean(<bean> @Bean) 通常定义的是服务层的对象,或基础设置对象,通常不会在Bean中配置细粒度的Domain对象

<beans xmlns="xxxx">
    <bean id="" clas=""></bean>
</beans>
```
### 实例化一个容器
```
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");

```
### 编写基于XML的配置源数据(import) 和 地址相关属性设置
```xml
<import resource="">  加载当前xml文件时从另一个xml文件文件加载BeanDefinition


<beans>
    <import resource="services.xml"/> 
    <import resource="resources/messageSource.xml"/>
    <import resource="/resources/themeSource.xml"/>

    <bean id="bean1" class="..."/>
    <bean id="bean2" class="..."/>
</beans>

note: 如论是否是地址和相对地址 都是从 resources 开始寻找

可以使用 ${} 来引用 系统环境变量和 java -Dxxx=xx ..... 的属性

```
### 使用容器
### GenericalApplicationContext 和自动以的阅读器结合使用
```java
		GenericApplicationContext applicationContext = new GenericApplicationContext();
		XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(applicationContext);
		reader.setValidating(true);
		reader.loadBeanDefinitions(new ClassPathResource("application.xml"));//将xml配置文件的Bean放入BeanFacory里面
        applicationContext.refresh();
		B bbb = applicationContext.getBean("bbb", B.class);
		System.out.println(bbb);
        

groovy 配置文件阅读器
new GroovyBeanDefinitionReader(context).loadBeanDefinitions("services.groovy", "daos.groovy");
xml 配置文件阅读器
XmlBeanDefinitionReader reader = new XmlBeanDefinitionReader(applicationContext);
```
## Bean的概述
### BeanDefinition 相关属性
```java
class
name
scope
constructor arguments
propertie
AutuoWiring mode
lazy-initialization
initailization method
desctruction method

bean的注册方式
  1.metadata 配置注册
  2.applicationContext.getBeanFactory().registerSingleton(xxx); 外部注册

```
### 命名Bean
```
Bean 存在一个唯一的标识符
Bean 夜能存在多个别名 

<bean> id 唯一标识符
       name="" 一个或多个别名 , ; whitespace 空格隔开

注意可以不提供 name 和 id属性 
    className+"#"+unique 组合而成
```
### Bean之外Bean起别名
```
<alias name="" alias="" > <alias>

运用场景
 main xml 
     <alias name="myApp-dataSource" alias="subsystemA-dataSource"/>
     <alias name="myApp-dataSource" alias="subsystemB-dataSource"/>
 
A.xml 
   可以使用  subsystemA-dataSource 相关配置
B.xml  
   可以使用 subsystemB-dataSource 相关配置
 
 这样可以修改数据源的时候再 main里面修改即可  子系统配置文件可以解耦

```

### 实例化Bean
```xml
bean定义的本质是创建一个对象或者创建多个对象

<bean class="xx.xx.A"> </bean>

1.构造参数反射进行实例化
2.工厂方法创造
   2.1 factory-method   当前类上面staic工厂方法创建
   2.2 bean-factory  factory-method  对象的工厂方法创建对象


2.InnerClass内部类创建
  1.xxxx.xxx.ParentClass.InnerClass
  2.xxxx.xxx.ParentClass&InnerClass
  
  非静态内部类 bean-factory  factory-method

  静态内部类
  <bean id="inner" class="com.liuxin.entity.InnertClassTest$Inn">bean>


例: 一个工厂类包含多个工厂
<bean id="serviceLocator" class="examples.DefaultServiceLocator">
    <!-- inject any dependencies required by this locator bean -->
</bean>

<bean id="clientService"
    factory-bean="serviceLocator"
    factory-method="createClientServiceInstance"/>

<bean id="accountService"
    factory-bean="serviceLocator"
    factory-method="createAccountServiceInstance"/>
public class DefaultServiceLocator {

    private static ClientService clientService = new ClientServiceImpl();

    private static AccountService accountService = new AccountServiceImpl();

    public ClientService createClientServiceInstance() {
        return clientService;
    }

    public AccountService createAccountServiceInstance() {
        return accountService;
    }
}
```

### 确定Bean运行时类型
```
使用 beanFactory.getType() 将所有包含该类Type(实现继承都可以获取)全部获取
光从BeanDefinition 事不能知道真正的类型  proxy 和 factory-method 等 都会影响类型
```
## 依赖项
### 依赖注入
#### construct 注入
```java
优势:代码干净简洁 依赖关系清晰 解耦更加有效

DI注入两种方式 setter 和 constructor 方式注入
    <constructor-arg type="" index="" ></constructor-arg>
    注意 index 从0 开始
     <constructor-arg name="years" value="7500000"/> 通过name进行匹配

name 使用需要注意
public class ExampleBean {

    // Fields omitted

    @ConstructorProperties({"years", "ultimateAnswer"})
    public ExampleBean(int years, String ultimateAnswer) {
        this.years = years;
        this.ultimateAnswer = ultimateAnswer;
    }
}
ConstructorProperties 告诉编译器在编译的时候创建 getYears() getUltimateAnswer() 的getter方法
```
#### setter注入
#### 注入注意
```
spring团对建议使用构造注入 他可以初始化不可变对象，并且对象不会为null(还是建议不要大规模的使用构造注入)

setter 注入 可以在类中分配更合理的依赖选项

```
#### 依赖注入相关配置
##### 注入是基本使用
``` java
setDriverClassName(String)
<property name="driverClassName" value="com.mysql.jdbc.Driver"/>
将值转化为字符串



Properties配置相关的注入使用
public void setA(Properties a)

<property name="a">
			<value>
				name=liuxin
				age=26
			</value>
		</property>
将值转化为Properties对象




对父容器Bean的使用
	public void setA(String a) {
		this.a = a;
	}
	<property name="a">
             <idref bean="A"></idref>
		</property>
    idref 只注入名称,并且还会检查bean是否存在

<ref parent="" bean=""></ref> 对父容器bean的引用


Property内部的Bean
	<property name="a">
			<bean class="com.liuxin.entity.A"></bean>
	</property>
    
   注意 Property的BeanDefinition 没有注册在BeanFactory 里面 而是注册放在当前 Property 类的里面 所以
   使用BeanFactory.getBean() 时更笨访问不到 


```
#### 注入集合类的使用
```java

```