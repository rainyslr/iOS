#include<objc/runtime.h>
#import<Foundation/Foundation.h>

int cfunction(id self, SEL _cmd, NSString *str) {

    NSLog(@"%@", str);

    return 10;//随便返回个值

}

int cfunctionA(id self, SEL _cmd, NSString *str, NSString *str1) {

    NSLog(@"%@-%@", str, str1);

    return 20;//随便返回个值

}

@interface CustomClass : NSObject

- (void) fun1;

@end


@implementation CustomClass

- (void) fun1

{

	NSLog(@"fun1");

}

@end

@interface TestClass : NSObject
- (void) fun2;
@end

@implementation TestClass
- (void) fun2
{
	NSLog(@"fun2");
}
@end
@interface MyTest:NSObject
- (void) copyObj;
- (void) objectDispose;
- (void) setClassTest;
- (void) getClassTest;
- (void) getClassName;
- (void) oneParam;
- (void) twoParam;
@end

@implementation MyTest

- (void) copyObj
{
	CustomClass *obj = [CustomClass new];
	NSLog(@"%p", &obj);
	id objTest = object_copy(obj,sizeof(obj));
	NSLog(@"%p", &objTest);
	[objTest fun1];
}
- (void) objectDispose

{
	CustomClass *obj = [CustomClass new];
	NSLog(@"%ld",obj.retainCount);// output :1
	[obj retain];//为什么retain和release都不会对次数产生影响呢
	object_dispose(obj);
	NSLog(@"%ld",obj.retainCount);//output:1
	[obj release];//crash,pointer being freed was not allocated
	//NSLog(@"%ld",obj.retainCount);
	//	[obj fun1];
}

- (void) setClassTest
{
	CustomClass *obj = [CustomClass new];
	[obj fun1];
	Class aClass =object_setClass(obj, NSClassFromString(@"TestClass"));
	//obj 对象的类被更改了    swap the isa to an isa
	NSLog(@"aClass:%@",NSStringFromClass(aClass));//输出CustomClass，说明object_setClass返回的是设置之前的值
	NSLog(@"obj class:%@",NSStringFromClass([obj class]));
	[obj fun2];
}

- (void) getClassTest
{
	CustomClass *obj = [CustomClass new];
	Class aLogClass =object_getClass(obj);
	NSLog(@"%@",NSStringFromClass(aLogClass));

}

- (void) getClassName

{

    CustomClass *obj = [CustomClass new];

    //NSString *className = [NSStringstringWithCString:object_getClassName(obj)encoding:NSUTF8StringEncoding];
    // const char* char_f;
    // char_f ＝ object_getClassName(obj)；
	//NSString *className = [CFStringCreateWithCString:object_getClassName(obj)];
    // NSString *ame = [NSString stringWithUTF8String:char_f];
    NSString *ame = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSLog(@"className:%@", ame);

}

- (void) oneParam {

    TestClass *instance = [[TestClass alloc]init];
    //    方法添加
    class_addMethod([TestClass class],@selector(ocMethod:), (IMP)cfunction,"i@:@");
    if ([instance respondsToSelector:@selector(ocMethod:)]) {
        NSLog(@"Yes, instance respondsToSelector:@selector(ocMethod:)");
    } else
    {
        NSLog(@"Sorry");
    }
    int a = (int)[instance ocMethod:@"我是一个OC的method，C函数实现"];
    NSLog(@"a:%d", a);
}

- (void) twoParam {
    TestClass *instance = [[TestClass alloc]init];
    class_addMethod([TestClass class],@selector(ocMethodA::), (IMP)cfunctionA,"i@:@@");
    if ([instance respondsToSelector:@selector(ocMethodA::)]) {
        NSLog(@"Yes, instance respondsToSelector:@selector(ocMethodA::)");
    } else
    {
        NSLog(@"Sorry");
    }
    int a = (int)[instance ocMethodA:@"我是一个OC的method，C函数实现" :@"-----我是第二个参数"];
    NSLog(@"a:%d", a);
}
@end


int main()
{
	MyTest *test = [MyTest new];
//	[test objectDispose];
	// [test getClassTest];
	// [test setClassTest];
	// [test getClassName];
	// [test oneParam];
	[test twoParam];
	return 0;
}
