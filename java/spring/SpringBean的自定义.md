## 自定义Scope
```
实现接口
  org.springframework.beans.factory.config.Scope


Object get(String name, ObjectFactory<?> objectFactory)
 获取 名字为name bean实例
 不存在创建

Object remove(String name)
  返回删除的bean实例 不存在 返回 null

注册一个回调 当销毁作用域和销毁作用域对选哪个的时候调用该回到
void registerDestructionCallback(String name, Runnable destructionCallback)

String getConversationId() 范围标识符



注册新范围
    applicationContext.getBeanFactory().registerScope();

例
Scope threadScope = new SimpleThreadScope();
beanFactory.registerScope("thread", threadScope);


自定义配置方法 CustomScopeConfigurer BeanFactoryPostProcessor 会在invokeBeanFactoryPostProcess方法()回去对象并且执行
  <bean class="org.springframework.beans.factory.config.CustomScopeConfigurer">
        <property name="scopes">
            <map>
                <entry key="thread">
                    <bean class="org.springframework.context.support.SimpleThreadScope"/>
                </entry>
            </map>
        </property>
    </bean>

将线程的范围通过代理的方式注入创建对象    
 <bean id="thing2" class="x.y.Thing2" scope="thread">
        <property name="name" value="Rick"/>
        <aop:scoped-proxy/>
 </bean>
 注入代理的 singleton 
 <bean id="thing1" class="x.y.Thing1">
        <property name="thing2" ref="thing2"/>
    </bean>

```

## 容器扩展点
### BeanPostProcessor
```
Order or PriorityOrder 等接口 可以设置BeanPostProcessor 的执行顺序

postProcessBeforeInitialization()
initMethod() 
postProcessAfterInitialization()

作用
 代理包装一个bean(proxy)

applicationConext自动检查 注册
BeanPostProcessor 自动注册 refresh()调用 --->registerBeanPostProcessors() 

```

### BeanFactoryPostProcessor
```java
application--> refresh() --->invokeBeanFactoryPostProcessors() 对加载的BeanDefinition 或 BeanFacrory进行操作


for example
  PropertySourcesPlaceholderConfigurer  implement  BeanFactoryPostProcessor


<bean class="org.springframework.context.support.PropertySourcesPlaceholderConfigurer">
    <property name="locations" value="classpath:com/something/jdbc.properties"/>
</bean>

<bean id="dataSource" destroy-method="close"
        class="org.apache.commons.dbcp.BasicDataSource">
    <property name="driverClassName" value="${jdbc.driverClassName}"/>
    <property name="url" value="${jdbc.url}"/>
    <property name="username" value="${jdbc.username}"/>
    <property name="password" value="${jdbc.password}"/>
</bean>

PropertySourcesPlaceholderConfigurer 会现在 properties 里面查找 ,找不到会在 环境变量 和 java -Dxx=xx 里面进行查找


通过xxx.properties 配置类名 在Bean动态的替换类名

<bean class="org.springframework.beans.factory.config.PropertySourcesPlaceholderConfigurer">
    <property name="locations">
        <value>classpath:com/something/strategy.properties</value>
    </property>
    <property name="properties">
        <value>custom.strategy.class=com.something.DefaultStrategy</value>// 默认策略
    </property>
</bean>

<bean id="serviceStrategy" class="${custom.strategy.class}"/>



专门的命名空间 <context:property-placeholder location="classpath:com/something/jdbc.properties"/>//, ; whiteplace 


PropertyOverrideConfigurer extends PropertyResourceConfigurer 
	<bean class="org.springframework.beans.factory.config.PropertyOverrideConfigurer">
		<property name="properties">
			<value></value>
		</property>
	</bean>

可以配置多个  PropertyOverrideConfigurer 在操作Bean的时候,多个PropertyOverrideConfigure都存在这个属性配置
 最后一个 会获胜
占位符命名空间
<context:property-override location="classpath:override.properties"/>
```

## 自定义实例化FactoryBean
```
获取FactoryBean自己
getBean("&xxx") //&代表beanFactory的解引用

```

## 自定义类型转换
```
@Configuration
public class AppConfig {

    @Bean
    public ConversionService conversionService() {
        DefaultFormattingConversionService conversionService = new DefaultFormattingConversionService();
        conversionService.addConverter(new MyCustomConverter());
        return conversionService;
    }
}

```

## 自定义Bean命名
```
实现 BeanNameGenerator

Configuration
@ComponentScan(basePackages = "org.example", nameGenerator = MyNameGenerator.class)
public class AppConfig {
    // ...
}


<beans>
    <context:component-scan base-package="org.example"
        name-generator="org.example.MyNameGenerator" />
</beans>

```

