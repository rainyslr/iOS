//
//  GMNews.h
//  OC
//
//  Created by 雷国敏 on 15-3-14.
//  Copyright (c) 2015年 雷国敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMNews : NSObject
/**
 *  发布者
 */
@property (nonatomic, copy) NSString *promulgator;


/**
 *  新闻类别
 */
@property (nonatomic, copy) NSString *newsType;


/**
 *  新闻标题
 */
@property (nonatomic, copy) NSString *title;


/**
 *  新闻内容
 */
@property (nonatomic, copy) NSString *contents;

@end
