//
//  LYTableViewCell.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/18.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface NewsCell : UITableViewCell

- (void)setCellWithStory:(StoryModel *)story;

@end
