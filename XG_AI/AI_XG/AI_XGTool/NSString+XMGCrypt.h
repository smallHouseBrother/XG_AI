//
//  NSString+XMGCrypt.h
//  AI_XG
//
//  Created by 小马哥 on 2017/11/16.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XMGCrypt)

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password;

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password;

@end
