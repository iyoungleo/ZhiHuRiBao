//
//  CommentButton.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/27.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "CommentButton.h"

@implementation CommentButton

+ (instancetype)buttonWithTitle:(NSString *)title {
    CommentButton *commentButton = [CommentButton buttonWithType:UIButtonTypeCustom];
    [commentButton setTitle:@"查看评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentButton setBackgroundColor:[UIColor blackColor]];
    return commentButton;
}

@end
