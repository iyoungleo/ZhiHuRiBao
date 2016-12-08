//
//  CircleScrollView.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/21.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

#import "TopNewsView.h"

CGFloat const topNewsViewHeight = 200.0f;

@interface TopNewsView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *topStories;

//@property (nonatomic, strong) UIPageControl *topPageControl;
@property (nonatomic, strong) UIScrollView *observedScrollView;

@end

@implementation TopNewsView

+ (instancetype)attachToView:(UIView *)view
           observeScrollView:(UIScrollView *)scrollView {
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, topNewsViewHeight);
    TopNewsView *topNewsView = [[TopNewsView alloc] initWithFrame:frame];
    //!!!: 设置一个observedScrollView属性强引用内容表视图
    topNewsView.observedScrollView = scrollView;
    [topNewsView.observedScrollView addObserver:topNewsView
                                     forKeyPath:@"contentOffset"
                                        options:NSKeyValueObservingOptionNew
                                        context:nil];
    return topNewsView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topScrollView];
        // 在topScrollView的创建过程中，添加pageControl到自身上。
    }
    return self;
}

- (TopScrollView *)topScrollView {
    if (_topScrollView == nil) {
        _topScrollView = [[TopScrollView alloc] initWithFrame:self.bounds];
    }
    return _topScrollView;
}

#pragma mark - Set with top stories

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat offsetY = offset.y;
    if (offsetY > 0) {
        self.mj_y = -topNewsViewHeight;
        self.mj_h = topNewsViewHeight;
    } else if (offsetY > -topNewsViewHeight) {
        self.mj_y = -offsetY - topNewsViewHeight;
        self.mj_h = topNewsViewHeight;
    } else if (offsetY > -topNewsViewHeight - 100.0f) {
        // 向下滑动，scroll view和其内部的image view，还有page control的高度均变大。
        self.mj_y = 0;
        self.mj_h = -offsetY;
    }
}

@end
