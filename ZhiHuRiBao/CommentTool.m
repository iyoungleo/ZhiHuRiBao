//
//  CommentModel.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/22.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "CommentTool.h"

@implementation CommentTool

- (void)getCommentsWithID:(NSNumber *)ID success:(callBack)handle {
    NSString *baseURLString = @"http://news-at.zhihu.com/api/4/story/#{id}/long-comments";
    NSString *idString = ID.description;
    NSRange range = [baseURLString rangeOfString:@"#{id}"];
    NSString *URLString = [baseURLString stringByReplacingCharactersInRange:range
                                                                 withString:idString];
    // comment URLString:@"http://news-at.zhihu.com/api/4/story/8264320/long-comments"
    
    [HTTPTool get:URLString
           params:nil
          success:^(id responseObject) {
              
        if (handle) {
            handle(responseObject);
        }
              
    } failure:^(NSError *error) {
        
        NSLog(@"Get comments failure:%@", error.localizedDescription);
        
    }];
}

@end
