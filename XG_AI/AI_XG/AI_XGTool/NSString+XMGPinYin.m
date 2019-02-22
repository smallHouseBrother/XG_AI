//
//  NSString+XMGPinYin.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/28.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "NSString+XMGPinYin.h"

@implementation NSString (XMGPinYin)

+ (NSString *)changeToPinYinWithString:(NSString *)string
{
    // 转成可变
    NSMutableString * mString = [NSMutableString stringWithString:string];
    // 转为带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)mString, NULL, kCFStringTransformMandarinLatin, NO);
    XMGLog(@"转为带声调的拼音-->%@",mString);
    
    // 再转换为不带声调的拼音
    CFStringTransform((__bridge CFMutableStringRef)mString, NULL, kCFStringTransformStripDiacritics, NO);
    XMGLog(@"换为不带声调的拼音-->%@",mString);
    
    // 转化为首字母大写拼音
    NSString * pinyin  = [mString capitalizedString];
    XMGLog(@"首字母大写拼音-->%@",pinyin);
    return pinyin;
}

@end
