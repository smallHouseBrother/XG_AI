//
//  CameraViewController.m
//  AI_XG
//
//  Created by 小马哥 on 16/5/11.
//  Copyright © 2016年 honglinktech.com. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

#define GOODS_TYPE_BUTTON_TAG 2000

@interface CameraViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    ///背景view
    UIView * _backView;
    
    ///照片输出源
    AVCaptureStillImageOutput * _output;
    
    ///视频内容输入输出链接管理
    AVCaptureSession * _captureSession;
    
    ///相机内容展示layer
    AVCaptureVideoPreviewLayer * _videoPreviewLayer;
    
    ///焦距
    CGFloat _focalDistance;
}

@end

@implementation CameraViewController

/**
 *  初始化方法
 *
 *  @param isShowGoodsTypeView 是否选择货品选择视图
 *
 *  @return 初始化后对象
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        _focalDistance = 1.0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_captureSession startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_captureSession stopRunning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createView];
}

/**
 *  返回按钮事件
 */
- (void)backBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  构建其他View
 */
- (void)createOtherView {
    
    ///四角边框
    UIImageView *borderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Camera_Rect"]];
    borderView.frame = CAMERA_SELECT_VIEW_RECT;
    [_backView addSubview:borderView];
    
    ///方框图片与边距偏差
    CGFloat offset = (1 - CAMERA_SELECT_VIEW_OFFSET) / 2 * CAMERA_SELECT_VIEW_RECT.size.width;
    ///黑色背景颜色
    UIColor *blackBackColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ///黑色背景
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, _backView.width, CAMERA_SELECT_VIEW_RECT.origin.y - 64 + offset)];
    blackView.backgroundColor = blackBackColor;
    blackView.userInteractionEnabled = NO;
    [_backView addSubview:blackView];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, blackView.bottom, CAMERA_SELECT_VIEW_RECT.origin.x + offset, CAMERA_SELECT_VIEW_RECT.size.height - 2 * offset)];
    blackView.backgroundColor = blackBackColor;
    blackView.userInteractionEnabled = NO;
    [_backView addSubview:blackView];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(borderView.right - offset, blackView.top, CAMERA_SELECT_VIEW_RECT.origin.x + offset, CAMERA_SELECT_VIEW_RECT.size.height - 2 * offset)];
    blackView.backgroundColor = blackBackColor;
    blackView.userInteractionEnabled = NO;
    [_backView addSubview:blackView];
    
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, borderView.bottom - offset, _backView.width, ScreenHeight - 124 - borderView.bottom + offset)];
    blackView.backgroundColor = blackBackColor;
    blackView.userInteractionEnabled = NO;
    [_backView addSubview:blackView];
    
    ///底部视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 124, self.view.width, 124)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [_backView addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, bottomView.width, 15)];
    label.text = @"拍立选";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexadecimalString:@"#e3ca63"];
    [bottomView addSubview:label];
    
    UIButton *takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePictureButton.frame = CGRectMake((bottomView.width - 66) / 2, label.bottom + (bottomView.height - label.bottom - 66) / 2, 66, 66);
    [takePictureButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [takePictureButton setImage:[UIImage imageNamed:@"Camera_Take_Picture_Select"] forState:UIControlStateHighlighted];
    [takePictureButton addTarget:self action:@selector(takePictureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:takePictureButton];
}

/**
 *  构建相关视图
 */
- (void)createView {
    
    ///背景view
    _backView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    [self.view sendSubviewToBack:_backView];
    
    ///设置输入源
    NSError * error;
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [captureDevice lockForConfiguration:nil];
    //设置闪光灯为自动
    [captureDevice setFlashMode:AVCaptureFlashModeAuto];
    [captureDevice unlockForConfiguration];
    
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error)
    {
        NSString * string = [@"请打开相机权限：手机设置-隐私-相机-" stringByAppendingFormat:@"%@（打开）", App_Name];
        [UIAlertController showAlertMessage:string andDelay:1.0f withPresentVC:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canAddInput:input])
    {
        [_captureSession addInput:input];
    }
    
    ///设置输出源
    _output = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    [_output setOutputSettings:outputSettings];

    if ([_captureSession canAddOutput:_output]) {
        [_captureSession addOutput:_output];
    }
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [_videoPreviewLayer setFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _backView.layer.masksToBounds = YES;
    [_backView.layer addSublayer:_videoPreviewLayer];
    
    ///改变焦距缩放手势
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(changeFocalDistance:)];
    [_backView addGestureRecognizer:pinch];
    
    ///对焦手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusingWithTap:)];
    [_backView addGestureRecognizer:tap];
    
    [self createOtherView];
}

/**
 *  照相按钮
 */
- (void)takePictureButtonClick {
    AVCaptureConnection *videoConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }
    
    [_output captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([self.delegate respondsToSelector:@selector(cameraSuccessWithPhotoImage:andCloudMallType:)]) {
//            [self.delegate cameraSuccessWithPhotoImage:image andCloudMallType:_goodsTypeArr[_selectGoodsTypeIndex].typeName];
        }
        
        if ([self.delegate respondsToSelector:@selector(cameraSuccessWithPhotoImage:)]) {
            [self.delegate cameraSuccessWithPhotoImage:image];
        }
    }];
}

#pragma mark- 变焦/对焦事件
/**
 *  改变焦距事件
 *
 *  @param pinch 缩放手势对象
 */
- (void)changeFocalDistance:(UIPinchGestureRecognizer *)pinch {
    
    _focalDistance = _focalDistance * [pinch scale];
    
    if (_focalDistance < 1.0) {
        _focalDistance = 1.0;
    }
    
    if (_focalDistance > 5.0) {
        _focalDistance = 5.0;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    [_videoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(_focalDistance, _focalDistance)];
    [CATransaction commit];
    
    AVCaptureConnection *videoConnection = [_output connectionWithMediaType:AVMediaTypeVideo];
    [videoConnection setVideoScaleAndCropFactor:_focalDistance];
    
    [pinch setScale:1.0];
}

/**
 *  对焦事件
 */
- (void)focusingWithTap:(UITapGestureRecognizer *)tap {
    
    CGPoint tapPoint = [tap locationInView:_backView];
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [captureDevice lockForConfiguration:nil];
    //设置焦点
    [captureDevice setFocusPointOfInterest:CGPointMake(tapPoint.y / _backView.height, 1.0 - tapPoint.x / _backView.width)];
    [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    
    [captureDevice unlockForConfiguration];
}

@end
