//
//  XGBaseViewController.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface XGBaseViewController : UIViewController

- (void)setBackItem;

- (void)backAction;

- (void)setDismissWithLeft:(BOOL)isLeft withTitle:(NSString *)titleName;

#pragma mark - 开始验证按钮点击事件
- (void)vertifyWithSuccessBlock:(void (^)(BOOL isSuccess))successBlock withAuthFailureBlock:(void (^)(LAContext * ctx, NSInteger code))failureBlock;

- (NSString *)obtainCurrentDayString;

- (NSString *)weekdayStringFromDate:(NSDate *)inputDate;

- (void)BaseShareAction;

@end
