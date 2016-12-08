//
//  ToolBar.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/30.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ToolBarMode) {
    ToolBarModeBack,
    ToolBarModeBackComment,
};

typedef void (^CallBack)();

@interface ToolBar : UIView

@property (nonatomic, assign) ToolBarMode mode;

@property (nonatomic, copy) CallBack backBlock;
@property (nonatomic, copy) CallBack commentBlock;

- (instancetype)initWithMode:(ToolBarMode)mode;

- (void)show;
- (void)hide;

@end
