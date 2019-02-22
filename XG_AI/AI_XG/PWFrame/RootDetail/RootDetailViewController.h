//
//  CategoryListViewController.h
//  AI_XG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

@class RootInfo;

@protocol RootDetailViewControllerDelegate <NSObject>

- (void)returnCurrentTypeWithType:(NSString *)typeId withNum:(NSInteger)typeNum;

@end

@interface RootDetailViewController : XGBaseViewController

@property (nonatomic, strong) RootInfo * info;

@property (nonatomic, weak) id <RootDetailViewControllerDelegate> delegate;

@end
