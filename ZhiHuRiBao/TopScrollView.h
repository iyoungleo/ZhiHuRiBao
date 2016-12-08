//
//  TopScrollView.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/24.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopScrollView : UIScrollView

@property (nonatomic, copy) NSArray *topStories;
@property (nonatomic, strong) NSTimer *timer;

- (void)setWithTopStories:(NSArray *)topStories;

@end
