//
//  HTTPTool.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/26.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import "HTTPTool.h"
#import "MBProgressHUD.h"

@implementation HTTPTool

+ (void)get:(NSString *)URLString
     params:(NSDictionary *)params
    success:(callBack)success
    failure:(void (^)(NSError *))failure {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
    static AFHTTPSessionManager *sessionManager;
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    [sessionManager GET:URLString
             parameters:params
               progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task,
                id  _Nullable responseObject) {
        
        if (success) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        
        if (failure) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            failure(error);
        }
        
    }];
    
}

@end
