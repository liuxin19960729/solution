# AOP 在spring中的应用
```
提供声明式企业服务。最重要的此类服务是 声明式事务管理。
让用户实现自定义方面，用 AOP 补充他们对 OOP 的使用。
```

## Aop 的概念
```
Aspect:
Join point: 程序执行过程中的一个点 (方法执行  或者 异常处理)
Advice: 包围之前和之后的建议
Pointcut: 用于匹配链接点 
Introduction: spring允许你向任何建议引入接口
arget object: 该对象始终是代理对象
AOP proxy:  AOP 代理是 JDK 动态代理或 CGLIB 代理
Weaving: 可以在编译时期创建对象(AOP or JDK 是在运行期间进行对象的创建)



建议类型:
Before advice: 连接点之前运行
After returning advice: 连接点正常完成之后
After throwing advice: 抛出异常
After (finally) advice: finally 正常退出 异常退出 都会运行
Around advice: 可以在方法调用之前和之后执行自定义行为 它还负责选择是继续到连接点还是通过返回自己的返回值或抛出异常来缩短建议的方法执行。


```