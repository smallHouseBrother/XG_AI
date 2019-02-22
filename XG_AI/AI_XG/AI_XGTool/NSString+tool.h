//
//  NSString+tool.h
//  AI_XG
//
//  Created by jrweid on 2018/8/24.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (tool)

+ (NSString *)phoneType;

+ (BOOL)isPureNumber:(NSString *)string;

+ (BOOL)isPureCharacter:(NSString *)string;

///动态生成16位字符串
+ (NSString *)dynamicGenerate16BitString;

@end
