//
//  FKImageUtil.m
//  Link
//
//  Created by 苏丽荣 on 16/4/29.
//  Copyright © 2016年 crazyit.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKImageUtil.h"
#import "FKPieceImage.h"

// 获取连连看所有图片的ID（约定所有图片ID以p_开头）
NSArray* imageValues(NSString* scene)
{
    NSMutableArray* resourceValues = [[NSMutableArray alloc] init];
    NSBundle* bundle = [NSBundle mainBundle];
    NSArray* paths;
    NSString* prefix;
    if ([scene isEqualToString:@"动物世界"]) {
        paths = [bundle pathsForResourcesOfType:@"png" inDirectory:nil];
        prefix = @"an_";
    }
    else if ([scene isEqualToString:@"qq风格"])
    {
        paths = [bundle pathsForResourcesOfType:@"bmp" inDirectory:nil];
        prefix = @"img";
    }
    for (NSString* path in paths)
    {
        NSString* imageName = [path lastPathComponent];
        if ([imageName hasPrefix:prefix])
        {
            [resourceValues addObject:imageName];
        }
    }
    return [NSArray arrayWithArray:resourceValues];
}

/**
 * 随机从sourceValues的集合中获取size个图片ID, 返回结果为图片ID的集合
 * @param sourceValues 从中获取的集合
 * @param size 需要获取的个数
 * @return size个图片ID的集合
 */
NSMutableArray* getRandomValues(NSArray* sourceValues , NSInteger size)
{
    // 创建结果集合
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (int i = 0; i < size; i++)
    {
        // 随机获取一个数字，大于、小于sourceValues.count的数值
        int index = arc4random() % (sourceValues.count);
        // 从图片ID集合中获取该图片对象
        NSString* image = [sourceValues objectAtIndex:index];
        // 添加到结果集中
        [result addObject:image];
    }
    return result;
}

/**
 * 随机获取size个图片资源ID(以p_为前缀的资源名称), 其中size为游戏数量
 * @param size 需要获取的图片ID的数量
 * @return size个图片ID的集合
 */
NSArray* getPlayValues(NSInteger size,NSString* scene)
{
    if (size % 2 != 0)
    {
        // 如果该数除2有余数，将size加1
        size += 1;
    }
    // 再从所有的图片值中随机获取size的一半数量
    NSMutableArray* playImageValues = getRandomValues(imageValues(scene) , size / 2);
    // 将playImageValues集合的元素增加一倍（保证所有图片都有与之配对的图片）
    [playImageValues addObjectsFromArray: playImageValues];
    // 将所有图片ID随机“排序”
    NSInteger i = [playImageValues count];
    while(--i > 0)
    {
        NSInteger j = arc4random() % (i+1);
        [playImageValues exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    return [playImageValues copy];
}

/**
 * 随机获取size个图片资源包装成的FKPieceImage对象
 * @param size 需要获取的图片的数量
 * @return size个图片包装成的FKPieceImage对象的集合
 */
NSArray* getPlayImages(int size,NSString* scene)
{
    // 随机获取size个图片ID组成的集合
    NSArray* resourceValues = getPlayValues(size,scene);
    NSMutableArray* result = [[NSMutableArray alloc] init];
    // 遍历每个图片ID
    for (NSString* value in resourceValues)
    {
        // 加载图片
        UIImage* image = [UIImage imageNamed:value];
        // 封装图片ID与图片本身
        FKPieceImage* pieceImage = [[FKPieceImage alloc]
                                    initWithImage:image imageId:value];
        [result addObject:pieceImage];
    }
    return result;
}
