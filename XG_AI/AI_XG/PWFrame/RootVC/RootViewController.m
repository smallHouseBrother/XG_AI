//
//  RootViewController.m
//  AI_XG
//
//  Created by Zhao Chen on 2018/1/26.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "UIViewController+CWLateralSlide.h"
#import "XMGWebViewController.h"
#import "AllKindViewController.h"
#import "SDCycleScrollView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MoreViewController.h"
#import "RootViewController.h"
#import "CameraViewController.h"
#import "RootView.h"
#import "RootCell.h"
#import "RootInfo.h"

@interface RootViewController () <RootViewDelegate, CameraViewControllerDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSArray * dataArray;

@property (nonatomic, strong) RootView * selfView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubViews];
    
    [self setNavigation];
    
    [self requestData];
}

- (void)setNavigation
{
    self.title = @"密码管理";
    
    UIBarButtonItem * more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:0 target:self action:@selector(showMoreBarButtonItem)];
    self.navigationItem.leftBarButtonItem = more;
    
    __weak typeof(self)weakSelf = self;
    //第一个参数为是否开启边缘手势，开启则默认从边缘50距离内有效，第二个block为手势过程中我们希望做的操作
    [self cw_registerShowIntractiveWithEdgeGesture:YES transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf showMoreBarButtonItem];
        }
    }];
}

- (void)addSubViews
{
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.selfView = [[RootView alloc] init];
    self.selfView.delegate = self;
    self.view = self.selfView;
    
    if (@available(iOS 11.0, *)) {
    } else {
        self.selfView.collectionView.contentInset = UIEdgeInsetsMake(StatusBarHeight+44+self.selfView.collectionView.contentInset.top, 0, self.selfView.collectionView.contentInset.bottom+50, 0);
    }
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:self.selfView.collectionView];
    }
}

- (void)requestData
{
    NSArray * titleArray = @[@"文字扫描识别", @"拍题解析", @"识别萌宠", @"识别植物", @"测测面相", @"识别景点", @"识别商品", @"通用识别", @"语音识别", @"图像技术", @"自然语言处理"];
    NSArray * typeId = @[@"all", @"all", @"login", @"email", @"wallet", @"game", @"chat", @"bank", @"other", @"bank", @"other"];
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (NSInteger i = 0; i < titleArray.count; i++) {
        RootInfo * info = [[RootInfo alloc] init];
        info.titleString = titleArray[i];
        info.typeId = typeId[i];
        info.imageName = [NSString stringWithFormat:@"password%@", typeId[i]];
        if (i == 0) {
            info.accountNum = [FMDB_Tool queryAllDataFromDataBase].count;
        } else {
            info.accountNum = [FMDB_Tool querySingleTypeNumFromDataBaseWithType:info.typeId];
        }
        [dataArray addObject:info];
    }
    self.dataArray = [dataArray copy];
    [self.selfView reloadRootCollectionWithArray:self.dataArray withVC:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.selfView.collectionView.header .height >= floor(250.0*ScreenWidth/750)) return;
    AVObject * object = [AVObject objectWithClassName:@"adversitiment" objectId:@"5b7fcfe8ee920a003b5ab68b"];
    [object fetchInBackgroundWithBlock:^(AVObject * _Nullable object, NSError * _Nullable error) {
        if (error) return;
        NSString * appBuild = [object objectForKey:@"App_Build"];
        BOOL copyRight = [[object objectForKey:@"CopyRight"] boolValue];
        [[NSUserDefaults standardUserDefaults] setValue:appBuild forKey:@"appBuild"];
        [[NSUserDefaults standardUserDefaults] setValue:@(copyRight) forKey:@"copyRight"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.selfView reloadRootCollectionWithHeaderArray:[object objectForKey:@"ad_scrollData"]];
    }];
}

#pragma mark - RootViewDelegate
- (void)RootViewDidSelectInfo:(RootInfo *)info
{
    CameraViewController * camera = [[CameraViewController alloc] init];
    camera.delegate = self;
    [self.navigationController presentViewController:camera animated:YES completion:nil];
}

- (void)RootViewDidSelectedScrollAdWithData:(NSDictionary *)json
{
    NSString * ad_jumpUrl = [json objectForKey:@"ad_jumpUrl"];
    if (![ad_jumpUrl containsString:@"itms-apps"]) {
        XMGWebViewController * webVC = [[XMGWebViewController alloc] initWithTitle:[json objectForKey:@"ad_title"] withUrl:ad_jumpUrl];
        [self.navigationController pushViewController:webVC animated:YES];return;
    }
    
    NSURL * url = [NSURL URLWithString:ad_jumpUrl];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];;
    }
}

#pragma mark - RootDetailViewControllerDelegate
- (void)returnCurrentTypeWithType:(NSString *)typeId withNum:(NSInteger)typeNum
{
    
}

- (void)showMoreBarButtonItem
{
    MoreViewController * more = [[MoreViewController alloc] init];
    [self cw_showDrawerViewController:more animationType:CWDrawerAnimationTypeDefault configuration:[CWLateralSlideConfiguration defaultConfiguration]];
}

#pragma mark - 自定义处理手势冲突接口
- (BOOL)cw_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //如果是自己创建tableview添加在VC的view上 这样写就足够了
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

- (void)RootShareAction
{
    [self BaseShareAction];
}
/*
#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath = [self.selfView.collectionView indexPathForRowAtPoint:location];
    if (indexPath) {
        RootCell * cell = [self.selfView.tableView cellForRowAtIndexPath:indexPath];
        RootInfo * info = [self.dataArray objectAtIndex:indexPath.row];
        previewingContext.sourceRect = cell.frame;
        if ([info.typeId isEqualToString:@"all"]) {
            AllKindViewController * allKind = [[AllKindViewController alloc] init];
            allKind.preferredContentSize = CGSizeZero;
            return allKind;
        }
        
        RootDetailViewController * detailVC = [[RootDetailViewController alloc] init];
        detailVC.preferredContentSize = CGSizeZero;
        detailVC.info = info; detailVC.delegate = self;
        return detailVC;
    }
    NSString * jumpUrl = [self.selfView.scrollJson objectForKey:@"ad_jumpUrl"];
    if (![jumpUrl containsString:@"itms-apps"]) {
        XMGWebViewController * webVC = [[XMGWebViewController alloc] initWithTitle:[self.selfView.scrollJson objectForKey:@"ad_title"] withUrl:jumpUrl];
        return webVC;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}
*/


/*
- (void)translate
{
    [self translate:@"安卓手机很卡" from:@"auto" to:@"en"];
}

- (void)translate:(NSString *)query from:(NSString *)from to:(NSString *)to
{
    ///百度翻译appid 20180403000142661
    ///为保证翻译质量，请将单次请求长度控制在 6000 bytes以内。（汉字约为2000个）
    /*语言简写    名称
     auto    自动检测
     zh    中文
     en    英语
     yue    粤语
     wyw    文言文
     jp    日语
     kor    韩语
     fra    法语
     spa    西班牙语
     th    泰语
     ara    阿拉伯语
     ru    俄语
     pt    葡萄牙语
     de    德语
     it    意大利语
     el    希腊语
     nl    荷兰语
     pl    波兰语
     bul    保加利亚语
     est    爱沙尼亚语
     dan    丹麦语
     fin    芬兰语
     cs    捷克语
     rom    罗马尼亚语
     slo    斯洛文尼亚语
     swe    瑞典语
     hu    匈牙利语
     cht    繁体中文
     vie    越南语*/
    
    uint32_t salt = arc4random();
    
    
    NSString * string = [NSString stringWithFormat:@"%@%@%@%@", appId, query, @(salt), secretKey];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 20)];
    label.textColor = [UIColor greenColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    UILabel * toLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 300, 20)];
    toLabel.textColor = [UIColor greenColor];
    toLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:toLabel];
    
    ///1. 如何在一次请求中翻译多个单词或者多段文本?您可以在发送的字段q中用换行符（在多数编程语言中为转义符号 \n ）来分隔要翻译的多个单词或者多段文本，这样您就能得到多个单词或多段文本独立的翻译结果了。注意在发送请求之前对q字段做URL encode！
    NSString * baseUrl2 = @"https://fanyi-api.baidu.com/api/trans/vip/translate";
    NSDictionary * params = @{@"q":[query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"from":from, @"to":to, @"appid":[NSString stringWithFormat:@"%@", appId], @"salt":[NSString stringWithFormat:@"%@", @(salt)], @"sign":[[NSString md5String:string] lowercaseString]};
    [DataRequest getWithBaseURL:baseUrl2 withPath:nil withParams:params withSuccess:^(id jsonData) {
        NSDictionary * result = [[jsonData objectForKey:@"trans_result"] firstObject];
        NSString * yuan = [result objectForKey:@"src"];
        NSString * yi   = [result objectForKey:@"dst"];
        
        label.text = [NSString stringWithFormat:@"原文：%@", [yuan stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        toLabel.text = [NSString stringWithFormat:@"译文：%@", [yi stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    } withFailure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"文字扫描识别";
    
    UIBarButtonItem * more = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:0 target:self action:@selector(showLeftSetViewController)];
    self.navigationItem.leftBarButtonItem = more;
    //    UIBarButtonItem * camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:0 target:self action:@selector(presentCameraViewController)];
    //    self.navigationItem.rightBarButtonItem = camera;
    
    RootRecordInfo * info = [[RootRecordInfo alloc] init];
    info.recordName = @"未命名文档";
    info.recordTime = @"2018-04-04 11:18";
    [(RootRecordView *)self.view reloadRecordTableWithArray:@[info, info]];
    
    self.view.backgroundColor = COLOR_HEX(@"#E3EDCD");
    
    
    UIBarButtonItem * left = [[UIBarButtonItem alloc] initWithTitle:@"translate" style:0 target:self action:@selector(translate)];
    UIBarButtonItem * google = [[UIBarButtonItem alloc] initWithTitle:@"googleads" style:0 target:self action:@selector(googleAds)];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:@"send" style:0 target:self action:@selector(sendEmail)];
    self.navigationItem.rightBarButtonItems = @[google, left, right];
    
    UIImage * image = [UIImage imageNamed:@"123"];
    /*识别语言类型，默认为CHN_ENG。可选值包括：
     - CHN_ENG：中英文混合；
     - ENG：英文；
     - POR：葡萄牙语；
     - FRE：法语；
     - GER：德语；
     - ITA：意大利语；
     - SPA：西班牙语；
     - RUS：俄语；
     - JAP：日语*/
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextBasicFromImage:image withOptions:options successHandler:^(id result) {
        NSLog(@"%@______", result);
    } failHandler:^(NSError *err) {
        NSLog(@"_____%@______", err);
    }];
}



*/
@end
