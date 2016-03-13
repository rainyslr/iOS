#import<Foundation/Foundation.h>
int main(int argc,char* argv[])
{
	@autoreleasepool{
		unsigned short data[4] = {97,98,99,100};
		NSString *str = [[NSString alloc] initWithCharacters:data length:6];
		NSString *str3 = @"i may fall in love with you";
		[str3 writeToFile:@"myFile.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
		NSString *str2 = [NSString stringWithContentsOfFile:@"myFile.txt" encoding:NSUTF8StringEncoding error:nil];
		NSLog(@"%@",str2);
		}
	return 0;
}
