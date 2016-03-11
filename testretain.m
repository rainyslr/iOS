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
	tire* at = [[tire alloc] init];
	[at retain];
	NSLog(@"referece count:%ld",at.retainCount);
	[at retain];
	NSLog(@"referece count:%ld",at.retainCount);
	[at release];
	NSLog(@"referece count:%ld",at.retainCount);
	[at release];
	[at release];
    tire* at2 = [[tire alloc] init];
	NSLog(@"referece count:%ld",at2.retainCount);
	tire* at3 = at2;//实际上将指针2的值赋给指针3，也就是两个指针指向同一个对象不会增加相应对象的引用计数，这点和c＋不一样
	NSLog(@"referece count:%ld",at2.retainCount);
	NSLog(@"referece count:%ld",at3.retainCount);
	return 0;
}
