//
//  HTTPTool.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/26.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callBack)(id responseObejct);

@interface HTTPTool : NSObject

+ (void)get:(NSString *)URLString params:(NSDictionary *)params success:(callBack)success failure:(void (^)(NSError *error))failure;

@end
