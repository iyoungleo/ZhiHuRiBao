//
//  TopView.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/22.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface TopContentView : UIView

@property (nonatomic, strong) StoryModel *topStory;
@property (nonatomic, copy) void (^tappedWithID)(NSNumber *ID);

- (void)setWithTopStory:(StoryModel *)topStory;

@end
