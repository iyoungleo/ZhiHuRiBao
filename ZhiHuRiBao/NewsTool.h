//
//  LYLatestStories.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/21.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTool.h"

@interface NewsTool : NSObject

- (void)getNewsWithSuccess:(callBack)handle;
- (void)getFormerStoriesWithSuccess:(callBack)handle;

@end
