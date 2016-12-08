//
//  ViewController.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/18.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import <MBProgressHUD.h>

#import "NewsViewController.h"
#import "NewsTool.h"
#import "NewsCell.h"
#import "TopNewsView.h"
#import "TopContentView.h"
#import "NewsModel.h"
#import "StoryModel.h"
#import "NewsSource.h"
#import "NSTimer+Refresh.h"
#import "DetailViewController.h"

NSString * const newsCellIdentifier = @"newsCellIdentifier";
extern CGFloat topNewsViewHeight;

@interface NewsViewController () <UITableViewDelegate>

// 获取新闻的工具
@property (nonatomic, strong) NewsTool *newsTool;

// 顶部滚动视图
@property (nonatomic, strong) TopNewsView *topNewsView;
// 内容表视图
@property (nonatomic, strong) UITableView *contentTableView;
// 内容表视图的新闻数据源
@property (nonatomic, strong) NewsSource *newsSource;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //!!!: 添加顺序————先添加 contentTableView ，后添加 topNewsView 。否则 contentTableView 会遮蔽 topNewsView 。
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.topNewsView];

    [self fetchLatestData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureStatusBarAndNavigationBar];
    if (self.topNewsView.topScrollView.topStories) {
        [self.topNewsView.topScrollView.timer start];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.topNewsView.topScrollView.timer stop];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void)configureStatusBarAndNavigationBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];

    // 设置导航栏标题
    UILabel *label = [[UILabel alloc] init];
    label.text = @"最新消息";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (TopNewsView *)topNewsView {
    if (_topNewsView == nil) {
        _topNewsView = [TopNewsView attachToView:self.view
                               observeScrollView:self.contentTableView];
        __weak typeof(self) weakSelf = self;
        // 设置3个 topContentView 的 tappedWithID 属性
        for (UIView *view in _topNewsView.topScrollView.subviews) {
            if ([view isKindOfClass:[TopContentView class]]) {
                TopContentView *topContentView = (TopContentView *)view;
                topContentView.tappedWithID = ^(NSNumber *ID) {
                    // weakSelf 解决强引用循环
                    [weakSelf enjoyStoryWithID:ID];
                };
            }
        }
    }
    return _topNewsView;
}

- (NewsSource *)newsSource {
    if (_newsSource == nil) {
        _newsSource = [[NewsSource alloc] init];
    }
    return _newsSource;
}

- (UITableView *)contentTableView {
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                         style:UITableViewStylePlain];
        
        // 设置数据源和代理
        _contentTableView.dataSource = self.newsSource;
        _contentTableView.delegate = self;
        
        // 注册 cell
        NSString *nibName = NSStringFromClass([NewsCell class]);
        UINib *latestNib = [UINib nibWithNibName:nibName
                                          bundle:nil];
        [_contentTableView registerNib:latestNib
                forCellReuseIdentifier:newsCellIdentifier];

        // 设置 content table view 的额外滚动区域的顶部距离
        UIEdgeInsets inset = UIEdgeInsetsMake(topNewsViewHeight, 0, 0, 0);
        _contentTableView.contentInset = inset;
        _contentTableView.scrollIndicatorInsets = inset;
        
        // 当下拉内容视图的头部视图时，可以重新加载数据
        _contentTableView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [self fetchLatestData];
        }];
        
        // 上拉加载以前的内容
        _contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                           refreshingAction:@selector(fetchFormerData)];
        
    }
    return _contentTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据

- (NewsTool *)newsTool {
    if (_newsTool == nil) {
        _newsTool = [[NewsTool alloc] init];
    }
    return _newsTool;
}

// 下拉加载最新数据
- (void)fetchLatestData {
    // 暂停计时器
    [self.topNewsView.topScrollView.timer stop];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.newsTool getNewsWithSuccess:^(id responseObject) {
        // 主线程中
        // 字典转模型
        NewsModel *newsModel = [NewsModel mj_objectWithKeyValues:responseObject];
        
        // 提取topStories数组，用于顶部滚动视图加载数据
        [self.topNewsView.topScrollView setWithTopStories:newsModel.topStories];

        // 内容表视图加载数据
        [self.newsSource setStories:(NSMutableArray *)newsModel.stories];
        [self.contentTableView reloadData];
        [self.contentTableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

// 上拉加载过往数据
- (void)fetchFormerData {
    [self.newsTool getFormerStoriesWithSuccess:^(id responseObejct) {
        // 主线程中        
        NewsModel *fetchedNews = [NewsModel mj_objectWithKeyValues:responseObejct];
        NSUInteger fetchedCount = self.newsSource.stories.count;
        
        // 内容表视图数据源添加获取的过往数据
        [self.newsSource.stories addObjectsFromArray:fetchedNews.stories];
        
        // 计算获取到的过往数据在内容表视图中对应的显示位置
        NSUInteger totalCount = self.newsSource.stories.count;
        NSMutableArray *mIndexPaths = [NSMutableArray array];
        for (NSUInteger i = fetchedCount; i < totalCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [mIndexPaths addObject:indexPath];
        }
        NSArray *indexPaths = [mIndexPaths copy];
        
        // 在内容表视图中对应位置插入表格行
        [self.contentTableView insertRowsAtIndexPaths:indexPaths
                                     withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.contentTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 内容表视图的滚动视图代理协议

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.mj_offsetY;
    if ((offsetY >= -topNewsViewHeight) && (offsetY < 0)) {
        // 在内容表视图从最初位置到垂直偏移为0的上滑过程中，导航栏逐渐变清晰
        CGFloat alpha = 1 + scrollView.mj_offsetY / topNewsViewHeight;
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
    } else if (offsetY >= 0) {
        // 在继续上滑内容表视图，直到垂直偏移大于0后，导航栏完全不透明
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1.0f];
    }
}

#pragma mark - 内容表视图的表视图代理协议

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier];
    CGFloat height = cell.contentView.bounds.size.height;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StoryModel *story = self.newsSource.stories[indexPath.row];
    NSNumber *ID = story.ID;
    [self enjoyStoryWithID:ID];
}

#pragma mark - 跳转到详情界面

- (void)enjoyStoryWithID:(NSNumber *)ID {
    DetailViewController *storyViewController = [[DetailViewController alloc] init];
    storyViewController.ID = ID;
    [self showViewController:storyViewController sender:nil];
}

- (void)dealloc {
    NSLog(@"---------- %s ----------", __FUNCTION__);
}

@end
