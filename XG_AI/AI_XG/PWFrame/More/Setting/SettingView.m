//
//  SettingView.m
//  AI_XG
//
//  Created by 马红杰 on 2018/7/14.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "SettingView.h"
#import "SettingCell.h"

@interface SettingView () <UITableViewDelegate, UITableViewDataSource, SettingCellDelegate>
{
    GADBannerView * _bannerView;
    UITableView   * _tableView;
    NSArray       * _dataArray;
}
@end

@implementation SettingView

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
    
    [_tableView registerClass:[SettingCell class] forCellReuseIdentifier:@"SettingCell"];
}

- (void)reloadSettingViewTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
{
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = rootVC;
    _bannerView.adUnitID = textId;
    [self addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    _bannerView.sd_layout.leftEqualToView(self).bottomSpaceToView(self, bottom).rightEqualToView(self).heightIs(50);

    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray * rowArray = _dataArray[section];
    
    SettingInfo * info = [rowArray firstObject];
    
    return info.sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * rowArray = _dataArray[section];
    
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    
    SettingInfo * info = _dataArray[indexPath.section][indexPath.row];
    
    [cell reloadSettingCellWithInfo:info];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate SettingViewDidSelectedIndexPath:indexPath];
}

- (void)SettingCellSwitchStatus:(SettingCell *)cell withSwitch:(UISwitch *)aSwitch
{
    NSIndexPath * indexPath = [_tableView indexPathForCell:cell];
    
    [self.delegate SettingViewDidSwitchIndexPath:indexPath withSwitch:aSwitch];
}

@end

