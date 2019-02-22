//
//  photoMsgViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/8/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "photoMsgViewController.h"
#import "ScaleImageView.h"

@interface photoMsgViewController () <XMGActionSheetDelegate>

@end

@implementation photoMsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
}

- (void)setNavigation
{
    [self setBackItem];
    
    self.title = @"图片信息";
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:0 target:self action:@selector(deleteCurrentImage)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)addSubViews
{
    ScaleImageView * scale = [[ScaleImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scale];
    [scale setImageViewFrameWithImage:self.image];
    if (@available(iOS 11.0, *)) {
        scale.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)deleteCurrentImage
{
    XMGActionSheet * sheet = [[XMGActionSheet alloc] initWithDelegate:self cancelTitle:@"取消" otherTitles:@[@"删除"]];
    [sheet showInCurrentView];
}

- (void)actionSheet:(XMGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) return;
    [UIAlertView showAlertMessage:@"删除成功~_~" andDelay:1.0f];
    [self.delegate photoMsgViewControllerDidDeleteCurrentPasswordPhoto];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
