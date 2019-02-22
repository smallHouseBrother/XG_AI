//
//  SettingCell.h
//  AI_XG
//
//  Created by ydz on 2018/11/9.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCell;

@interface SettingInfo : NSObject

@property (nonatomic, copy) NSString * imageUrl;

@property (nonatomic, copy) NSString * sectionName;

@property (nonatomic, copy) NSString * leftName;

@property (nonatomic, copy) NSString * rightName;

@property (nonatomic) BOOL isSwitch;

@property (nonatomic) BOOL isOn;

@end


@protocol SettingCellDelegate <NSObject>

- (void)SettingCellSwitchStatus:(SettingCell *)cell withSwitch:(UISwitch *)aSwitch;

@end

@interface SettingCell : UITableViewCell

@property (nonatomic, weak) id <SettingCellDelegate> delegate;

- (void)reloadSettingCellWithInfo:(SettingInfo *)info;

@end





