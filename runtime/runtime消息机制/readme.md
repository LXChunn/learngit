###什么是消息转发以及如何消息转发

首先必须知道：
OC中调用方法就是向对象发送消息。

如果不存在会报如下错：
'NSInvalidArgumentException', reason: '-[Person run]: unrecognized selector sent to instance 0x7f9ab3e56840'

响应步骤：
方法在调用时，系统会查看这个对象能否接收这个消息（查看这个类有没有这个方法，或者有没有实现这个方法。）
如果不能接受这个消息，就会调用以下这几个方法，给你“补救”的机会（你可以先理解为几套防止程序crash的备选方案，，我们就是利用这几个方案进行消息转发）

注意：前一套方案实现后一套方法就不会执行。如果这几套方案你都没有做处理，那么程序就会报错crash。

resolve：vi. 解决；决心；分解
forwarding：转发
Signature：署名；签名；信号

方案一：

+ (BOOL)resolveInstanceMethod:(SEL)sel
+ (BOOL)resolveClassMethod:(SEL)sel

方案二：

- (id)forwardingTargetForSelector:(SEL)aSelector

方案三：

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;


[参考连接地址](http://www.jianshu.com/p/1bde36ad9938)

#===========================================================
之后需要做的事情：

1、研究在项目中如何使用
