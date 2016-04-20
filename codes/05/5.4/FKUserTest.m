//  Created by yeeku on 2013-4-8.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.

// #import "FKUser.h"
// #import "user-extend.h"
#import <Foundation/Foundation.h>
int main(int argc , char * argv[])
{
	@autoreleasepool{
		// // 创建FKUser对象
		// FKUser* user = [[FKUser alloc] init];
		// // 调用setter方法修改user成员变量的值
		// // user.name = @"admin";
		// // NSLog(@"管理员账号为：%@",user.name);
		// [user performSelector:@selector(setName:) withObject:@"admin"];
		// NSLog(@"管理员账号为：%@",[user performSelector:@selector(name)]);
		// // [user setName:@"admin"];
		// // NSLog(@"管理员账号为：%@",[user name]);
		// user.pass = @"1234";
		// NSLog(@"[pass]：%@",user.pass);
		// [user fun];
		// [user respondsToSelector:@selector(fun)];
		// [user performSelector:@selector(fun)];
		// [user setPass:@"1234"];
		// [user setBirth:[NSDate date]];
		// // 访问user成员变量的值
		// NSLog(@"管理员账号为：%@，密码为：%@，生日为：%@"
		// 	, [user name] , [user pass] , [user birth]);
		NSString *s = @"hell";
	    [s respondsToSelector:@selector(fun)];

	}
}
