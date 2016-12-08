//
//  StoryModel.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface StoryModel : NSObject

/** title 新闻标题 */
@property (nonatomic,copy) NSString *title;
/** images 图像地址 */
@property (nonatomic, strong) NSArray *images;
/** image  界面顶部的图片 */
@property (nonatomic, strong) NSString *image;
/** ID  内容id （注意：字典中的key是"id"） */
@property (nonatomic, strong) NSNumber *ID;
/** multipic   是否多图 */
@property (nonatomic, assign, getter=isMutipic) BOOL multipic;

@end
