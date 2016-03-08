#include<objc/runtime.h>
#import<Foundation/Foundation.h>

void dynamicMethodIMP(id self, SEL _cmd)
{
    // implementation ....
    NSLog(@"%@",@"hello dynamic");
}

@interface Priva:NSObject

@end

@implementation Priva 

+ (BOOL) resolveInstanceMethod:(SEL)aSEL
{
    // if (aSEL == @selector(resolveThisMethodDynamically))
    // {
    //       class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
    //       return YES;
    // }
    // return [super resolveInstanceMethod:aSEL];
    NSString *strName = [NSString stringWithCString:sel_getName(aSEL)encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strName);
    if (aSEL == @selector(res))
    {
          class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
          return YES;
    }
    return [super resolveInstanceMethod:aSEL];
    // class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
}

@end 

@interface T1 : NSObject


@end



@implementation T1


@end

@interface Test : NSObject

@end



@implementation Test


@end

int main()
{
    Priva* pc = [Priva new];
    [pc res];
    T1* t1p = [T1 new];
    [t1p res];
	return 0;
}
