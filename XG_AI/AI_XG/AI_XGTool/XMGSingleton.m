//
//  AI_XGSingleton.m
//  AI_XG
//
//  Created by 小马哥 on 2017/11/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XMGSingleton.h"

@implementation XMGSingleton

static XMGSingleton * _singleton;

+ (instancetype)shareXMGSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_singleton) {
            _singleton = [[[self class] alloc] init];
        }
    });
    return _singleton;
}

@end
