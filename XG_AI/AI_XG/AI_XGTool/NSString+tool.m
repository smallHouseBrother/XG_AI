//
//  NSString+tool.m
//  AI_XG
//
//  Created by jrweid on 2018/8/24.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "NSString+tool.h"
#import "sys/utsname.h"

@implementation NSString (tool)

+ (NSString *)phoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    return platform;
}

+ (BOOL)isPureNumber:(NSString *)string
{
    NSScanner * scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}

+ (BOOL)isPureCharacter:(NSString *)string
{
    for(NSInteger i = 0; i < string.length; i++)
    {
        unichar charcater = [string characterAtIndex:i];
        if((charcater < 'A' || charcater >'Z') && (charcater < 'a' || charcater > 'z'))
        {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)dynamicGenerate16BitString
{
    char bytes16String[16];
    
    for (NSInteger x = 0; x < 16; bytes16String[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:bytes16String length:16 encoding:NSUTF8StringEncoding];
}

@end
