//  Created by yeeku on 2013-3-16.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.

#import <Foundation/Foundation.h>

int main(int argc , char * argv[]) 
{
	@autoreleasepool {
		int age = 45;
		if (age > 60)
		{
			NSLog(@"老年人");
		}
		else if (age > 40 && !(age >60))
		{
			NSLog(@"中年人");
		}
		else if (age > 20 && !(age > 60) && !(age > 40 && !(age >60)))
		{
			NSLog(@"青年人");
		}
	}
}
