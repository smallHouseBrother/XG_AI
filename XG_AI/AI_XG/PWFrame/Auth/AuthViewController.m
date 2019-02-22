//
//  AuthViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/6/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AuthViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

#define Input_Tag 10086

@interface AuthViewController ()
{
    UIView  * _fingerBack;
    UIView  * _pwBack;
    UILabel * _clickFinger;
    UITextField * _backInput;
    BOOL     _isPW;
    NSString * _firstPw;
}
@end

@implementation AuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSubViews];
}

- (void)addSubViews
{
    NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray * iconsName = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [iconsName lastObject]]];
    UIImageView * iconImage = [[UIImageView alloc] initWithImage:image];
    iconImage.layer.cornerRadius = 5.0f;
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor redColor];
    [self.view addSubview:iconImage];
    iconImage.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, 100).widthIs(88).heightIs(88);
    
    _fingerBack = [[UIView alloc] init];
    [self.view addSubview:_fingerBack];
    _fingerBack.sd_layout.leftEqualToView(self.view).centerYEqualToView(self.view).widthIs(ScreenWidth).heightIs(66);
    
    UIButton * finger = [[UIButton alloc] init];
    [finger setImage:[UIImage imageNamed:@"finger"] forState:UIControlStateNormal];
    if (iPhoneX) {
        [finger setImage:[UIImage imageNamed:@"faceId"] forState:UIControlStateNormal];
    }
    [finger addTarget:self action:@selector(requestFingerAuth) forControlEvents:UIControlEventTouchUpInside];
    [_fingerBack addSubview:finger];
    finger.sd_layout.centerXEqualToView(_fingerBack).topSpaceToView(_fingerBack, 0).widthIs(66).heightIs(66);
    
    _pwBack = [[UIView alloc] init];
    [self.view addSubview:_pwBack];
    _pwBack.sd_layout.leftSpaceToView(self.view, ScreenWidth).centerYEqualToView(_fingerBack).widthIs(ScreenWidth).heightIs(88);
    
    for (NSInteger i = 0; i < 4; i++) {
        UITextField * input = [[UITextField alloc] init];
        input.textAlignment = NSTextAlignmentCenter;
        input.returnKeyType = UIReturnKeyDone;
        input.keyboardType = UIKeyboardTypeNumberPad;
        input.layer.borderColor = COLOR_HEX(@"#72add2").CGColor;
        input.layer.borderWidth = 1.0f;
        input.secureTextEntry = YES;
        input.tag = Input_Tag + i;
        input.enabled = NO;
        [_pwBack addSubview:input];
        input.sd_layout.centerYEqualToView(finger).
        centerXEqualToView(_pwBack).offset(22+44*(i-2)+((2*i+1)-4)*5).widthIs(44).heightIs(44);
    }
    _backInput = [[UITextField alloc] init];
    _backInput.backgroundColor = [UIColor clearColor];
    _backInput.keyboardType = UIKeyboardTypeNumberPad;
    _backInput.returnKeyType = UIReturnKeyDone;
    _backInput.textColor = [UIColor clearColor];
    _backInput.tintColor = [UIColor clearColor];
    [_backInput addTarget:self action:@selector(valueDidEndEditing:) forControlEvents:UIControlEventEditingChanged];
    [_pwBack addSubview:_backInput];
    _backInput.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    _clickFinger = [[UILabel alloc] init];
    _clickFinger.textAlignment = NSTextAlignmentCenter;
    _clickFinger.textColor = COLOR_HEX(@"#72add2");
    _clickFinger.text = @"点击进行指纹解锁";
    if (iPhoneX) {
        _clickFinger.text = @"点击进行面容解锁";
    }
    _clickFinger.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_clickFinger];
    _clickFinger.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).
    topSpaceToView(_fingerBack, 20).heightIs(20);
    
    UIButton * cancelBtn = [[UIButton alloc] init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:COLOR_HEX(@"#72add2") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelAuthSet) forControlEvents:UIControlEventTouchUpInside];
    ///0、解锁；1、Touch ID验证 2、密码验证
    cancelBtn.hidden = self.authNum == 0;
    [self.view addSubview:cancelBtn];
    CGFloat top = iPhoneX ? 44 : 0;
    cancelBtn.sd_layout.rightSpaceToView(self.view, 20).topSpaceToView(self.view, top+20).widthIs(33).heightIs(40);
    
    UIButton * switchBtn = [[UIButton alloc] init];
    [switchBtn setTitle:@"换个方式解锁" forState:UIControlStateNormal];
    [switchBtn setTitleColor:COLOR_HEX(@"#72add2") forState:UIControlStateNormal];
    switchBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [switchBtn addTarget:self action:@selector(switchUnLockMethod) forControlEvents:UIControlEventTouchUpInside];
    ///0、解锁；1、Touch ID验证 2、密码验证
    switchBtn.hidden = self.authNum != 0;
    [self.view addSubview:switchBtn];
    CGFloat bottom = iPhoneX ? 34 : 0;
    switchBtn.sd_layout.rightEqualToView(self.view).bottomSpaceToView(self.view, bottom).widthIs(120).heightIs(40);
    
    BOOL idLock = [[[NSUserDefaults standardUserDefaults] objectForKey:@"idLock"] boolValue];
    if (self.authNum == 2 || (self.authNum == 0 && !idLock)) {
        [self switchUnLockMethod];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    BOOL idLock = [[[NSUserDefaults standardUserDefaults] objectForKey:@"idLock"] boolValue];
    if (self.authNum == 0 && idLock) {
        [self requestFingerAuth];
    } else if (self.authNum == 1) {
        [self requestOpenAuth];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)valueDidEndEditing:(UITextField *)textField
{
    UITextField * first = [_pwBack viewWithTag:Input_Tag];
    UITextField * second = [_pwBack viewWithTag:Input_Tag+1];
    UITextField * third = [_pwBack viewWithTag:Input_Tag+2];
    UITextField * forth = [_pwBack viewWithTag:Input_Tag+3];
    if (textField.text.length == 0) {
        first.text = @""; second.text = @""; third.text = @""; forth.text = @"";
    } else if (textField.text.length == 1) {
        unichar firstC = [textField.text characterAtIndex:0];
        first.text = [NSString stringWithFormat:@"%c", firstC];
        second.text = @"";  third.text = @"";   forth.text = @"";
    } else if (textField.text.length == 2) {
        unichar secondC = [textField.text characterAtIndex:1];
        second.text = [NSString stringWithFormat:@"%c", secondC];
        third.text = @"";   forth.text = @"";
    } else if (textField.text.length == 3) {
        unichar thirdC = [textField.text characterAtIndex:2];
        third.text = [NSString stringWithFormat:@"%c", thirdC];
        forth.text = @"";
    } else if (textField.text.length == 4) {
        unichar forthC = [textField.text characterAtIndex:3];
        forth.text = [NSString stringWithFormat:@"%c", forthC];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.authNum == 2 && textField.text.length == 4 && _firstPw.length == 0) {
            _clickFinger.text = @"请再次确认密码"; _firstPw = textField.text; _backInput.text = @"";
            first.text = @""; second.text = @""; third.text = @""; forth.text = @"";return;
        }
        if (self.authNum == 2 && textField.text.length == 4 && [textField.text isEqualToString:_firstPw]) {
            [[NSUserDefaults standardUserDefaults] setObject:_firstPw forKey:@"lockPW"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.block) {self.block(YES, self.authNum);}
            }];return;
        }
        if (textField.text.length == 4 && [textField.text isEqualToString:lockPW])
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.block) {self.block(YES, self.authNum);}
            }];return;
        }
        if (textField.text.length == 4) {
            _backInput.text = @"";
            first.text = @""; second.text = @""; third.text = @""; forth.text = @"";
            [UIView animateWithDuration:0.2f animations:^{
                _pwBack.sd_layout.leftSpaceToView(self, -50);
                [_pwBack updateLayout];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f animations:^{
                    _pwBack.sd_layout.leftSpaceToView(self, 50);
                    [_pwBack updateLayout];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2f animations:^{
                        _pwBack.sd_layout.leftSpaceToView(self, -50);
                        [_pwBack updateLayout];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.2f animations:^{
                            _pwBack.sd_layout.leftSpaceToView(self, 50);
                            [_pwBack updateLayout];
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f animations:^{
                                _pwBack.sd_layout.leftSpaceToView(self, 0);
                                [_pwBack updateLayout];
                            } completion:nil];
                        }];
                    }];
                }];
            }];
        }
    });
}

- (void)switchUnLockMethod
{
    _isPW = !_isPW;
    if (_isPW) {
        _clickFinger.text = @"输入密码进行解锁";
        if (self.authNum == 2) {
            _clickFinger.text = @"请输入密码";
        }
        _fingerBack.sd_layout.leftSpaceToView(self, -ScreenWidth);
        [_fingerBack updateLayout];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:0 animations:^{
            _pwBack.sd_layout.leftSpaceToView(self, 0);
            [_pwBack updateLayout];
        } completion:^(BOOL finished) {
            [_backInput becomeFirstResponder];
            _backInput.text = @"";
        }];
    } else {
        _clickFinger.text = @"点击进行指纹解锁";
        if (iPhoneX) {
            _clickFinger.text = @"点击进行面容解锁";
        }
        _pwBack.sd_layout.leftSpaceToView(self, ScreenWidth);
        [_pwBack updateLayout];
        [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:0 animations:^{
            _fingerBack.sd_layout.leftSpaceToView(self, 0);
            [_fingerBack updateLayout];
        } completion:nil];
    }
}

- (void)requestFingerAuth
{
    [self vertifyWithSuccessBlock:^(BOOL isSuccess) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.block) {self.block(isSuccess, self.authNum);};
        }];
    } withAuthFailureBlock:^(LAContext *ctx, NSInteger code) {
        if (code == -1) {
            [UIAlertView showAlertMessage:@"此功能设备不可用~_~" andDelay:1.0f];
        }
        if (code == LAErrorPasscodeNotSet) {
            [UIAlertView showAlertMessage:@"你的设备未设置密码~_~请设置密码后启用(^_-)" andDelay:2.0f];
        }
        if (code == LAErrorUserFallback || code == LAErrorUserCancel)
        {
            XMGLog(@"User tapped Enter Password");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _isPW = NO; [self switchUnLockMethod];
            });
        }
        if (@available(iOS 11.0, *))
        {
            if (code == LAErrorBiometryNotEnrolled)
            {
                if (ctx.biometryType == LABiometryTypeFaceID) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置面容（Face ID），请在手机“设置＞Face ID与密码”中添加面容或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                } else if (ctx.biometryType == LABiometryTypeTouchID)   {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        }
        else
        {
            if (code == LAErrorTouchIDNotEnrolled)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
}

- (void)requestOpenAuth
{
    [self vertifyWithSuccessBlock:^(BOOL isSuccess) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.block) {self.block(isSuccess, self.authNum);};
        }];
    } withAuthFailureBlock:^(LAContext *ctx, NSInteger code) {
        if (code == -1) {
            [UIAlertView showAlertMessage:@"此功能设备不可用~_~" andDelay:1.0f];
        }
        if (code == LAErrorPasscodeNotSet) {
            [UIAlertView showAlertMessage:@"你的设备未设置密码~_~请设置密码后启用(^_-)" andDelay:2.0f];
        }
        if (@available(iOS 11.0, *))
        {
            if (code == LAErrorBiometryNotEnrolled)
            {
                if (ctx.biometryType == LABiometryTypeFaceID) {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置面容（Face ID），请在手机“设置＞Face ID与密码”中添加面容或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                } else if (ctx.biometryType == LABiometryTypeTouchID)   {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
            if (code == LAErrorBiometryNotAvailable) {
                [UIAlertView showAlertMessage:@"此功能设备不可用~_~" andDelay:1.0f];
            }
        }
        else
        {
            if (code == LAErrorTouchIDNotEnrolled)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"尚未设置指纹（Touch ID），请在手机“设置＞Touch ID与密码”中添加指纹或打开密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            if (code == LAErrorTouchIDNotAvailable) {
                [UIAlertView showAlertMessage:@"此功能设备不可用~_~" andDelay:1.0f];
            }
        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.block) {self.block(NO, self.authNum);};
        }];
    }];
}

- (void)cancelAuthSet
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {self.block(NO, self.authNum);}
    }];
}

@end
