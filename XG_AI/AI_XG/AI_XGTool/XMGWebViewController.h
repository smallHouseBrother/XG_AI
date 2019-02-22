//
//  XGRefundProtocolViewController.h
//  XYGJ
//
//  Created by Zhao Chen on 2017/10/19.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "XGBaseViewController.h"

@interface XMGWebViewController : XGBaseViewController

/**
 *  初始化方法
 *
 *  @param urlString url字符串 nil 默认用户授权协议
 *  @param title     页面标题
 *
 *  @return 视图控制器对象
 */
- (instancetype)initWithTitle:(NSString *)title withUrl:(NSString *)urlString;

@end
