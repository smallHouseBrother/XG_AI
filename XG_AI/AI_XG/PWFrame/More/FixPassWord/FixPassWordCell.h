//
//  FixPassWordCell.h
//  AI_XG
//
//  Created by ydz on 2019/1/30.
//  Copyright © 2019年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixPassWordInfo : NSObject

@property (nonatomic, copy) NSString * titleString;

@property (nonatomic, copy) NSString * placeString;

@property (nonatomic, copy) NSString * inputString;

@end

@interface FixPassWordCell : UITableViewCell

- (void)reloadFixPassWordCellWithInfo:(FixPassWordInfo *)info;

@end
