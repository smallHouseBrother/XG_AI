//
//  XGLabel.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/26.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XGLabel.h"

@implementation XGLabel

- (instancetype)initWithTextColor:(NSString *)color withFont:(CGFloat)font
{
    self = [super init];
    if (self)
    {
        self.textColor = COLOR_HEX(color);
        self.font = [UIFont systemFontOfSize:font];
    }
    return self;
}

@end
