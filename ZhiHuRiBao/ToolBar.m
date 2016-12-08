//
//  ToolBar.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/30.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "ToolBar.h"
#import "CommentButton.h"

#define kToolBarWidth kScreenWidth
#define kToolBarHeight 80.0f

@interface ToolBar ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) CommentButton *commentButton;

@end

@implementation ToolBar

- (instancetype)initWithMode:(ToolBarMode)mode {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight - kToolBarHeight, kScreenWidth, kToolBarHeight);
        self.backgroundColor = [UIColor clearColor];
        self.mode = mode;
    }
    return self;
}

- (void)setMode:(ToolBarMode)mode {
    _mode = mode;
    switch (_mode) {
        case ToolBarModeBack: {
            [self addSubview:self.backButton];
            break;
        }
        case ToolBarModeBackComment: {
            [self addSubview:self.backButton];
            [self addSubview:self.commentButton];
            break;
        }
    }
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        UINib *nib = [UINib nibWithNibName:@"BackButton" bundle:nil];
        UIButton *backButton = [[nib instantiateWithOwner:nil options:nil] firstObject];
        CGFloat backButtonHeight = kToolBarHeight * 1.2f;
        CGFloat backButtonWidth = backButtonHeight;
        backButton.bounds = CGRectMake(0, 0, backButtonWidth, backButtonHeight);
        backButton.center = CGPointMake(kToolBarWidth * 0.1f, kToolBarHeight * 0.5f);
        [backButton addTarget:self
                       action:@selector(backButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
        _backButton = backButton;
    }
    return _backButton;
}

- (void)backButtonTapped {
    self.backBlock();
}

- (CommentButton *)commentButton {
    if (_commentButton == nil) {
        _commentButton = [CommentButton buttonWithTitle:@"查看评论"];
        CGFloat commentButtonWidth = kToolBarWidth * 0.5f;
        CGFloat commentButtonHeight = kToolBarHeight * 0.8f;
        _commentButton.bounds = CGRectMake(0, 0, commentButtonWidth, commentButtonHeight);
        _commentButton.center = CGPointMake(kToolBarWidth * 0.7f, kToolBarHeight * 0.5f);
        [_commentButton.layer setCornerRadius:commentButtonHeight * 0.5f];
        [_commentButton.layer setMasksToBounds:YES];
        [_commentButton addTarget:self
                           action:@selector(commentButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentButton;
}

- (void)commentButtonTapped {
    self.commentBlock();
}

- (void)show {
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.0f, kToolBarHeight);
    }];
}

@end
