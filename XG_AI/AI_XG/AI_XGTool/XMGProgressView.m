//
//  AI_XGProgressView.m
//  AI_XG
//
//  Created by jrweid on 2018/7/16.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XMGProgressView.h"

@implementation XMGProgressView

- (instancetype)initWithView:(UIView *)view
{
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}

+ (void)showHUDAddedTo:(UIView *)view
{
    XMGProgressView * selfView = [[self alloc] initWithView:view];
    selfView.backgroundColor = [UIColor clearColor];
    [view addSubview:selfView];
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [selfView addSubview:activityIndicator];
    activityIndicator.center = view.center;
    activityIndicator.hidesWhenStopped = NO;
    [activityIndicator startAnimating];
}

+ (void)hideHUDForView:(UIView *)view
{
    for (UIView * subView in view.subviews) {
        if ([subView isKindOfClass:[XMGProgressView class]]) {
            XMGProgressView * progress = (XMGProgressView *)subView;
            [progress removeFromSuperview];
            progress = nil;
        }
    }
}

@end
