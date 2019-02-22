//
//  AI_XGLocationManager.h.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/19.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XMGLocationManager.h"
/*
static XMGLocationManager * selfLocationManager;

@interface XMGLocationManager () <AMapLocationManagerDelegate>
{
    AMapLocationManager * _locationManager;
}
@end*/

@implementation XMGLocationManager
/*
+ (instancetype)shareLocationManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        selfLocationManager = [[[self class] alloc] init];
    });
    return selfLocationManager;
}

**
 *  开启定位
 *
 *  @return 开启定位是否成功
 *
- (BOOL)startLocation
{
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    
    ///创建定位管理对象
    if ([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 200;
        _locationManager.locatingWithReGeocode = YES;
    }
    
    ///请求授权
    [[[CLLocationManager alloc] init] requestWhenInUseAuthorization];
    
    ///开启位置更新
    [_locationManager startUpdatingLocation];
    return YES;
}

**
 *  关闭定位服务
 *
- (void)stopLocation {
    [_locationManager stopUpdatingLocation];   ///关闭位置更新
    _locationManager = nil;
}


#pragma mark Location Delegate
**
 *  定位回调
 *
 *  @param manager         定位管理对象
 *  @param location        新的位置
 *  param  reGeocode       地址信息
 *
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    self.myLocation = location;
    self.myAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@", reGeocode.province, reGeocode.city, reGeocode.district, reGeocode.street, reGeocode.number, reGeocode.POIName];
}

**
 *  用户是否开启定位权限
 *
 *  @return 用户是否开启了定位
 *
- (BOOL)isCanLocation {
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

/**
 *  显示打开定位服务提示框
 */
- (void)showOpenLocationAlert {
    NSDictionary * infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString * mention = [NSString stringWithFormat:@"请打开系统设置中“隐私-定位服务”，允许“%@”使用你的位置。", [infoDic objectForKey:@"CFBundleDisplayName"]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法获取当前位置" message:mention delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    alertView.tag = 1;
    [alertView show];
}

#pragma mark- Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
