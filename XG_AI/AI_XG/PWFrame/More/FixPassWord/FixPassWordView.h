//
//  FixPassWordView.h
//  AI_XG
//
//  Created by ydz on 2019/1/30.
//  Copyright © 2019年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FixPassWordViewDelegate <NSObject>

- (void)FixPassWordViewFixPassWordAction;

@end

@interface FixPassWordView : UIView

@property (nonatomic, weak) id <FixPassWordViewDelegate> delegate;

- (void)reloadFixPassWordViewTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

@end
