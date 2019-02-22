//
//  CategoryListViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/6/22.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "RootDetailViewController.h"
#import "RootDetailView.h"
#import "AddPWViewController.h"
#import "PassWordInfo.h"
#import "RootDetailCell.h"
#import "RootInfo.h"

@interface RootDetailViewController () <RootDetailViewDelegate, AddPWViewControllerDelegate, UIViewControllerPreviewingDelegate, GADInterstitialDelegate>
{
    RootDetailView * _selfView;
    NSArray * _dataArray;
    NSInteger _typeNumber;
}

@property (nonatomic, strong) GADInterstitial * interstitial;

@end

@implementation RootDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    
    [self addSubViews];
    
    [self queryData];
}

- (void)setNavigation
{
    [self setBackItem];
    
    self.title = self.info.titleString;
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPassWordRecord)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)addSubViews
{
    _selfView = [[RootDetailView alloc] init];
    _selfView.delegate = self;
    self.view = _selfView;
    
    self.interstitial = [self createAndLoadInterstitial];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
    {
        [self registerForPreviewingWithDelegate:self sourceView:_selfView.tableView];
    }
}

- (void)queryData
{
    _dataArray = [FMDB_Tool querySingleTypeAllDataFromDataBaseWithType:self.info.typeId];
    _typeNumber = _dataArray.count;
    [(RootDetailView *)self.view reloadRootDetailTableWithArray:_dataArray withVC:self];
}

- (void)addPassWordRecord
{
    AddPWViewController * addPW = [[AddPWViewController alloc] init];
    addPW.typeId = self.info.typeId;
    addPW.delegate = self;
    XGNavigationController * addPwNavi = [[XGNavigationController alloc] initWithRootViewController:addPW];
    [self.navigationController presentViewController:addPwNavi animated:YES completion:nil];
    
    if (!DEBUG && [self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:addPW];
    }
}

#pragma mark - CategoryListViewDelegate
- (void)checkTheSelectedDetailWithInfo:(PassWordInfo *)info
{
    AddPWViewController * addPW = [[AddPWViewController alloc] init];
    addPW.info = info;  addPW.delegate = self;
    NSUInteger index = [_dataArray indexOfObject:info];
    addPW.block = ^{
        [self deleteSelectedPassWordWithIndex:index];
    };
    [self.navigationController pushViewController:addPW animated:YES];
    
    if (!DEBUG && [self.interstitial isReady]) {
        [self.interstitial presentFromRootViewController:addPW];
    }
}

- (void)deleteSelectedPassWordWithIndex:(NSInteger)index
{
    NSMutableArray * dataArray = [_dataArray mutableCopy];
    [FMDB_Tool deleteSingleDataWithPassWordInfo:[dataArray objectAtIndex:index]];
    [dataArray removeObjectAtIndex:index];
    _dataArray = [dataArray copy];
    _typeNumber = _dataArray.count;
    [(RootDetailView *)self.view reloadRootDetailTableWithArray:_dataArray withVC:self];
}

- (void)returnAddedPassWordWithInfo:(PassWordInfo *)info withIsEdit:(BOOL)isEdit
{
    NSMutableArray * dataArray = [_dataArray mutableCopy];
    if (!isEdit)
    {
        [dataArray addObject:info];
        _typeNumber = dataArray.count;
        _dataArray = [dataArray copy];
        [(RootDetailView *)self.view reloadRootDetailTableWithArray:_dataArray withVC:self];
        return;
    }
    
    for (PassWordInfo * pwInfo in _dataArray) {
        if (info.pwId == pwInfo.pwId) {
            NSUInteger index = [_dataArray indexOfObject:pwInfo];
            [dataArray replaceObjectAtIndex:index withObject:info];
            break;
        }
    }
    _dataArray = [dataArray copy];
    [(RootDetailView *)self.view reloadRootDetailTableWithArray:_dataArray withVC:self];
}

- (void)backAction
{
    [self.delegate returnCurrentTypeWithType:self.info.typeId withNum:_typeNumber];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath * indexPath = [_selfView.tableView indexPathForRowAtPoint:location];
    RootDetailCell * cell = [_selfView.tableView cellForRowAtIndexPath:indexPath];
    PassWordInfo * info = [_dataArray objectAtIndex:indexPath.row];
    previewingContext.sourceRect = cell.frame;
    
    AddPWViewController * addVC = [[AddPWViewController alloc] init];
    addVC.preferredContentSize = CGSizeZero; addVC.info = info;
    addVC.delegate = self;
    addVC.block = ^{
        [self deleteSelectedPassWordWithIndex:indexPath.row];
    };
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
