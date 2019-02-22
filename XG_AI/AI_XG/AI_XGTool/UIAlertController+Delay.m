//
//  UIAlertController+Delay.m
//  AI_XG
//
//  Created by 小马哥 on 2017/5/26.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "UIAlertController+Delay.h"

@implementation UIAlertController (Delay)

/**
 *  弹出提示 并延时消失方法
 *
 *  @param message 提示的内容
 *  @param delay   显示多长时间 单位:s
 */
+ (void)showAlertMessage:(NSString *)message andDelay:(CGFloat)delay withPresentVC:(UIViewController *)viewController
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:1];
    [viewController presentViewController:alert animated:NO completion:nil];
    [alert performSelector:@selector(hideAlertViewController:) withObject:alert afterDelay:delay];
}

- (void)hideAlertViewController:(UIAlertController *)alertController
{
    [alertController dismissViewControllerAnimated:NO completion:nil];
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
