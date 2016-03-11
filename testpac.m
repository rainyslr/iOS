#import <Foundation/Foundation.h>
@interface App:NSObject
{
//	@package 
		double _weight;
}
@end
@implementation App
@end
int main(int argc,char* argv[])
{
	@autoreleasepool{
		App* app = [[App alloc] init];
		app ->_weight = 30.1;
		NSLog(@"%f",app -> _weight);
	}
}

