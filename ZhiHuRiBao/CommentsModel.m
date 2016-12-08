//
//  CommentsModel.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/26.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "CommentsModel.h"
#import "CommentModel.h"

@implementation CommentsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"comments" : [CommentModel class]};
}

@end
