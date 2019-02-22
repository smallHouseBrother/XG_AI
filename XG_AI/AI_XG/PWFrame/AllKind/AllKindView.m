//
//  AllKindView.m
//  AI_XG
//
//  Created by ydz on 2018/11/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AllKindView.h"
#import "RootDetailCell.h"

@interface AllKindView () <UITableViewDelegate, UITableViewDataSource>
{
    GADBannerView * _bannerView;
    NSArray       * _dataArray;
    UIImageView   * _imageView;
}
@end

@implementation AllKindView

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
    _tableView.backgroundColor = COLOR_HEX(@"#f0eef4");
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 88, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 55;
    [self addSubview:_tableView];
    _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_tableView registerClass:[RootDetailCell class] forCellReuseIdentifier:@"RootDetailCell"];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_Content"]];
    [self addSubview:_imageView = imageView];
    imageView.sd_layout.centerXEqualToView(self).centerYEqualToView(self);
}

- (void)reloadAllKindTableWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
{
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = rootVC;
    _bannerView.adUnitID = textId;
    [self addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    _bannerView.sd_layout.leftEqualToView(self).bottomSpaceToView(self, bottom).rightEqualToView(self).heightIs(50);
    
    _imageView.hidden = (dataArray.count != 0);
    
    _dataArray = [dataArray copy];
    
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RootDetailCell"];
    
    PassWordInfo * info = _dataArray[indexPath.row];
    
    [cell reloadRootDetailCellWithInfo:info];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate AllKindDidSelectedIndexPath:indexPath.row];
}

@end
