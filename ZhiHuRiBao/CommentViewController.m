//
//  LYCommentTableViewController.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/20.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentTool.h"
#import "CommentsModel.h"
#import "CommentModel.h"
#import "ToolBar.h"
#import "MJRefresh.h"

#define kCommentCellIdentifier @"commentCell"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *commentTableView;
@property (nonatomic, assign) CGFloat beginOffsetY;
@property (nonatomic, strong) ToolBar *toolBar;

@property (nonatomic, strong) CommentTool *commentTool;
@property (nonatomic, copy) NSArray *comments;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self registerCell];
    [self.view addSubview:self.toolBar];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureStatusBarAndNavigationBar];
}

- (void)configureStatusBarAndNavigationBar {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
}

- (ToolBar *)toolBar {
    if (_toolBar == nil) {
        _toolBar = [[ToolBar alloc] initWithMode:ToolBarModeBack];
        __weak typeof(self) weakSelf = self;
        _toolBar.backBlock = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _toolBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCell {
    NSString *nibName = NSStringFromClass([CommentTableViewCell class]);
    UINib *nib = [UINib nibWithNibName:nibName
                                bundle:nil];
    [self.commentTableView registerNib:nib
                forCellReuseIdentifier:kCommentCellIdentifier];
}

#pragma mark - Fetch data

- (CommentTool *)commentTool {
    if (_commentTool == nil) {
        _commentTool = [[CommentTool alloc] init];
    }
    return _commentTool;
}

- (void)fetchData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.commentTool getCommentsWithID:self.ID
                                success:^(id responseObject) {
                                    
        CommentsModel *commentsModel = [CommentsModel mj_objectWithKeyValues:responseObject];
        self.comments = commentsModel.comments;
        
        if (self.comments.count > 0) {
            // 若有评论，重载评论表视图
            [self.commentTableView reloadData];
            self.commentTableView.tableHeaderView = [[UIView alloc] init];
        } else {
            // 若无评论，评论表视图的表头视图显示一个label
            UILabel *headerLabel = [[UILabel alloc] init];
            headerLabel.text = @"尚无评论哦～～赶紧来一发吧～～";
            headerLabel.font = [UIFont systemFontOfSize:10];
            [headerLabel sizeToFit];
            headerLabel.textAlignment = NSTextAlignmentCenter;
            self.commentTableView.tableHeaderView = headerLabel;
            self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier
                                                                 forIndexPath:indexPath];
    CommentModel *comment = self.comments[indexPath.row];
    [cell setCellWithComment:comment];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 500.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
    CommentModel *comment = self.comments[indexPath.row];
    [cell setHeightWithComment:comment];
    return cell.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate

/**
 *  通过在drag的begin和end时，判断scroll view的offsetY的大小关系，可知用户是在上滑，还是下滑。
 */

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beginOffsetY = scrollView.mj_offsetY;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat offsetY = scrollView.mj_offsetY;
    if (offsetY > self.beginOffsetY && offsetY > 0.0f) {
        [self.toolBar hide];
    } else {
        [self.toolBar show];
    }
}

- (void)dealloc {
    NSLog(@"---------- %s ----------", __FUNCTION__);
}

@end
