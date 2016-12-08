//
//  NewsSource.m
//  ZhiHuRiBao
//
//  Created by 雷阳 on 16/4/25.
//  Copyright © 2016年 雷阳. All rights reserved.
//

#import "NewsSource.h"
#import "NewsCell.h"
#import "StoryModel.h"

extern NSString *newsCellIdentifier;

@implementation NewsSource

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier
                                                     forIndexPath:indexPath];
    StoryModel *story = self.stories[indexPath.row];
    [cell setCellWithStory:story];
    return cell;
}

@end
