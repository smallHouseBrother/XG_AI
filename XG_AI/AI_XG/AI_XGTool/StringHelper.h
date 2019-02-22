//
//  StringHelper.h
//  JRWD
//
//  Created by user on 16/2/27.
//  Copyright © 2016年 hejin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringHelper : NSObject

+(NSString *)trim:(NSString *)string;

+(NSString *)jsonStringFromArray:(NSArray *)array;

+(NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;

//判断只包含数字和字母
+ (NSString *)judgeStringContainNumberAndCharecterOnly:(NSString *)str;

@end
