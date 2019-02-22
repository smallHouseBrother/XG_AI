//
//  CameraViewController.h
//  AI_XG
//
//  Created by 小马哥 on 16/5/11.
//  Copyright © 2016年 honglinktech.com. All rights reserved.
//

#import "XGBaseViewController.h"

///方框尺寸
#define CAMERA_SELECT_VIEW_RECT CGRectMake(37, 64 + 60, ScreenWidth - 37 * 2, ScreenWidth - 37 * 2)
///方框图片与边距偏差 比例
#define CAMERA_SELECT_VIEW_OFFSET 0.90

///自定义相机带利用协议
@protocol CameraViewControllerDelegate <NSObject>

@optional
/**
 *  照相返回照片
 *
 *  @param photoImage 照片对象
 */
- (void)cameraSuccessWithPhotoImage:(UIImage *)photoImage;

@end

///自定义相机
@interface CameraViewController : XGBaseViewController

@property (nonatomic, weak) id <CameraViewControllerDelegate> delegate;

@end
