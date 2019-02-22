//
//  SettingView.h
//  AI_XG
//
//  Created by 马红杰 on 2018/7/14.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewDelegate <NSObject>

- (void)SettingViewDidSelectedIndexPath:(NSIndexPath *)indexPath;

- (void)SettingViewDidSwitchIndexPath:(NSIndexPath *)indexPath withSwitch:(UISwitch *)aSwitch;

@end

@interface SettingView : UIView

@property (nonatomic, weak) id <SettingViewDelegate> delegate;

- (void)reloadSettingViewTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
