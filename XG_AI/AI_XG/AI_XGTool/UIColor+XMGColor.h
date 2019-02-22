//
//  UIColor+XMGColor.h
//  AI_XG
//
//  Created by 小马哥 on 16/2/24.
//  Copyright © 2016年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_HEX(hexStr) [UIColor colorWithHexadecimalString:(hexStr)]
#define COLOR_HEX_WIDTH_ALPHA(hexStr, alpha) [UIColor colorWithHexadecimalString:(hexStr) andAlpha:(alpha)]

@interface UIColor (XMGColor)

/**
 *  根据十六进制色值返回颜色对象  如果不符合  则返回白色
 *
 *  @param hexadecimalString 16进制色值字符串  如   #ffffff
 *
 *  @return 计算后得到的颜色对象
 */
+ (UIColor *)colorWithHexadecimalString:(NSString *)hexadecimalString;

/**
 *  根据十六进制色值返回颜色对象  如果不符合  则返回白色
 *
 *  @param hexadecimalString 16进制色值字符串  如   #ffffff
 *  @param alpha             透明度 0-1.0
 *
 *  @return 计算后得到的颜色对象
 */
+ (UIColor *)colorWithHexadecimalString:(NSString *)hexadecimalString andAlpha:(CGFloat)alpha;

/**
 *  根据颜色构建一个单色的图片
 *
 *  @return 图片对象
 */
- (UIImage *)createMonochromeImage;

@end
