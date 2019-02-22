//
//  AllKindView.h
//  AI_XG
//
//  Created by ydz on 2018/11/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllKindViewDelegate <NSObject>

- (void)AllKindDidSelectedIndexPath:(NSInteger)index;

@end

@interface AllKindView : UIView

@property (nonatomic, weak) id <AllKindViewDelegate> delegate;

@property (nonatomic, strong) UITableView * tableView;

- (void)reloadAllKindTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
