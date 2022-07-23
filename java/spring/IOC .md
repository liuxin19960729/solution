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




检查Bean 是否存在 并且把beanNam额注入到方法
	public void setA(String a) {
		this.a = a;
	}
	<property name="a">
             <idref bean="A"></idref>
		</property>
    idref 只注入名称,并且还会检查bean是否存在

对父容器Bean的使用

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
<props>
    <prop key="" value="">
</props>
<list>....</list>

<map>
  <entry key="" value="">
</map>

<set>.....</set>

set list prop map 的value可以是下面的任何值
bean | ref | idref | list | set | map | props | value | null

```

#### 合并集合 
```
 <bean id="parent" abstract="true" class="example.ComplexObject">
        <property name="adminEmails">
            <props>
                <prop key="administrator">administrator@example.com</prop>
                <prop key="support">support@example.com</prop>
            </props>
        </property>
    </bean>

 <bean id="child" parent="parent">
        <property name="adminEmails">
            <!-- the merge is specified on the child collection definition -->
            <props merge="true">
                <prop key="sales">sales@example.com</prop>
                <prop key="support">support@example.co.uk</prop>
            </props>
        </property>
    </bean>
<beans>

要想对Properties值进行合并使用 <props merge="true">

list  map set 一样的能够支持合并操作

note: 合并只能是同类之间合并

```

### null 和空字符串
```
<bean class="ExampleBean">
    <property name="email" value=""/>
</bean>
相当于 setEmail("")


<bean class="ExampleBean">
    <property name="email">
        <null/>
    </property>
</bean>

相等于 setEmail(null)
```

### P空间xml
```
p:a="" 值  p:a-ref 引用
xmlns:p="http://www.springframework.org/schema/p"
p空间不存在XSD文件
基于spring核心中

p:class属性名
p:class属性名-ref

spring-bean：META-INF/spring.handles 里面设置了专门处理对应的命名空间属性 和元素的处理方式

p空间缺点 p:xxx-ref 可能会造成xx-ref 的属性名冲突

```

### c空间的xml
```
和p空间的使用方法相同,c空间主要用意 constructor
xmlns:c="http://www.springframework.org/schema/c"

c:thingThree-ref="beanThree" c:email="something@somewhere.com"/>

c空间index方式设置

c:_index=""
c:_index-ref=""
```

### 复合属性名称
```
 <property name="fred.bob.sammy" value="123" />
 . 进行隔离  同时对 fred bob 和sammy 进行设置值
```

### depend-on
```
在使用Bean之前 依赖项必须初始化完
depend-on=""  ,; whiteplace 区分开多个依赖项



<bean id="beanOne" class="ExampleBean" depends-on="manager,accountDao">
    <property name="manager" ref="manager" />
</bean>

<bean id="manager" class="ManagerBean" />
<bean id="accountDao" class="x.y.jdbc.JdbcAccountDao" /


注意 : 初始化依赖性允许,关闭填也是遵循依赖的原则
```
### lazt-init
```
lazy-init
getBean() 时才会创建Bean

note:非延迟依赖延迟Bean 在 refresh() 延迟也会被创建
```
**beans级别的延迟属性设置default-lazy-init="true"**


### 自动装配者(AutoWire) Xml
```
spring可以自动装配协作spring之间的关系

作用:向该类添加依赖项,可以自动满足依赖无需配置


四种模式

no(default): 不会自动装配必须显示的设置。(property 和 constrcut-args)

byName:
   spring通过虚造setter方法  找到属性名,那这属性名 到容器里面进行 早对应的BeanName 


byType:找到Setter方法  旋凿到属性类型 查看是否存在相同的类的Bean,当存在多个时会抛出异常,一个或没有则不会抛出异常

constructor:选中和构造参数匹配的类型

```
### 自动装配缺点
```
constructor 和 byType

1.不能装配简单属性:String Class 数组 等

autowire-candidate =false放弃该类为自动装配属性(default true)
primary 自动装配的主要候选者
```
### 方法注入
```

lookup-method:用于工厂方法

	<bean id="lup" class="com.liuxin.entity.lookup.Lup" ></bean>
	<bean id="ss" class="com.liuxin.entity.lookup.AbstractLUP">
		<lookup-method bean="lup" name="aa"></lookup-method>
	</bean>
createCommand 方法是abstract 动态生成的子类会生成子类的实现方法,
非abstract 动态生成的代码会覆盖实现

lookup-method bean是返回的对象(scope=singleton or propertype)
aa ：ss对象的方法  该方法返回的是 lupBedefinition instance后的对象 可单例 或 工厂


原理 调用 aa()方法的时候 从BeanDefinition 找到 对应lookup-method 相关配置 在BeanFactory 该创建 换货从singeltonMap 里面拿取



replace-method
 将方法替换成另一个实现

```
## Bean Scope
```
singleton



prototype  java new的替代品

request  每个请求都有自己的生命周期,只在Web感知的Spring上下文中有效(限制于单个Http请求生命周期)
   @RequestScope
   当这个Http request请求 完成是 bean会丢弃


session Http的生命周期
   <bean id="userPreferences" class="com.something.UserPreferences" scope="session"/>
    @SessionScope
    bean 有效的限制在Http级别,可以对不同的Http相互隔离
    

application 将单个Bean定义为ServeletConext
  <bean id="appPreferences" class="com.something.AppPreferences" scope="application"/>
  @ApplicationScope
  
  为整个ServletContext(web) 项目使用

websocket


note
property bean  依赖  singleton bean 
 先创建obj 在 把单例的bean注入

```

### 作用域和Bean的依赖
```
短生命周期的Bean注入到更长周期的Bean中,使用AOP来替代这个Bean的范围
  注入一个代理对象
  将真实的对象通过委托的方式传给真实对象


 <bean id="userPreferences" class="com.something.UserPreferences" scope="session">
        <!-- instructs the container to proxy the surrounding bean -->
        <aop:scoped-proxy/> 
    </bean>


注入Bean的代理对象
<bean id="userService" class="com.something.SimpleUserService">
        <!-- a reference to the proxied userPreferences bean -->
        <property name="userPreferences" ref="userPreferences"/>
    </bean>  

 <aop:scoped-proxy/> 会创建一个singleton的代理对象, session 对象会生成一个委托的对象
 通过调用会通过代理对象 遭到委托对象调用相对应的方法


```
