//
//  UIView+XMG.m
//  smallHouseBrother_ios
//
//  Created by 小马哥 on 2017/11/23.
//  Copyright © 2017年 smallHouseBrother_ios. All rights reserved.
//

#import "UIView+XMG.h"

@implementation UIView (XMG)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}

@end
