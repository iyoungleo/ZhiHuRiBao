//
//  UIImage+YLImage.h
//  Image
//
//  Created by 雷阳 on 16/4/5.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LYImage)

// 返回按指定大小缩放的图像
- (UIImage *)imageScaledToSize:(CGSize)size;

// 返回在指定矩形内裁减出的图像
- (UIImage *)imageClippedToRect:(CGRect)rect;

// 返回圆形图像
- (UIImage *)imageClippedToCircle;

// 返回圆角矩形图像
- (UIImage *)imageClippedWithCornerRadius:(CGFloat)radius;

// 返回指定颜色和大小的矩形图像
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
