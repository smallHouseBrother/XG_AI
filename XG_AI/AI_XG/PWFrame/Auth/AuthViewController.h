//
//  AuthViewController.h
//  AI_XG
//
//  Created by jrweid on 2018/6/11.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "XGBaseViewController.h"

typedef void(^requestAuthBlock)(BOOL authSuccess, NSInteger authNum);

@interface AuthViewController : XGBaseViewController

///0、解锁；1、Touch ID验证 2、密码验证
@property (nonatomic) NSInteger authNum;

@property (nonatomic, copy) requestAuthBlock block;

@end
