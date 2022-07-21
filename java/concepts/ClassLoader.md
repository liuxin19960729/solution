# ClassLoader
## 基本概念
```
1.java compiler   编译 xxx.java 文件   out  xxx.class文件

2.存在一个程序将xxx.class 内容解释为机器语言



```
## 类加载时机
```
loading(加载)--->Verification(验证)--->准备(preparation)--->解析(Resolution)--->初始化(inilization)--->使用(Using)--->Unloading(卸载)

解析(Resolution)可能在初始化(Inilization)之后再进行.(动态绑定和动态绑定 特性的支持)


Loading(加载)阶段并没有在<<Java虚拟机规范>>强制约束。

6中情况表明必须已经初始化(Inilization)完成
**Inilization(初始化阶段)在虚拟机明确规定。(Loading --Verification-->preparation 在这之前已经完成)
   
   1
      new
      静态字段的设置和获取 (final 修饰的除外,在编译时期就被放入常量池)
      静态方法的调用

   2 反射调用(java.lang.reflect)
   3 初始化当前类会检查父类是否初始化(父类初始化比子类早初始化)
   4 启动时先初始化main() 方法的类
   5 java.lang.invoke.MethodHandle   REF_getStatic REF_putStatic REF_invokeStatic  REF_newInvokeSpecial 
       四种类型句柄使用时会先初始化在进行调用执行
   6 JDK 8 接口 default 修饰的方法,在访问方法之前,必须先让接口初始化
    final static int c=200;//在编译时放进常量池
    public  default void  aa(){
            aaaaa();
    } 
```
### static 静态普通类型和String 是否存在 final 的影响
```java
public class SuppeClass {
    static {
        System.out.println("super class init");
    }

    public  final static  int value = 200;
}


public class CLTest1 {
    public static void main(String[] args) {
        System.out.println(SuppeClass.value);
    }
}

final 编译时会放在常量池 调用时不会造成Class 初始化
没有 final 访问时整个类会先初始化

```

### static 静态引用属性访问 是否存在final是否有影响
```java
public class SuppeClass {
    static {
        System.out.println("super class init");
    }

    public  static  String value = "22";
}


public class CLTest1 {
    public static void main(String[] args) {
        System.out.println(SuppeClass.value);
    }
}

有或者没有访问都会初始化

```
### 子类访问父类静态的方法和属性(基本类型和String非 final)
```java
public class SuppeClass {
    static {
        System.out.println("super class init");
    }

    public  static  HashMap value =new HashMap();
    public static void sup(){
        System.out.println("sup()");
    }
}
public class SubClass extends SuppeClass{
    static {
        System.out.println("sub init");
    }
    public static void sub(){
        System.out.println("sub()");
    }
}
public class CLTest1 {
    public static void main(String[] args) {
        SubClass.sup();
    }
}

打印
super class init
sup()
只初始化SuperClass
```
### 当子类初始化时必须先初始化父类
### SubClass []subClass =new SubClass[10]; 数组的创建不会使对应的Class初始化

## JVM 配置参数
```
-XX:+TraceClassLading 跟踪类加载

```
