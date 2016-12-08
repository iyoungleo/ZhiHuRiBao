//
//  CircleScrollView.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/21.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopScrollView.h"

@interface TopNewsView : UIView

@property (nonatomic, strong) TopScrollView *topScrollView;

+ (instancetype)attachToView:(UIView *)view observeScrollView:(UIScrollView *)scrollView;

@end
