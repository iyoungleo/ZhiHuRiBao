//
//  UIImage+YLImage.m
//  Image
//
//  Created by 雷阳 on 16/4/5.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "UIImage+LYImage.h"

@implementation UIImage (LYImage)

- (UIImage *)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    // 图片会自动缩放以适应指定rect
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageClippedToRect:(CGRect)rect {
    // 因为CGImageRef已包含＊号（typedef struct CGImage * CGImageRef;），所以声明变量时不能有星号。类似id类型（typedef struct objc_object *id;）。
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:imageRef];
}

- (UIImage *)imageClippedToCircle {
    UIGraphicsBeginImageContext(self.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageClippedWithCornerRadius:(CGFloat)radius {
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 上下文中添加矩形圆角路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                 cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 裁剪出圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                    cornerRadius:size.width * 0.2f];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    // 填充指定颜色
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // 在指定矩形中添加椭圆
    CGSize ellipseSize = CGSizeMake(size.width * 0.6f, size.height * 0.6f);
    CGRect ellipseRect = CGRectMake((size.width - ellipseSize.width) * 0.5f,
                                    (size.height - ellipseSize.height) * 0.5f,
                                    ellipseSize.width,
                                    ellipseSize.height);
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
