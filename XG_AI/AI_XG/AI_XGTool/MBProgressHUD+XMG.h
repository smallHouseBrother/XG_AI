//
//  MBProgressHUD+XMG.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/25.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XMG)

+ (void)showInView:(UIView *)view withTitle:(NSString *)title withImageName:(NSString *)imageName afterDelay:(NSTimeInterval)delay;

@end
