//
//  TopView.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/22.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "TopContentView.h"

@interface TopContentView ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topSourceLabel;

@end

@implementation TopContentView

- (void)setWithTopStory:(StoryModel *)topStory {
    self.topStory = topStory;

    // 设置图片视图
    UIImageView *imageView = self.topImageView;
    NSString *URLString = topStory.image;
    NSURL *URL = [NSURL URLWithString:URLString];
    UIImage *placeholderImage = [UIImage imageNamed:@"BlankImage"];
    [imageView sd_setImageWithURL:URL
                 placeholderImage:placeholderImage];
    
    // 设置标题标签
    UILabel *label = self.topTitleLabel;
    NSString *text = topStory.title;
    label.text = text;
    CGSize size = CGSizeMake(kScreenWidth, MAXFLOAT);
    CGRect newRect = [text boundingRectWithSize:size
                                        options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName : label.font}
                                        context:nil];
    CGSize newSize = newRect.size;
    label.mj_y = label.mj_y + label.mj_h - newSize.height;
    label.mj_h = newSize.height;
}

- (IBAction)imageViewTapped:(id)sender {
    NSNumber *ID = self.topStory.ID;
    self.tappedWithID(ID);
}

@end
