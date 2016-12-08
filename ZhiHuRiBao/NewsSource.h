//
//  NewsSource.h
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NewsSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *stories;

@end
