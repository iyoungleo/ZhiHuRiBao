//
//  NewsModel.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface NewsModel : NSObject

/** date 日期 */
@property (nonatomic, copy) NSString *date;
/** stories  当日新闻 */
@property (nonatomic, strong) NSArray *stories;
/** topStories  顶部新闻 （注意：字典中的key是top_stories） */
@property (nonatomic, strong) NSArray *topStories;

@end
