//
//  MoreViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/6/13.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "UIViewController+CWLateralSlide.h"
#import "SettingViewController.h"
#import "MoreViewController.h"
#import "FeedBackViewController.h"
#import "XMGWebViewController.h"
#import "RootViewController.h"
#import "DataRequest.h"
#import "MoreCell.h"
#import "MoreView.h"

@interface MoreViewController () <MoreViewDelegate, XMGActionSheetDelegate>
{
    MoreView * _selfView;
    NSArray  * _dataArray;
}
@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubViews];
    
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger backBuild = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appBuild"] integerValue];
    NSInteger currentBuild = [App_Build integerValue];
    MoreInfo * info = [_dataArray lastObject];
    info.rightName = backBuild > currentBuild ? @"NEW" : App_Version;
    [_selfView reloadMoreViewTableWithArray:_dataArray];
}

- (void)addSubViews
{
    MoreView * selfView = [[MoreView alloc] init];
    selfView.delegate = self;
    self.view = _selfView = selfView;

    NSArray * titleArray = @[@"设置", @"意见反馈", @"分享↖(^ω^)↗", @"支持下→_→", @"隐私政策~_~", @"版本"];
    NSArray * imgArray = @[@"more_set", @"more_feed", @"more_share", @"more_point", @"more_declaration", @"more_new"];
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        MoreInfo * info = [[MoreInfo alloc] init];
        info.imageUrl = imgArray[i];
        info.leftName = titleArray[i];
        if (i + 1 == titleArray.count) {
            info.rightName = @"NEW";
        }
        [dataArray addObject:info];
    }
    _dataArray = [dataArray copy];
    
    [selfView reloadMoreViewTableWithArray:_dataArray];
}

- (void)requestData
{
    BOOL hasCopyRight = [[[NSUserDefaults standardUserDefaults] objectForKey:@"copyRight"] boolValue];
    if (!hasCopyRight) return;
    
    NSString * key = [self obtainCurrentDayString];
    NSString * imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveBackGroundImageToAlbum:)];
    [_selfView.tableView addGestureRecognizer:longPress];
    if (imageUrl) {[_selfView.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];return;}
    
    [DataRequest getWithBaseURL:@"https://cn.bing.com/HPImageArchive.aspx?format=js&n=1" withPath:nil withParams:nil withSuccess:^(id jsonData) {
        if ([jsonData isKindOfClass:[NSDictionary class]]) {
            NSArray * images = [[jsonData objectForKey:@"images"] reviewNil];
            if ([images isKindOfClass:[NSArray class]]) {
                NSDictionary * currentDay = [images firstObject];
                if ([currentDay isKindOfClass:[NSDictionary class]] && [currentDay.allKeys containsObject:@"url"]) {
                    NSString * url = [currentDay objectForKey:@"url"];
                    NSString * currentDayImg = [@"https://cn.bing.com/" stringByAppendingPathComponent:url];
                    [[NSUserDefaults standardUserDefaults] setObject:currentDayImg forKey:key];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [_selfView.imageView sd_setImageWithURL:[NSURL URLWithString:currentDayImg]];
                }
            }
        }
    } withFailure:^(NSError *error) {
    }];
}

- (void)saveBackGroundImageToAlbum:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        XMGActionSheet * sheet = [[XMGActionSheet alloc] initWithDelegate:self cancelTitle:@"取消" otherTitles:@[@"分享", @"保存到相簿"]];
        [sheet showInCurrentView];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        RootViewController * rootVC = (RootViewController *)[self cw_getRootViewControllerWithDrewerHiddenDuration:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [rootVC RootShareAction];
        });
    } else if (buttonIndex == 2) {
        UIImageWriteToSavedPhotosAlbum(_selfView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        [UIAlertView showAlertMessage:@"保存失败~_~" andDelay:1.0f];
    }
    else
    {
        [UIAlertView showAlertMessage:@"保存成功(^_-)" andDelay:1.0f];
    }
}

- (void)MoreViewSelectIndexWithInfo:(MoreInfo *)info withIndex:(NSInteger)index
{
    if (index == 0) {
        SettingViewController * settingVC = [[SettingViewController alloc] init];
        XGNavigationController * settingRoot = [[XGNavigationController alloc] initWithRootViewController:settingVC];
        [self cw_presentViewController:settingRoot drewerHiddenDuration:0.3f];
    }
    else if (index == 1)
    {
        FeedBackViewController * feedVC = [[FeedBackViewController alloc] init];
        XGNavigationController * feedNavi = [[XGNavigationController alloc] initWithRootViewController:feedVC];
        [self cw_presentViewController:feedNavi drewerHiddenDuration:0.3];
    }
    else if (index == 2)
    {
        RootViewController * rootVC = (RootViewController *)[self cw_getRootViewControllerWithDrewerHiddenDuration:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [rootVC RootShareAction];
        });
    }
    else if (index == 3)
    {
        NSString * pointUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", AppId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pointUrl]];
    }
    else if (index == 4)
    {
        XMGWebViewController * web = [[XMGWebViewController alloc] initWithTitle:@"用户使用协议" withUrl:@"https://www.jianshu.com/p/8a449fc6e53b"];
        XGNavigationController * navi = [[XGNavigationController alloc] initWithRootViewController:web];
        [self cw_presentViewController:navi drewerHiddenDuration:0.3];
    }
    else if (index == 5)
    {
        NSString * appUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", AppId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
    }
}

@end
