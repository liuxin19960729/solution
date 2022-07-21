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
    在本质上是调用的常量池里面的数据,在编译阶段会将 200这个值放入CLTest1类的常量池里面,和SuperClass 没有关系
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
```
subClass 的Class 类并不是 SubClass 而是有jvm 通过 newArray 指令创建的
```

### 接口的初始化
```java
note:接口的初始化和Class的初始化存在区别

编译器任然会对接口生成<clinit>()的构造器

public class CLTest1 implements ICLTEST{
    public static void main(String[] args) {
        CLTest1 clTest1 = new CLTest1();
        clTest1.gg();
    }
}

interface ICLTEST extends PICLTEST {
    public static final ZZ zz = new ZZ("ICLTEST");
    default  void gg(){
         System.out.println(dd);
        System.out.println("gg");
    }
}
interface PICLTEST {
    public static final ZZ dd = new ZZ("PICLTEST");
}

  CLTest1 clTest1 = new CLTest1(); 类在初始化时候并不会对全部接口初始化
  只有真正用到那个接口的时候才会进行初始化
```
## 类的加载过程
### Loading(加载)
```
1.通过全限定类名找对应的数据(xxx.class 网络传输数据....)并用二进制流加载到内存里面,按照虚拟设定的格式放入方法区
    jar war 等格式 获取对应的class二进制数据
    运行时动态生成一个Class的数据转化为二进制流加载到内存(Proxy技术)
    jsp 技术 (jsp文件转化为xxxx.class文件 在加载到内存转化为Class对象)
    使用加密文件的形式(防止反编译)
    数据库中读取
2.将二进制流转化为java.Lang.Class对象,放入Heap,堆外提供访问接口（Class定义了程序员访问类型数据的接口）


note:加载(Loading) 和 验证（Verification）,准备(Preparation),解析(Resolution) 是交替进行的
   加载 字节码格式验证.... 

```
### Verification(验证)
```
文件格式验证
   0XCAFEBABE  magic  version ....
元数据验证
   是否有父类 父类是否允许继承(final) ...... 类继承方法  属性等验证
字节码验证
符号引用验证
   符号引用转化wield直接应用
```

### Prepartion(准备)
```
staic修饰的变量分配初始化值
例 
public sttic int a=100; //准备阶段a=0
public sttic Object obj=new Object(); //准备阶段 obj =null
 
```

### resolution(解析)
```
符号引用 等相关解析
```
### Inilization
```
java真正的开始执行代码

public sttic int a=100; //a=100
public sttic Object obj=new Object(); //准备阶段 obj =new Object()


<clinit>()方法调用 通用将值复制上
   <clinit> 所有类变量和  static{} 中的语句合并而成的
....


jvm 保证 <clinit>()方法是线程安全的,初始化类是会加锁
```

## 类加载器
### 类与类加载器
```
Class=ClassLoader+Class
这样保证了唯一性 equal() isAssignableFrom() isInstance()
```
### 双亲委派模型
```
  BootStrapClassLoader C++实现
  继承ClassLoader接口的类 java实现  

1. BootStrapClassLoader  java_home/lib 加载(jvm能够识别出那些xx.jar包被加载(不是任意放入里面的xx.jar都会被加载))

2.Extension Class Loader  (sun.misc.Launcher.$ExtClassLoader)  java系统扩展类加载器
       java_home/lib/ext/   or 系统环境配置 java.ext.dirs
   作用:允许用户把具有通用性的 lib  放入 ext 里面

3.Application Class Loader  (sun.misc.Launcher.$AppClassLoader) 
   负责加载用户 classpath 下的类


加载Class是 classLoader 不会自己加载 会先嫁给 父类加载,父类没加载成功自己才进行加载
这样设计的好处是所有公共的类都是同一个ClassLoader加载的  这样 Class 对象就是同一个对象(解决基础类一致性问题)

```

### 破坏双亲委派模型
```
JNDI SPI  java name and directory interface
名字发现和查找数据的对象,这些对象存储在不同的命名和目录服务中
  远程调用（Remote invocation）
  LDAP Lighweight Directory Access protocal 轻量目录访问协议
  DNS  Domain Name Service
  CORBA Common Object Broker(代理) Artecture 通用对象代理架构

  
```

## JVM 配置参数
```
-Xbootclasspath=xxx  指明BootStrapClassLoader 加载的地址
-XX:+TraceClassLading 跟踪类加载

```
