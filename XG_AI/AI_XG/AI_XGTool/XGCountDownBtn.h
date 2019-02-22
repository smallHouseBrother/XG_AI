//
//  XGCountDownBtn.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/20.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGCountDownBtn : UIButton

///初始化  未发送时的title 只有58s格式
- (instancetype)initWithTitle:(NSString *)title;

///初始化  未发送时的title 格式变化,  left 58s right
- (instancetype)initWithTitle:(NSString *)title withLeftContent:(NSString *)left withRightContent:(NSString *)right;

///开始倒计时
- (void)startCountDownWithNumber:(NSInteger)number;

@end
