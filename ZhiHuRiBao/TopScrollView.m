//
//  TopScrollView.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/24.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <MJRefresh.h>

#import "TopScrollView.h"
#import "TopContentView.h"
#import "NSTimer+Refresh.h"

@interface TopScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) TopContentView *leftContentView;
@property (nonatomic, strong) TopContentView *centerContentView;
@property (nonatomic, strong) TopContentView *rightContentView;
@property (nonatomic, strong) UIPageControl *topPageControl;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TopScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeCenter;
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentSize = CGSizeMake(kScreenWidth * 3, CGRectGetHeight(frame));
        self.contentOffset = CGPointMake(kScreenWidth, 0);
        [self addTopContentViews];
        //!!!: 此时self.superview为nil，因此，无法添加page control到self.superview（即topNewsView对象）上。
    }
    return self;
}

// 添加左中右三张视图，用于显示图像
- (void)addTopContentViews {
    CGFloat height = CGRectGetHeight(self.frame);
    self.leftContentView = [self getNewTopContentView];
    self.leftContentView.frame = CGRectMake(0, 0, kScreenWidth, height);
    [self addSubview:self.leftContentView];
    
    self.centerContentView = [self getNewTopContentView];
    self.centerContentView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, height);
    [self addSubview:self.centerContentView];
    
    self.rightContentView = [self getNewTopContentView];
    self.rightContentView.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, height);
    [self addSubview:self.rightContentView];
}

- (TopContentView *)getNewTopContentView {
    NSString *nibName = NSStringFromClass([TopContentView class]);
    TopContentView *topContentView = [[[NSBundle mainBundle] loadNibNamed:nibName
                                                                    owner:nil
                                                                  options:nil]
                                      firstObject];
    return topContentView;
}

- (UIPageControl *)topPageControl {
    if (_topPageControl == nil) {
        _topPageControl = [[UIPageControl alloc] init];
        _topPageControl.center = CGPointMake(kScreenWidth * 0.5, CGRectGetHeight(self.frame) - 10);
    }
    return _topPageControl;
}

#pragma mark - Set with top stories

- (void)setWithTopStories:(NSArray *)topStories {
    self.topStories = topStories;

    self.topPageControl.numberOfPages = topStories.count;
    // 此时self.superview才存在，才可以添加page control
    [self.superview addSubview:self.topPageControl];

    self.currentPage = 0;
    [self reloadTopContentViews];
    
    // 启动计时器
    [self.timer start];
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithRepeatTimeInterval:2.0f
                                               target:self
                                             selector:@selector(animateMoving)];
    }
    return _timer;
}

// 自动滚动
- (void)animateMoving {
    CGPoint newOffset = CGPointMake(kScreenWidth * 2, 0);
    [self setContentOffset:newOffset animated:YES];
    self.currentPage ++;
    // scroll view滚动后，在0.4秒后刷新三个图像视图
    [NSTimer scheduledTimerWithTimeInterval:0.4f
                                     target:self
                                   selector:@selector(reloadTopContentViews)
                                   userInfo:nil
                                    repeats:NO];
}

#pragma mark - Scroll view delegate

// 手动拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer stop];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.mj_offsetX;
    if (offsetX < kScreenWidth) {
        self.currentPage --;
    } else if (offsetX > kScreenWidth) {
        self.currentPage ++;
    }
    // scroll view停止滚动后，再刷新图片视图
    [self reloadTopContentViews];

    // 再次启动定时器
    [self.timer resumeAfter:5.0f];
}

// 只负责根据当前页数属性刷新三个图片视图。这是自动滚动和手动滚动的共同部分。
- (void)reloadTopContentViews {
    NSArray *topStories = self.topStories;
    NSUInteger count = self.topStories.count;
    
    // 检查self.currentPage是否越界。self.currentPage的取值范围是[0, count - 1]。
    if (self.currentPage < 0) {
        self.currentPage = count - 1;
    } else if (self.currentPage >= count) {
        self.currentPage = 0;
    }
    
    NSInteger currentPage = self.currentPage;
    
    NSInteger leftPage = currentPage - 1;
    if (leftPage < 0) {
        leftPage = count - 1;
    }
    [self.leftContentView setWithTopStory:topStories[leftPage]];
    
    [self.centerContentView setWithTopStory:topStories[currentPage]];
    
    NSInteger rightPage = currentPage + 1;
    if (rightPage >= topStories.count) {
        rightPage = 0;
    }
    [self.rightContentView setWithTopStory:topStories[rightPage]];
    
    // 悄悄滚到正中间的视图上
    CGPoint newOffset = CGPointMake(kScreenWidth, 0);
    [self setContentOffset:newOffset
                  animated:NO];
    
    [self.topPageControl setCurrentPage:self.currentPage];
}

@end
