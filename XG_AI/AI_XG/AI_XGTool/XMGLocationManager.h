//
//  AI_XGLocationManager.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/19.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>
/*#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>*/

@interface XMGLocationManager : NSObject

//@property (nonatomic) CLLocation * myLocation;     ///定位经纬度
@property (nonatomic, copy) NSString * myAddress;     ///定位位置

/**
 *  获取定位单例对象
 *
 *  @return 定位单例对象
 */
+ (XMGLocationManager *)shareLocationManager;

/**
 *  开启定位
 *
 *  @return 开启定位是否成功
 */
- (BOOL)startLocation;

/**
 *  关闭定位服务
 */
- (void)stopLocation;

/**
 *  用户是否开启定位权限
 *
 *  @return 是否开启定位
 */
- (BOOL)isCanLocation;

/**
 *  显示打开定位服务提示框
 */
- (void)showOpenLocationAlert;

@end
