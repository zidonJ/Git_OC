###iOS与安卓开发异同分析

//打印对象的内存地址
NSLog(@"内存地址1：%p",a);
//打印指针自己的内存地址
NSLog(@"内存地址2：%x",&a);   

####长时间后台
```
service 长时间放在后台 下载 音乐播放
iOS : 
1.注册不同类型的后台权限
2.申请一段时间的后台 开始结束需要成队出现
UIBackgroundTaskIdentifier identifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{

      [[UIApplication sharedApplication] endBackgroundTask: identifier];
      identifier = UIBackgroundTaskInvalid;
}];
    
[[UIApplication sharedApplication] endBackgroundTask:identifier];
```
####广播
```
广播
    全局监听 可以用于不同的组件间通信 (应用内/不同应用)
    多线程通信
iOS:观察者模式
	需要指定观察对象和回调方法(或者blcok),也可以指定回调的队列.
	用完后需要手动移除
```
	    
contentProvider 内容提供者
    进程间数据交互 共享 跨进程通信
    
    
Intent
    协助应用间交互通讯
    action
    category
    data
    
fragment 碎片
依赖于activity  充分利用大屏幕。多个展示于activity 拥有用户界面 相当于一个容器
 
 
####1、开发语言
```
iOS
	1.Objective-c
	2.每个类对应两个文件(.h,.m),'.h'可以内可以写一些变量法法的声明,'.m'内做方法的实现
	3.传引用
	4.oc不支持方法的重载
	5.不能跨平台
	
安卓
	1.java
	2.每个类只有一个文件
	3.值传递
	4.可以支持方法的重载
	5.可以跨平台
```     
####2、系统差异
```
iOS
	非开源系统,类Unix的商业操作系统
	
安卓
	开源,基于Linux

```
####3、程序权限
      
```
iOS
  	沙盒机制
  	所有程序自己的数据和文件都存放在一个独享的，自己的随机生成的目录路径下（生成一次，以后一直用），
  	程序不能访问沙盒和除了系统允许的（例如照片）目录以外的其他任何目录
安卓
	安装目录是固定的
	
```
      
####4、进程
```
iOS
	单进程
   
安卓
	允许非单进程
	<activity>、<service>、<receiver> 和 <provider>—均支持 android:process 属性，此属性可以指定该组件
	应在哪个进程运行
	
```

####5、生命周期
```
iOS
	应用生命周期
	not running--inactive--didFinishLaunching--active--applicationDidBecomeActive
	  active
	  inactive//过度状态 没有交互
	  Background
	  Suspended//运行在后台 没有执行代码
      Terminate
      
安卓
	
	Activity整个生命周期的4种状态
        create-start-resume-runing-----------killed
		1. Running
		2. Paused   暂停交互
		3. Stopped 不可见
		4. killed

```
