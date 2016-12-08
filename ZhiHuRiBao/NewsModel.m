//
//  NewsModel.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "NewsModel.h"
#import "StoryModel.h"

@implementation NewsModel

// 指定属性名在查找时所用的键名
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    // @"topStories"是属性名，@"top_stories"是从字典中取值用的key
    return @{@"topStories" : @"top_stories"};
}

// 指定数组属性的元素对应的类
+ (NSDictionary *)mj_objectClassInArray {
    // @"stories"是属性名，[SotryModel class]指明数组类型的属性中的元素类型
    return @{@"stories" : [StoryModel class],
             @"topStories" : [StoryModel class]};
}

@end
