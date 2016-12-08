//
//  LYLatestStories.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/21.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "NewsTool.h"

@interface NewsTool ()

@property (nonatomic, strong) NSMutableArray *allFormerStories;

@end

@implementation NewsTool

- (void)getNewsWithSuccess:(callBack)handle {
    NSString *URLString = @"http://news-at.zhihu.com/api/4/news/latest";
    [HTTPTool get:URLString
           params:nil
          success:^(id responseObject) {
              
        // 最新的字典里包含3个键值对，3个键分别是@"date"、@"stories"和@"top_stories"
        handle(responseObject);
              
    } failure:^(NSError *error) {
        
        NSLog(@"failure error:%@", error.localizedDescription);
        
    }];
}

- (NSMutableArray *)allFormerStories {
    if (_allFormerStories == nil) {
        _allFormerStories = [NSMutableArray array];
    }
    return _allFormerStories;
}

- (void)getFormerStoriesWithSuccess:(callBack)handle {
    // 获取已下载数据的最早日期
    NSDate *date = [NSDate date];
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
    }
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (self.allFormerStories.count > 0) {
        NSUInteger count = self.allFormerStories.count;
        NSDictionary *formestStories = self.allFormerStories[count - 1];
        dateString = [formestStories valueForKeyPath:@"date"];
    }
    
    // 拼接网址
    NSString *baseURLString = @"http://news.at.zhihu.com/api/4/news/before/";
    NSString *URLString = [baseURLString stringByAppendingPathComponent:dateString];
    [HTTPTool get:URLString
           params:nil
          success:^(id responseObejct) {
              
        // 保存加载到的字典，字典里有两个键值对，两个键分别是@"date"和@"stories"
        [self.allFormerStories addObject:responseObejct];
        handle(responseObejct);
              
    } failure:^(NSError *error) {
        
        NSLog(@"get former stories failure:%@", error.localizedDescription);
        
    }];
}

@end
