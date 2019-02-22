//
//  NSObject+XMGReviewNull.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/23.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "NSObject+XMGReviewNull.h"

@implementation NSObject (XMGReviewNull)

/**
 *  检查对象是否为null、<null>
 *
 *  @return 空时返回@"" 否则返回对象
 */
- (id)reviewEmpty
{
    if (self == [NSNull null]) {
        return @"";
    }
    if ([self isKindOfClass:[NSString class]] && [(NSString *)self isEqualToString:@"<null>"])
    {
        return @"";
    }
    return self;
}

/**
 *  检查对象是否为null
 *
 *  @return 空时返回nil 否则返回对象
 */
- (id)reviewNil
{
    if (self == [NSNull null]) {
        return nil;
    }
    return self;
}

@end
