//
//  GMReader.h
//  OC
//
//  Created by 雷国敏 on 15-3-14.
//  Copyright (c) 2015年 雷国敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMNews.h"

@interface GMReader : NSObject
/**
 *  读者名字
 */
@property (nonatomic, copy) NSString *readerName;


@property (nonatomic, copy) NSString *readType;

/**
 *  接收新闻
 *
 *  @param news 新闻对象
 */
-(void)receiveNews:(GMNews *)news;
@end
