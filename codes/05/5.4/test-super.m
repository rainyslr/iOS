#import <Foundation/Foundation.h>


@interface Father : NSObject
@end

@interface Son : Father
@end

@implementation Father
@end 

@implementation Son : Father
- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"init:%@", NSStringFromClass([self class]));
        NSLog(@"init:%@", NSStringFromClass([super class]));
    }
    return self;
}
@end

int main()
{
    // Father *f = [[Father alloc] init];
    // NSLog(@"in main %@", NSStringFromClass([f class]));
    // Son *s = [[Son alloc] init];;
    // NSLog(@"son in main:%@", NSStringFromClass([s class]));
    // [s test];
    // NSString *s1 = @"hell";
    // [s1 respondsToSelector:@selector(fun)];
    
}