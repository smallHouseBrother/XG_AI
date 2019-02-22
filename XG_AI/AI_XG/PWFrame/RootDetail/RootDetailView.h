//
//  CategoryListViewView.h
//  AI_XG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassWordInfo;

@protocol RootDetailViewDelegate <NSObject>

- (void)checkTheSelectedDetailWithInfo:(PassWordInfo *)info;

- (void)deleteSelectedPassWordWithIndex:(NSInteger)index;

@end

@interface RootDetailView : UIView

@property (nonatomic, weak) id <RootDetailViewDelegate> delegate;

@property (nonatomic, strong) UITableView * tableView;

- (void)reloadRootDetailTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
