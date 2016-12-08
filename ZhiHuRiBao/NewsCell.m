//
//  LYTableViewCell.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/18.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "NewsCell.h"
#import <UIImageView+WebCache.h>

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithStory:(StoryModel *)story {
    NSArray *imageURLs = story.images;
    NSURL *imageURL = [NSURL URLWithString:imageURLs.firstObject];
    UIImage *placeholderImage = [UIImage imageNamed:@"BlankImage"];
    [self.titleImageView sd_setImageWithURL:imageURL
                           placeholderImage:placeholderImage];
    
    self.titleLabel.text = story.title;
}

@end
