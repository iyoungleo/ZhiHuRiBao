//
//  StoryModelB.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/22.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPTool.h"

@interface StoryTool : NSObject

- (void)getStoryWithID:(NSNumber *)ID success:(callBack)handle;

@end
