//
//  LYCommentTableViewCell.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/19.
//  Copyright © 2016年 雷阳. All rights reserved.
//

/*
 BUG笔记：
 1.setCellWithComment:方法只处理cell中的所有标签和图片的内容，不调整contenLabel标签的高度。
 setHeightWithComment:方法只需要根据传入的comment里的text健的值调整contentLabel标签的高度，设置self.height属性值即可，不需要处理其它所有标签和图片的内容。
 2.之前在声明了comment属性后（现已删除），并没有给其赋值，但是在setCellWithComment:方法中提取self.comment中的键值对，而不是setCellWithComment:方法的comment参数中的键值对，导致标签和图片的内容为空。
 */

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "CommentTableViewCell.h"
#import "UIImage+LYImage.h"

@interface CommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithComment:(CommentModel *)comment {
    // 设置头像，裁剪圆角矩形
    NSURL *URL = [NSURL URLWithString:comment.avatar];
    UIImage *placeholderImage = [UIImage imageNamed:@"CommenterPlaceholderImage"];
    __weak typeof(self) weakSelf = self;
    [self.avatarImageView sd_setImageWithURL:URL
                            placeholderImage:placeholderImage
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       CGFloat radius = weakSelf.avatarImageView.bounds.size.width * 0.2f;
                                       UIImage *newImage = [image imageClippedWithCornerRadius:radius];
                                       self.avatarImageView.image = newImage;
                                   }];

    // 设置作者
    self.authorLabel.text = comment.author;
    
    // 设置赞数
    NSNumber *likesNumber = comment.likes;
    self.likesLabel.text = likesNumber.description;

    //!!!:  设置内容（此时不需要调整内容标签的高度）
    self.contentLabel.text = comment.content;
    
    // 设置时间
    NSNumber *timeNumber = comment.time;
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timeNumber.integerValue];
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    self.timeLabel.text = [dateFormatter stringFromDate:time];
}

- (void)setHeightWithComment:(CommentModel *)comment {
    NSString *text = comment.content;
    CGSize size = CGSizeMake(kScreenWidth - self.contentLabel.mj_x - 8.0f, MAXFLOAT);
    CGRect newRect = [text boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : self.contentLabel.font}
                                        context:nil];
    CGSize newSize = newRect.size;
    self.contentLabel.mj_size = newSize;
    
    // 补加timeLabel的高度、timaLabel的上下间隔、以及额外2点
    self.height = CGRectGetMaxY(self.contentLabel.frame) + self.timeLabel.mj_h + 8.0f * 2 + 2.0f;
}

@end
