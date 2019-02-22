//
//  RootView.h
//  AI_XG
//
//  Created by 马红杰 on 2018/5/31.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootInfo;

@protocol RootViewDelegate <NSObject>

- (void)RootViewDidSelectInfo:(RootInfo *)info;

- (void)RootViewDidSelectedScrollAdWithData:(NSDictionary *)json;

@end

@interface RootView : UIView

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSDictionary * scrollJson;

@property (nonatomic, weak) id <RootViewDelegate> delegate;

- (void)reloadRootCollectionWithArray:(NSArray *)dataArray withVC:(UIViewController *)rootVC;

- (void)reloadRootCollectionWithHeaderArray:(NSArray *)headerArray;

@end
