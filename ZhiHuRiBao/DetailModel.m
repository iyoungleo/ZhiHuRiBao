//
//  DetailModel.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"imageSource" : @"image_source",
             @"shareURL" : @"share_url",
             @"HTMLURL" : @"htmlUrl"};
}

@end
