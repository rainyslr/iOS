//
//  FKViewController.m
//  SectionTest
//
//  Created by yeeku on 13-6-18.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FKViewController.h"

@interface FKViewController ()

@end

@implementation FKViewController
NSDictionary* tableData;
NSArray* stories;
- (void)viewDidLoad
{
    [super viewDidLoad];
	tableData = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSArray arrayWithObjects:@"孙悟空" , @"猪八戒", @"牛魔王"
			, @"蜘蛛精"  , @"唐僧" , @"沙和尚" , nil] , @"西游记",
		[NSArray arrayWithObjects:@"宝玉" , @"黛玉", @"元春"
	 		, @"探春"  , @"惜春" , @"可卿" , nil] , @"红楼梦",
		[NSArray arrayWithObjects:@"武松" , @"林冲", @"鲁达"
		 	, @"杨志"  , @"宋江" , @"史进" , nil] , @"水浒",
		[NSArray arrayWithObjects:@"关羽" , @"刘备", @"张飞"
		 , @"曹操"  , @"张辽" , @"吕布" , nil] , @"三国演义", nil];
	// 获取tableData的所有key排序后组成的数组
	stories = [[tableData allKeys]
		sortedArrayUsingSelector:@selector(compare:)];
	self.table.dataSource = self;
	self.table.delegate = self;
}
// UITableViewDataSource协议中的方法，该方法的返回值决定表格包含多少个分区
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	// stories集合包含多少个元素，就包含多少个分区
	return stories.count;
}
// UITableViewDataSource协议中的方法，该方法的返回值决定指定分区包含多少个元素
- (NSInteger)tableView:(UITableView *)tableView
 	numberOfRowsInSection:(NSInteger)section
{
	// 获取指定分区对应stories集合中的元素
	NSString* story = [stories objectAtIndex:section];
	// 该stories集合元素包含多少个人物，该分区就包含多少表格行
    NSInteger result = [[tableData objectForKey:story] count];
    NSLog(@"%ld rows in section:%ld",result,section);
	return result;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
	cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	// 获取分区号
	NSUInteger sectionNo = indexPath.section;
	// 获取表格行的行号
	NSUInteger rowNo = indexPath.row;
	NSString* story = [stories objectAtIndex:sectionNo];
	static NSString* cellId = @"cellId";
	UITableViewCell* cell = [tableView
		dequeueReusableCellWithIdentifier:cellId];
	if(cell == nil)
	{
        NSLog(@"create at:%ld,%ld",sectionNo,rowNo);
		cell = [[UITableViewCell alloc] initWithStyle:
			UITableViewCellStyleDefault reuseIdentifier:cellId];
	}
	// 将单元格的边框设置为圆角
	cell.layer.cornerRadius = 12;
	cell.layer.masksToBounds = YES;
	// 为表格行的textLabel设置文本
	cell.textLabel.text = [[tableData objectForKey:story]
		objectAtIndex:rowNo];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"最新有声.png"]];
    return imgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"最新有声.png"]];
    return imgView;
}

// UITableViewDataSource协议中的方法，该方法的返回值用于在表格右边建立一列浮动的索引。
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return stories;
}
// UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的页眉
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection
		:(NSInteger)section
{
	return [stories objectAtIndex:section];
}
// UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的页脚
- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection
		:(NSInteger)section
{
	NSString* story = [stories objectAtIndex:section];	
	return [NSString stringWithFormat:@"一共有%d个人物"
		, [[tableData objectForKey:story] count]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



//告诉tableView，哪一行和哪一个分组标题对应；
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

//在编辑结束cell的时候，保存修改；
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source
{
    
}
@end
