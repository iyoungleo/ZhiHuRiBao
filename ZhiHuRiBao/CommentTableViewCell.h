//
//  LYCommentTableViewCell.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/19.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, assign) CGFloat height;

- (void)setCellWithComment:(CommentModel *)comment;
- (void)setHeightWithComment:(CommentModel *)comment;

@end
