//
//  GMReader.m
//  OC
//
//  Created by 雷国敏 on 15-3-14.
//  Copyright (c) 2015年 雷国敏. All rights reserved.
//

#import "GMReader.h"



@implementation GMReader
/**
 *  监听到消息后，调用法
 *
 *  @param notification 通知
 */
-(void)receiveNews:(NSNotification *)notification
{
    GMNews *news = notification.object;
    
    
    NSLog(@"======%@  receive a new=================",self.readerName);
    NSLog(@"新闻发布者:%@",news.promulgator);
    NSLog(@"新闻类型:%@",news.newsType);
    // NSLog(@"新闻标题:%@",news.title);
    // NSLog(@"新闻内容:%@",news.contents);
    
}

-(void)dealloc{
    /**
     *  当对象销毁时，需要从通知中心删除监听对象
     */
    [super dealloc];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
