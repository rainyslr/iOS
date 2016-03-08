#include<objc/runtime.h>
#import<Foundation/Foundation.h>

@interface ClassCustomClass :NSObject{
    NSString *varTest1;
    NSString *varTest2;
    NSString *varTest3;
}
@property (nonatomic,assign)NSString *varTest1;
@property (nonatomic,assign)NSString *varTest2;
@property (nonatomic,assign)NSString *varTest3;
- (void) fun1;
@end

@implementation ClassCustomClass

@synthesize varTest1, varTest2, varTest3;

- (void) fun1 {
    NSLog(@"fun1");
}

@end

@interface ClassCustomClassOther :NSObject {
    int varInt;
    ClassCustomClass *customobj;
}
@property (nonatomic,assign)NSString *strProperty;
- (void) fun2;

@end


@implementation ClassCustomClassOther
@synthesize strProperty;
- (void) fun2 {

    NSLog(@"fun2");

}

@end

@interface Priva:NSObject{
    @private  
    NSMutableString *mt_; 
    float myFloat;

}
- (void) showVar;
- (void) setInstanceVar;
@end

@implementation Priva 

- (void) showVar
{
	NSLog(@"%@",mt_);
}

- (void) setInstanceVar
{
	NSLog(@"%f", myFloat);
	float newValue = 10.00;
    // object_setInstanceVariable(self,"myFloat", (void *)&newValue);

   	unsigned int* addr = (unsigned int*)&newValue;
   	//fail too ;
    object_setInstanceVariable(self,"myFloat", *(float**)(&addr));
    NSLog(@"%f", myFloat);
}

- (id)init {  
    self = [super init];  
    if (self) {  
        mt_ = [NSMutableString stringWithString:@"Ha Ha Ha"];  
        myFloat = 20.0;
    }  
    return self;  
}  

- (void) dealloc {  
    [mt_ release];  
    [super dealloc];  
} 

@end 

@interface Test : NSObject
- (void) getClassAllMethod;
- (void) propertyNameList;
- (void) getPrivateVar;
- (void) getVarType;
- (void)nameOfInstance:(id)instance;
@end



@implementation Test

- (void) getClassAllMethod

{
    u_int count;
    Method* methods= class_copyMethodList([ClassCustomClass class], &count);
    for (int i = 0; i < count ; i++)
    {
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name)encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strName);
    }
    //we can see that the output include 7 functions ,including the setter and getter
}

- (void) propertyNameList

{
    u_int count;
    objc_property_t *properties=class_copyPropertyList([ClassCustomClass class], &count);
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        NSString *strName = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strName);
    }
}

- (void) getPrivateVar {

 NSString *str;  
 Priva *obj = [[Priva alloc] init];  
 object_getInstanceVariable(obj, "mt_", (void *)&str);  
 NSLog(@"%@",str); 
     float fvalue;
    object_getInstanceVariable(obj, "myFloat", (void *)&fvalue);  
    NSLog(@"%f", fvalue);
// NSMutableString* newValue = [NSMutableString stringWithString:@"Sue"]; 
// unsigned int addr = (unsigned int)&newValue;
// object_setInstanceVariable(obj,"mt_", *(NSMutableString**)addr);
// object_getInstanceVariable(obj, "mt_", (void *)&str);  
//  NSLog(@"%@",str); 

    //why threre always exit a segments fault
    // float newValue = 10.00f;
    // object_setInstanceVariable(obj,"myFloat", (void *)&newValue);
    // object_getInstanceVariable(obj, "myFloat", (void *)&fvalue);  
    // NSLog(@"%f", fvalue);
 [obj release]; 
}

- (void) getVarType {

    ClassCustomClassOther *obj = [ClassCustomClassOther new];
    unsigned int numIvars =0;
    NSString *key=nil;
    //Describes the instance variables declared by a class. 
    Ivar * ivars = class_copyIvarList([ClassCustomClassOther class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type =ivar_getTypeEncoding(thisIvar);
        NSString *stringType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSLog(@"%@",stringType);
	    if ([stringType hasPrefix:@"@"]) {
	        // handle class case
	        NSLog(@"handle class case");
	    } else if ([stringType hasPrefix:@"i"]) {
	        // handle int case
	        NSLog(@"handle int case");
	    } else if ([stringType hasPrefix:@"f"]) {
	        // handle float case
	        NSLog(@"handle float case");
	    } else

	    {

	     }
 }
  [obj release]; 

}

- (void *)nameOfInstance:(id)instance

{
	ClassCustomClass* allobj = [ClassCustomClass new];

    allobj.varTest1 =@"varTest1String";

    allobj.varTest2 =@"varTest2String";

    allobj.varTest3 =@"varTest3String";
    unsigned int numIvars =0;
    NSString *key=nil;
    //Describes the instance variables declared by a class. 
    Ivar * ivars = class_copyIvarList([ClassCustomClass class], &numIvars);
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type =ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        //不是class就跳过
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        //Reads the value of an instance variable in an object. object_getIvar这个方法中，当遇到非objective-c对象时，并直接crash
        if ((object_getIvar(allobj, thisIvar) == instance)) {
            // Returns the name of an instance variable.
            key = [NSString stringWithCString:ivar_getName(thisIvar) encoding:NSUTF8StringEncoding];
            //key = [NSStringstringWithUTF8String:ivar_getName(thisIvar)];
            break;

        }

    }
    free(ivars);

    NSLog(@"str:%@", key);

}
@end

int main()
{
	Test *test = [Test new];
	Priva *obj = [[Priva alloc] init]; 
	// [obj setInstanceVar];
	// NSLog(@"%@",obj->mt_);this one is wrong because mt_ is private
	// [obj showVar];
	// [test getClassAllMethod];
	// [test propertyNameList];
	// [test getPrivateVar];
	// [test getVarType];
	[test nameOfInstance:@"varTest1String"];
	return 0;
}
