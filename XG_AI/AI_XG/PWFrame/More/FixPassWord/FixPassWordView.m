//
//  FixPassWordView.m
//  AI_XG
//
//  Created by ydz on 2019/1/30.
//  Copyright © 2019年 小马哥. All rights reserved.
//

#import "FixPassWordView.h"
#import "FixPassWordCell.h"

@interface FixPassWordView () <UITableViewDelegate, UITableViewDataSource>
{
    GADBannerView * _bannerView;
    UITableView   * _tableView;
    NSArray       * _dataArray;
}
@end

@implementation FixPassWordView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = COLOR_HEX(@"#f5f5f5");
    _tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44;
    [self addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_tableView registerClass:[FixPassWordCell class] forCellReuseIdentifier:@"FixPassWordCell"];
}

- (void)reloadFixPassWordViewTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
{
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = rootVC;
    _bannerView.adUnitID = textId;
    [self addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    _bannerView.sd_layout.leftEqualToView(self).bottomSpaceToView(self, bottom).rightEqualToView(self).heightIs(50);
    
    _tableView.tableFooterView = [self getTableFooter];
    
    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (UIView *)getTableFooter
{
    UIView * footer = [[UITableViewCell alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    footer.height = 60;
    
    UIButton * fixBtn = [[UIButton alloc] init];
    fixBtn.backgroundColor = Main_Color;
    [fixBtn setTitle:@"修改" forState:UIControlStateNormal];
    [fixBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    fixBtn.layer.cornerRadius = 5.0f;
    fixBtn.layer.masksToBounds = YES;
    [fixBtn addTarget:self action:@selector(fixPassWord) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:fixBtn];
    fixBtn.sd_layout.leftSpaceToView(footer, 15).topSpaceToView(footer, 15).rightSpaceToView(footer, 15).heightIs(44);
    
    return footer;
}

- (void)fixPassWord
{
    [self endEditing:YES];
    FixPassWordInfo * nowPW = [[_dataArray firstObject] firstObject];
    FixPassWordInfo * newPW = [[_dataArray lastObject] firstObject];
    FixPassWordInfo * surePW = [[_dataArray lastObject] lastObject];
    if (![lockPW isEqualToString:nowPW.inputString]) {
        [UIAlertView showAlertMessage:@"密码错误~_~" andDelay:1.0f];return;
    }
    if (newPW.inputString.length != 4) {
        [UIAlertView showAlertMessage:@"四位密码~_~" andDelay:1.0f];return;
    }
    if ([lockPW isEqualToString:newPW.inputString]) {
        [UIAlertView showAlertMessage:@"新密码和旧密码相同哦~_~" andDelay:1.0f];return;
    }
    if (![newPW.inputString isEqualToString:surePW.inputString]) {
        [UIAlertView showAlertMessage:@"密码不一致~_~" andDelay:1.0f];return;
    }
    [[NSUserDefaults standardUserDefaults] setValue:newPW.inputString forKey:@"lockPW"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate FixPassWordViewFixPassWordAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    
    header.backgroundColor = COLOR_HEX(@"#f5f5f5");
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * single = _dataArray[section];
    
    return single.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FixPassWordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FixPassWordCell"];
    
    FixPassWordInfo * info = _dataArray[indexPath.section][indexPath.row];
    
    [cell reloadFixPassWordCellWithInfo:info];

    return cell;
}

@end
