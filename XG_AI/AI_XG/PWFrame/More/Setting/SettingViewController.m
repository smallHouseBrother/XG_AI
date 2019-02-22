//
//  SettingViewController.m
//  AI_XG
//
//  Created by 马红杰 on 2018/7/14.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "SettingCell.h"
#import "FixPassWordController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AuthViewController.h"
#import <StoreKit/StoreKit.h>

@interface SettingViewController () <SettingViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSArray * _dataArray;
}
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
    
    [self requestData];
}

- (void)setNavigation
{
    self.title = @"设置";
    
    [self setDismissWithLeft:NO withTitle:@"关闭"];
}

- (void)addSubViews
{
    SettingView * selfView = [[SettingView alloc] init];
    selfView.delegate = self;
    self.view = selfView;
}

- (void)requestData
{
    NSArray * sectionArray = @[@[@"安全"], @[@"备份 & 还原"]];
    NSArray * titleArray = @[@[@"Touch ID", @"登陆密码验证", @"修改密码"], @[@"由iTunes", @"由Wifi", @"由iTunes", @"由iCloud"]];
    if (iPhoneX) {titleArray = @[@[@"Face ID", @"登陆密码验证", @"修改密码"], @[@"由iTunes", @"由Wifi", @"由iTunes", @"由iCloud"]];}
    NSArray * statusArray = @[@[@([[[NSUserDefaults standardUserDefaults] objectForKey:@"idLock"] boolValue]), @([[[NSUserDefaults standardUserDefaults] objectForKey:@"pwLock"] boolValue]), @(NO)], @[@(NO), @(NO), @(NO), @(NO)]];
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        NSArray * inTitleArray = [titleArray objectAtIndex:i];
        NSMutableArray * inArray = [NSMutableArray arrayWithCapacity:inTitleArray.count];
        for (NSInteger j = 0; j < inTitleArray.count; j++) {
            SettingInfo * info = [[SettingInfo alloc] init];
            info.sectionName = sectionArray[i][0];
            info.leftName = titleArray[i][j];
            info.isSwitch = (i == 0 && (j == 0 || j == 1));
            info.isOn = [statusArray[i][j] boolValue];
            [inArray addObject:info];
        }
        [dataArray addObject:inArray];
    }
    _dataArray = [dataArray copy];
    [(SettingView *)self.view reloadSettingViewTableWithArray:_dataArray withVC:self];
}

- (void)SettingViewDidSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"pwLock"] boolValue])
    {
        NSString * lockPassW = lockPW;
        if (lockPassW.length == 0) return;
        UIViewController * rootNavi = [self.navigationController presentingViewController];
        [self dismissViewControllerAnimated:YES completion:^{
            FixPassWordController * fixPW = [[FixPassWordController alloc] init];
            XGNavigationController * fixNavi = [[XGNavigationController alloc] initWithRootViewController:fixPW];
            [rootNavi presentViewController:fixNavi animated:YES completion:nil];
        }];
    } else if (indexPath.section == 1) {
        ///数据迁移
#warning here 密码 多次失败 一天后再试、
    }
}

///authNum0、解锁；1、Touch ID验证 2、密码验证
- (void)SettingViewDidSwitchIndexPath:(NSIndexPath *)indexPath withSwitch:(UISwitch *)aSwitch
{
    AuthViewController * auth = [[AuthViewController alloc] init];
    auth.authNum = indexPath.row + 1;
    auth.block = ^(BOOL authSuccess, NSInteger authNum) {
        SettingInfo * first = [[_dataArray firstObject] firstObject];
        SettingInfo * second = [_dataArray firstObject][1];
        if (authNum == 1) {
            first.isOn = authSuccess ? aSwitch.isOn : !aSwitch.isOn;
            [[NSUserDefaults standardUserDefaults] setObject:@(first.isOn) forKey:@"idLock"];
        } else if (authNum == 2) {
            second.isOn = authSuccess ? aSwitch.isOn : !aSwitch.isOn;
            [[NSUserDefaults standardUserDefaults] setObject:@(second.isOn) forKey:@"pwLock"];
            if (!second.isOn) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lockPW"];
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [(SettingView *)self.view reloadSettingViewTableWithArray:_dataArray withVC:self];
    };
    [self.navigationController presentViewController:auth animated:YES completion:nil];
}

@end
