//  Created by yeeku on 2013-4-8.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.

#import "user-extend.h"

@implementation FKUser
- (void)test
{
	NSLog(@"test");
}

- (void)fun
{
	NSLog(@"fun");
}

-(BOOL) respondsToSelector:(SEL)aSelector {  
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  
    return [super respondsToSelector:aSelector];  
} 
// 为3个property合成setter和getter方法，
// 指定name property底层对应的成员变量名为_name
// @synthesize name = _name;
// @synthesize pass;
// @synthesize birth;
// // 实现自定义的setName:方法，添加自己的控制逻辑
// - (void) setName:(NSString*) name
// {
// 	self->_name = [NSString stringWithFormat:@"+++%@"
// 		 , name];
// }
@end

@interface NSString(slr)
@end

@implementation NSString(slr)
-(BOOL) respondsToSelector:(SEL)aSelector {  
    printf("slr SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  
    return [super respondsToSelector:aSelector];  
} 
@end