//
//  RootView.m
//  AI_XG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "RootView.h"
#import "RootCell.h"
#import "RootInfo.h"
#import "SDCycleScrollView.h"

@interface RootView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>
{
    GADBannerView * _bannerView;
    NSArray       * _headerArray;
    NSArray       * _dataArray;
    NSArray       * _bannerArr;
}
@end

@implementation RootView

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
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    double width = ([UIScreen mainScreen].bounds.size.width - 50.0) / 4.0;
    layout.itemSize = CGSizeMake(floor(width), floor(width));
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView.backgroundColor = COLOR_HEX(@"#f0eef4");
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    _collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    [_collectionView registerClass:[RootCell class] forCellWithReuseIdentifier:@"RootCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)reloadRootCollectionWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC
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
    
    [_collectionView reloadData];
}

- (void)reloadRootCollectionWithHeaderArray:(NSArray *)headerArray
{
    _headerArray = [headerArray copy];
    
    [_collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_headerArray.count <= 0) return CGSizeZero;
    
    return CGSizeMake(ScreenWidth, 250*ScreenWidth/750);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (_headerArray.count == 0 || !_headerArray) return nil;
        NSMutableArray * imgArray = [NSMutableArray array];
        NSMutableArray * urlArray = [NSMutableArray array];
        NSMutableArray * titleArray = [NSMutableArray array];
        for (NSDictionary * json in _headerArray) {
            [imgArray addObject:json[@"ad_imageUrl"]];
            [urlArray addObject:json[@"ad_jumpUrl"]];
            [titleArray addObject:json[@"ad_title"]];
        }
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        SDCycleScrollView * cycleScroll = [header viewWithTag:10086];
        if (!cycleScroll) {
            cycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 250*ScreenWidth/750) delegate:self placeholderImage:nil];
            cycleScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScroll.showPageControl = YES;
            cycleScroll.tag = 10086;
            [header addSubview:cycleScroll];
        }
        cycleScroll.imageURLStringsGroup = imgArray;
        cycleScroll.titlesGroup = titleArray;
        cycleScroll.itemDidScrollOperationBlock = ^(NSInteger currentIndex)
        {
            self.scrollJson = [_headerArray objectAtIndex:currentIndex];
        };
        return header;
    }
    return nil;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >= _bannerArr.count) return;
    NSDictionary * json = [_bannerArr objectAtIndex:index];
    [self.delegate RootViewDidSelectedScrollAdWithData:json];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RootCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCell" forIndexPath:indexPath];
    
    RootInfo * info = _dataArray[indexPath.row];
    
    [cell reloadRootCellWithInfo:info];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    RootInfo * info = _dataArray[indexPath.row];
    
    [self.delegate RootViewDidSelectInfo:info];
}

@end
