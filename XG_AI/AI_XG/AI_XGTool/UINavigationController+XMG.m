//
//  UINavigationController+XMG.m
//  AI_XG
//
//  Created by 小马哥 on 2017/11/13.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "UINavigationController+XMG.h"

@implementation UINavigationController (XMG)

- (void)setNavigationBackground:(CGFloat)alpha
{
    // 导航栏背景透明度设置
    UIView * barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView * backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent)
    {
        if (backgroundImageView != nil && backgroundImageView.image != nil)
        {
            barBackgroundView.alpha = alpha;
        }
        else
        {
            UIView * backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil)
            {
                backgroundEffectView.alpha = alpha;
            }
        }
    }
    else
    {
        barBackgroundView.alpha = alpha;
    }
}

- (CGFloat)getNavigationBackgroundAlpha
{
    UIView * barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];
    UIImageView * backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];
    if (self.navigationBar.isTranslucent)
    {
        if (backgroundImageView != nil && backgroundImageView.image != nil)
        {
            return barBackgroundView.alpha;
        }
        else
        {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];
            if (backgroundEffectView != nil)
            {
                return backgroundEffectView.alpha;
            }
        }
    }
    return barBackgroundView.alpha;
}

@end
