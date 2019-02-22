//
//  MoreCell.h
//  AI_XG
//
//  Created by ydz on 2018/11/9.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreInfo : NSObject

@property (nonatomic, copy) NSString * imageUrl;

@property (nonatomic, copy) NSString * leftName;

@property (nonatomic, copy) NSString * rightName;

@end


@interface MoreCell : UITableViewCell

- (void)reloadMoreCellWithInfo:(MoreInfo *)info;

@end
