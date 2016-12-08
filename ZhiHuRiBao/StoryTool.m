//
//  StoryModelB.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/22.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "StoryTool.h"

@implementation StoryTool

- (void)getStoryWithID:(NSNumber *)ID success:(callBack)handle {
    NSString *baseString = @"http://news-at.zhihu.com/api/4/news/";
    NSString *idString = [ID description]; // NSNumber转NSString
    NSString *URLString = [baseString stringByAppendingPathComponent:idString];
    // 例子：http:/news-at.zhihu.com/api/4/news/8272912
    
    [HTTPTool get:URLString params:nil success:^(id responseObject) {
        if (handle) {
            handle(responseObject);
        }
    } failure:^(NSError *error) {
        NSLog(@"Get story failure:%@", error.localizedDescription);
    }];
}

@end
