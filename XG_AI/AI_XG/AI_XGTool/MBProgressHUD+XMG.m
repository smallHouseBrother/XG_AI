//
//  MBProgressHUD+XMG.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/25.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "MBProgressHUD+XMG.h"

@implementation MBProgressHUD (XMG)

+ (void)showInView:(UIView *)view withTitle:(NSString *)title afterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD showInView:view withTitle:title withImageName:nil afterDelay:delay];
}

+ (void)showInView:(UIView *)view withTitle:(NSString *)title withImageName:(NSString *)imageName afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.label.text = title;
    
    [HUD showAnimated:YES];
    
    [HUD hideAnimated:YES afterDelay:delay];
    
    [view addSubview:HUD];
}

@end
