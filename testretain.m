#import <Foundation/Foundation.h>
@interface tire:NSObject
{
int size;
}
@end

@implementation tire

- (id) init
{
	if(self = [super init])
	{
		NSLog(@"in init,reference count:%ld",self.retainCount);
	}
	return self;
}

- (void) dealloc
{
	NSLog(@"destroy a tire");
	[super dealloc];
}
@end

@interface car:NSObject

{
int weight;
tire* _tire;
}
- (void) setTire:(tire*) mytire;
@end

@implementation car
- (void) setTire:(tire*) mytire
{
    _tire = mytire;
    [mytire retain];
}
@end

 int main(int argc ,char* argv[])
{
	/************manual reference cout*****************
	tire* at = [[tire alloc] init];
	NSLog(@"referece count:%ld",at.retainCount);//1
	[at retain];
	NSLog(@"referece count:%ld",at.retainCount);//2
	[at release];
	NSLog(@"referece count:%ld",at.retainCount);//1
	[at release];//0
    tire* at2 = [[tire alloc] init];
	NSLog(@"referece count:%ld",at2.retainCount);//1
	tire* at3 = at2;//实际上将指针2的值赋给指针3，手动引用计数下他们所指向对象的引用计数不会增加
	NSLog(@"referece count:%ld",at2.retainCount);//1
	NSLog(@"referece count:%ld",at3.retainCount);//1
	**********************************************/

	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	tire* at = [[tire alloc] init];
	[at autorelease];
	NSLog(@"referece count:%ld",at.retainCount);//1
	// [at release];
	
	// NSLog(@"after referece count:%ld",at.retainCount);//1
	[pool release];
	return 0;
}
