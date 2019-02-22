//
//  IAPPurchaseInfo.h
//  AI_XG
//
//  Created by ydz on 2019/2/14.
//  Copyright © 2019年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 block
 
 @param isSuccess 是否支付成功
 @param certificate 支付成功得到的凭证（用于在自己服务器验证）
 @param errorMsg 错误信息
 */
typedef void(^PayResult)(BOOL isSuccess, NSString * certificate, NSString * errorMsg);


@interface IAPPurchaseInfo : NSObject

@property (nonatomic, copy) PayResult payResultBlock;

/**
 单例方法
 */
+ (instancetype)manager;

/**
 开启内购监听 在程序入口didFinishLaunchingWithOptions实现
 */
- (void)startManager;

/**
 停止内购监听 在AppDelegate.m中的applicationWillTerminate方法实现
 */
- (void)stopManager;

/**
 拉起内购支付
 @param productID 内购商品ID
 @param payResult 结果
 */
- (void)buyProductWithProductID:(NSString *)productID payResult:(PayResult)payResult;

@end

NS_ASSUME_NONNULL_END
