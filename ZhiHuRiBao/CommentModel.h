//
//  CommentModel.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/26.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface CommentModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *likes;
@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, copy) NSString *avatar;

@end
