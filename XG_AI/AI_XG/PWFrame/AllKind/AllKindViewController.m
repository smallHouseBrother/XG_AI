//
//  AddKindViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/8/24.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AllKindViewController.h"
#import "AddPWViewController.h"
#import "RootDetailCell.h"
#import "PassWordInfo.h"
#import "AllKindView.h"
#import "FMDB_Tool.h"

@interface AllKindViewController () <AllKindViewDelegate, AddPWViewControllerDelegate, UIViewControllerPreviewingDelegate, GADInterstitialDelegate>
{
    AllKindView * _selfView;
    NSArray     * _dataArray;
}

@property (nonatomic, strong) GADInterstitial * interstitial;

@end

@implementation AllKindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBackItem];
    
    self.title = @"所有";
    
    [self addSubViews];
    
    [self queryData];
}

- (void)addSubViews
{
    AllKindView * selfView = [[AllKindView alloc] init];
    selfView.delegate = self;
    self.view = _selfView = selfView;
    
    self.interstitial = [self createAndLoadInterstitial];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:selfView.tableView];
    }
}

- (void)queryData
{
    _dataArray = [FMDB_Tool queryAllDataFromDataBase];
    
    [(AllKindView *)self.view reloadAllKindTableWithArray:_dataArray withVC:self];
}

- (void)AllKindDidSelectedIndexPath:(NSInteger)index
{
    AddPWViewController * listVC = [[AddPWViewController alloc] init];
    PassWordInfo * info = _dataArray[index];
    listVC.info = info;     listVC.delegate = self;
    [self.navigationController pushViewController:listVC animated:YES];
    
    if (!DEBUG && [self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:listVC];
    }
}

- (void)returnAddedPassWordWithInfo:(PassWordInfo *)info withIsEdit:(BOOL)isEdit
{
    NSArray * aArray = [_dataArray copy];
    [aArray enumerateObjectsUsingBlock:^(PassWordInfo * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.pwId == info.pwId) {
            NSMutableArray * dataArray = [_dataArray mutableCopy];
            [dataArray replaceObjectAtIndex:idx withObject:info];
            _dataArray = [dataArray copy];
            [(AllKindView *)self.view reloadAllKindTableWithArray:_dataArray withVC:self];
            *stop = YES;
        }
    }];
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath = [_selfView.tableView indexPathForRowAtPoint:location];
    RootDetailCell * cell = [_selfView.tableView cellForRowAtIndexPath:indexPath];
    PassWordInfo * info = [_dataArray objectAtIndex:indexPath.row];
    previewingContext.sourceRect = cell.frame;
    
    AddPWViewController * addVC = [[AddPWViewController alloc] init];
    addVC.preferredContentSize = CGSizeZero;
    addVC.info = info; addVC.delegate = self;
    return addVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    
    if (!DEBUG && [self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:viewControllerToCommit];
    }
}

- (GADInterstitial *)createAndLoadInterstitial
{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:chaPageId];
    [self.interstitial loadRequest:[GADRequest request]];
    self.interstitial.delegate = self;
    return self.interstitial;
}

#pragma mark - GADInterstitialDelegate
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    self.interstitial = [self createAndLoadInterstitial];
}

@end
