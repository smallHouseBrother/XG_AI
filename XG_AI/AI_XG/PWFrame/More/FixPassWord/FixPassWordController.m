//
//  FixPassWordController.m
//  AI_XG
//
//  Created by ydz on 2018/11/9.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "FixPassWordController.h"
#import "FixPassWordView.h"
#import "FixPassWordCell.h"

@interface FixPassWordController () <FixPassWordViewDelegate>

@end

@implementation FixPassWordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
}

- (void)setNavigation
{
    self.title = @"修改密码";
    
    [self setDismissWithLeft:NO withTitle:@"取消"];
}

- (void)addSubViews
{
    FixPassWordView * selfView = [[FixPassWordView alloc] init];
    selfView.delegate = self;
    self.view = selfView;
    
    FixPassWordInfo * info = [[FixPassWordInfo alloc] init];
    info.titleString = @"当前密码:";
    info.placeString = @"必填~_~";
    
    FixPassWordInfo * info1 = [[FixPassWordInfo alloc] init];
    info1.titleString = @"新密码:";
    info1.placeString = @"四位(必填~_~)";
    FixPassWordInfo * info2 = [[FixPassWordInfo alloc] init];
    info2.titleString = @"确认新密码:";
    info2.placeString = @"同新密码(必填~_~)";
    
    [selfView reloadFixPassWordViewTableWithArray:@[@[info], @[info1, info2]] withVC:self];
}

- (void)FixPassWordViewFixPassWordAction
{
    [UIAlertController showAlertMessage:@"修改成功(^_-)" andDelay:1.0f withPresentVC:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
