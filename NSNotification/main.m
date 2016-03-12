//
//  main.m
//  28Notification
//
//  Created by 雷国敏 on 15-3-14.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMNews.h"
#import "GMReader.h"

// 如果在一个类中想要执行另一个类中的方法可以使用通知
// 1.创建一个通知对象：使用notificationWithName:object: 或者 notificationWithName:object:userInfo:

//     NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
//                                                                  object:self
//                                                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];

// 这 里需要注意的是，创建自己的通知并不是必须的。而是在创建自己的通知之前，采用NSNotificationCenter类的方 法 postNotificationName:object: 和 postNotificationName:object:userInfo:更加便利的发出通知。这种情况，一般使用NSNotificationCenter的类方法defaultCenter就获得默认的通知对象，这样你就可以给该程序的默认通知中心发送通知了。注意：每一个程序都有一个自己的通知中心，即NSNotificationCenter对象。该对象采用单例设计模式，采用defaultCenter方法就可以获得唯一的NSNotificationCenter对象。

// 注意：NSNotification对象是不可变的，因为一旦创建，对象是不能更改的。

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        /**  通知测试 NSNotification **/
        
        
        NSString *newsType = @"IT";
        
        
        //1.创建新闻对象
        
        GMNews *sineNews = [[GMNews alloc]init];
        sineNews.promulgator = @"新浪新闻";
        sineNews.newsType = newsType;
        sineNews.title = @"IT资信";
        sineNews.contents = @"IT 程序员,就是任性！";

        GMNews *sineNews_mytype = [[GMNews alloc]init];
        sineNews_mytype.promulgator = @"sineNews_mytype";
        sineNews_mytype.newsType = @"Mytype";
        sineNews_mytype.title = @"IT资信";
        sineNews_mytype.contents = @"IT 程序员,就是任性！";

        
        GMNews *netEaseNews = [[GMNews alloc]init];
        netEaseNews.promulgator = @"网易新闻";
        netEaseNews.newsType = newsType;
        netEaseNews.title = @"IT消息";
        netEaseNews.contents = @"人类如果没有IT，那会是什么样？";

        GMNews *netEaseNews_mytype = [[GMNews alloc]init];
        netEaseNews_mytype.promulgator = @"netEaseNews_mytype";
        netEaseNews_mytype.newsType = @"Mytype";
        netEaseNews_mytype.title = @"IT消息";
        netEaseNews_mytype.contents = @"人类如果没有IT，那会是什么样？";

        
        
        
        
        //2.创建阅读对象
        GMReader *readerLgm = [[GMReader alloc]init];
        readerLgm.readerName = @"leigm";
        //reader.readType = newsType;
        GMReader *reader_Mytype = [[GMReader alloc]init];
        reader_Mytype.readerName = @"reader_Mytype";

        GMReader *reader_EaseNews = [[GMReader alloc]init];
        reader_EaseNews.readerName = @"reader_EaseNews";

        GMReader *reader_Mytype_EaseNews = [[GMReader alloc]init];
        reader_Mytype_EaseNews.readerName = @"reader_Mytype_EaseNews";
        
        
        //3.获取默认通知
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];



        //4.注册通知
        /**
         *  注册监听
         *
         *  @param : addObserver: 监听者
         *  @param : selector:    收到通知调用相应方法
         *  @param : name:        监听通知的名称（如果为nil,则接受指定发布者 object 的所有信息）
         *  @param : object:      监听谁发布的通知(如果为nil，则接受所有发布者的所有信息)
         *
         */
        [center addObserver:readerLgm selector:@selector(receiveNews:) name:nil object:nil];
        [center addObserver:reader_Mytype selector:@selector(receiveNews:) name:@"Mytype" object:nil];
        [center addObserver:reader_EaseNews selector:@selector(receiveNews:) name:nil object:netEaseNews];
        [center addObserver:reader_Mytype_EaseNews selector:@selector(receiveNews:) name:@"Mytype" object:netEaseNews];



        
        
        //5.发布通知
        /**
         * 发布通知
         *
         * @param : postNotificationName:    通知的名称
         * @param : object:                  通知的发布者
         * @param : userInfo:                关于通知的信息（额外消息）
         */
//        [center postNotificationName:newsType object:sineNews userInfo:nil];
        
        //不注册消息对象直接发送通知。
        // 发布新浪新闻
        [center postNotificationName:newsType object:sineNews];
        [center postNotificationName:@"Mytype" object:sineNews_mytype];
        // 发布网易新闻
        [center postNotificationName:@"Mytype" object:netEaseNews_mytype];
        [center postNotificationName:newsType object:netEaseNews];
        // 
        
    }
    return 0;
}
