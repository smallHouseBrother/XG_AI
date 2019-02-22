//
//  UIAlertView+Delay.m
//  AI_XG
//
//  Created by 小马哥 on 15/12/8.
//  Copyright © 2015年 小马哥. All rights reserved.
//

#import "UIAlertView+Delay.h"
#import "MBProgressHUD+XMG.h"

@implementation UIAlertView (Delay)

/**
 *  弹出提示 并延时消失方法
 *
 *  @param message 提示的内容
 *  @param delay   显示多长时间 单位:s
 */
+ (void)showAlertMessage:(NSString *)message andDelay:(CGFloat)delay
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    [alertView show];
    
    [alertView performSelector:@selector(hideAlert:) withObject:alertView afterDelay:delay];
}

- (void)hideAlert:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

/**
 *  MBProgressHUB风格弹出提示 并延时消失方法
 *
 *  @param message 提示的内容
 *  @param delay   显示多长时间 单位:s
 */
+ (void)MBPShowAlertMessage:(NSString *)message andDelay:(CGFloat)delay
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [MBProgressHUD showInView:window withTitle:message withImageName:nil afterDelay:delay];
}

@end
