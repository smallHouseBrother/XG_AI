//
//  UIColor+XMGColor.m
//  AI_XG
//
//  Created by 小马哥 on 16/2/24.
//  Copyright © 2016年 小马哥. All rights reserved.
//

#import "UIColor+XMGColor.h"

@implementation UIColor (XMGColor)

/**
 *  根据十六进制色值返回颜色对象
 *
 *  @param hexadecimalString 16进制色值字符串  如   #ffffff
 *
 *  @return 计算后得到的颜色对象
 */
+ (UIColor *)colorWithHexadecimalString:(NSString *)hexadecimalString {
    
    if ([hexadecimalString isKindOfClass:[NSString class]] == NO) {
        return [UIColor cyanColor];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexadecimalString];
    
    NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    
    NSString *hexadecimalNumberString = nil;
    
    BOOL isOk = [scanner scanString:@"#" intoString:nil] && [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&hexadecimalNumberString] && hexadecimalNumberString.length == 6;
    
    if (!isOk) {
        
        scanner = [NSScanner scannerWithString:hexadecimalString];
        isOk = [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&hexadecimalNumberString] && hexadecimalNumberString.length == 6;
        
        if (!isOk) {
            return [UIColor cyanColor];
        }
    }
    
    unsigned int red, green, blue;
    
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

/**
 *  根据十六进制色值返回颜色对象  如果不符合  则返回白色
 *
 *  @param hexadecimalString 16进制色值字符串  如   #ffffff
 *  @param alpha             透明度 0-1.0
 *
 *  @return 计算后得到的颜色对象
 */
+ (UIColor *)colorWithHexadecimalString:(NSString *)hexadecimalString andAlpha:(CGFloat)alpha {
    if ([hexadecimalString isKindOfClass:[NSString class]] == NO) {
        return [UIColor cyanColor];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexadecimalString];
    
    NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    
    NSString *hexadecimalNumberString = nil;
    
    BOOL isOk = [scanner scanString:@"#" intoString:nil] && [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&hexadecimalNumberString] && hexadecimalNumberString.length == 6;
    
    if (!isOk) {
        
        scanner = [NSScanner scannerWithString:hexadecimalString];
        isOk = [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&hexadecimalNumberString] && hexadecimalNumberString.length == 6;
        
        if (!isOk) {
            return [UIColor cyanColor];
        }
    }
    
    unsigned int red, green, blue;
    
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red];
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green];
    [[NSScanner scannerWithString:[hexadecimalNumberString substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue];
    
    CGFloat temAlpha = alpha;
    if (temAlpha < 0) {
        temAlpha = 0;
    }
    
    if (temAlpha > 1.0) {
        temAlpha = 1;
    }
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:temAlpha];
}

/**
 *  根据颜色构建一个单色的图片
 *
 *  @return 图片对象
 */
- (UIImage *)createMonochromeImage {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
