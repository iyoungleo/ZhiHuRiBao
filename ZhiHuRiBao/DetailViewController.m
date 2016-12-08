//
//  LYDetailViewController.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/18.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "DetailViewController.h"
#import "CommentViewController.h"
#import "ToolBar.h"
#import "StoryTool.h"
#import "DetailModel.h"
#import "MJExtension.h"

CGFloat const kImageViewHeight = 200.0f;

@interface DetailViewController () <UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *imageSourceLabel;

@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, assign) CGFloat initialInsetTop;
@property (nonatomic, assign) CGFloat beginOffsetY;
@property (nonatomic, strong) ToolBar *toolBar;

@property (nonatomic, strong) StoryTool *storyTool;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configureScrollView];
    [self.view addSubview:self.toolBar];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureStatusBarAndNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置导航栏和状态栏
- (void)configureStatusBarAndNavigationBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)configureScrollView {
    // 找到web view里的scroll view
    for (UIView *view in self.webView.subviews) {
        //!!!: 不能用isMemeberOfClass:方法
        if ([view isKindOfClass:[UIScrollView class]]) {
            self.scrollView = (UIScrollView *)view;
            self.scrollView.delegate = self;
            self.scrollView.showsHorizontalScrollIndicator = NO;
            
            // 设置顶部镶边
            self.initialInsetTop = self.imageView.mj_h;
            UIEdgeInsets inset = UIEdgeInsetsMake(self.initialInsetTop, 0, 0, 0);
            [self.scrollView setContentInset:inset];
            [self.scrollView setScrollIndicatorInsets:inset];
        }
    }
}

- (ToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[ToolBar alloc] initWithMode:ToolBarModeBackComment];
        __weak typeof(self) weakSelf = self;
        _toolBar.commentBlock = ^() {
            [weakSelf viewComments];
        };
        _toolBar.backBlock = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _toolBar;
}

- (StoryTool *)storyTool {
    if (_storyTool == nil) {
        _storyTool = [[StoryTool alloc] init];
    }
    return _storyTool;
}

#pragma mark - 获取数据

- (void)fetchData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.storyTool getStoryWithID:self.ID success:^(id responseObejct) {
        // 主线程中
        DetailModel *detail = [DetailModel mj_objectWithKeyValues:responseObejct];

        // webView加载网页
        //        NSURL *URL = [NSURL URLWithString:detail.shareURL];
        //        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        //        [self.webView loadRequest:request];
        
        // webView加载本地HTML
        [self.webView loadHTMLString:detail.body baseURL:nil];
        // 保存HTML文件
        //        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"story.html"];
        //        NSLog(@"path:%@", path);
        //        [detail.body writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        // imageView加载图片
        NSURL *imageURL = [NSURL URLWithString:detail.image];
        [self.imageView sd_setImageWithURL:imageURL];

        // imageSourceLabel更新文本
        NSString *string = [NSString stringWithFormat:@"图片：%@", detail.imageSource];
        self.imageSourceLabel.text = string;
        [self.imageSourceLabel sizeToFit];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - 网页视图代理协议

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"---------- %s ----------", __FUNCTION__);
    //TODO: 
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"---------- %s ----------", __FUNCTION__);
    // 根据内容调整页面大小
    //    webView.mj_h = 1.0f;
    //    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    //    webView.mj_size = fittingSize;
    
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){ \
        var objs = document.getElementsByTagName(\"img\"); \
        for(var i = 0; i < objs.length; i++){ \
            objs[i].onclick = function() { \
                document.location = \"myweb:imageClick:\"+this.src;\
            };\
        };\
        return objs.length;\
    };";
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];

    // 调整图片大小
    NSString *jsImgAutoFit =
    @"function imgAutoFit() { \
        var imgs = document.getElementsByTagName('img'); \
        for (var i = 0; i < imgs.length; ++i) { \
            var img = imgs[i]; \
            img.style.maxWidth = %f; \
        } \
    }";
    jsImgAutoFit = [NSString stringWithFormat:jsImgAutoFit, [UIScreen mainScreen].bounds.size.width - 20];
    [webView stringByEvaluatingJavaScriptFromString:jsImgAutoFit];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
}

#pragma mark - 网页视图内部的滚动视图代理协议

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginOffsetY = scrollView.mj_offsetY;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.mj_offsetY > 0) {
        self.imageView.mj_y = -self.initialInsetTop;
        self.imageView.mj_h = self.initialInsetTop;
    } else if (scrollView.mj_offsetY > -self.initialInsetTop) {
        self.imageView.mj_y = -scrollView.mj_offsetY - self.initialInsetTop;
        self.imageView.mj_h = self.initialInsetTop;
    } else {
        self.imageView.mj_y = 0;
        self.imageView.mj_h = -scrollView.mj_offsetY;
    }
    self.imageSourceLabel.mj_y = CGRectGetMaxY(self.imageView.frame) - self.imageSourceLabel.mj_h - 10;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offsetY = scrollView.mj_offsetY;
    if (offsetY > self.beginOffsetY && offsetY > 0.0f) {
        // 向上滑动屏幕关闭导航栏
        [self.toolBar hide];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        self.statusBarHidden = YES;
    } else {
        // 向下滑动屏幕显示状态栏、导航栏和工具栏
        [self.toolBar show];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.statusBarHidden = NO;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.initialInsetTop = scrollView.mj_offsetY;
}

#pragma mark - 返回新闻界面

- (IBAction)backToLatestView:(id)sender {
    // 向右滑动屏幕返回主页
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 转场评论界面

- (void)viewComments {
    CommentViewController *commentTableViewController = [[CommentViewController alloc] init];
    commentTableViewController.ID = self.ID;
    [self showViewController:commentTableViewController sender:nil];
}

- (void)dealloc {
    NSLog(@"---------- %s ----------", __FUNCTION__);
}

@end
