//
//  MoreView.h
//  AI_XG
//
//  Created by 马红杰 on 2018/7/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreInfo;

@protocol MoreViewDelegate <NSObject>

- (void)MoreViewSelectIndexWithInfo:(MoreInfo *)info withIndex:(NSInteger)index;

@end

@interface MoreView : UIView

@property (nonatomic, weak) id <MoreViewDelegate> delegate;

@property (nonatomic, strong) UIImageView * imageView;

@property (nonatomic, strong) UITableView * tableView;

- (void)reloadMoreViewTableWithArray:(NSArray *)dataArray;

@end
