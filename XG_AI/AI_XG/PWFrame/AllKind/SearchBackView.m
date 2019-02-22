//
//  SearchBackView.m
//  AI_XG
//
//  Created by jrweid on 2018/6/14.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "SearchBackView.h"

@implementation SearchBackView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = COLOR_HEX(@"#fafafa");

        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    UILabel * zhiDing = [[UILabel alloc] init];
    zhiDing.textAlignment = NSTextAlignmentCenter;
    zhiDing.textColor = COLOR_HEX(@"#AAAAAA");
    zhiDing.text = @"指定搜索内容";
    zhiDing.font = [UIFont systemFontOfSize:16];
    [self addSubview:zhiDing];
    zhiDing.sd_layout.leftEqualToView(self).topSpaceToView(self, 58).rightEqualToView(self).heightIs(20);
    
//    标题、账号、密码、备注 25 50
    UILabel * title = [[UILabel alloc] init];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = Icon_Color;
    title.text = @"标题";
    [self addSubview:title];
    title.sd_layout.leftSpaceToView(self, 20*Screen_Scale).topSpaceToView(zhiDing, 25*Screen_Scale/2).widthIs(ScreenWidth/2-20*Screen_Scale).heightIs(25);
    
    UIView * firstLine = [[UIView alloc] init];
    firstLine.backgroundColor = COLOR_HEX(@"#AAAAAA");
    [self addSubview:firstLine];
    firstLine.sd_layout.leftSpaceToView(title, 0).centerYEqualToView(title).widthIs(0.5).heightIs(10*Screen_Scale);
    
    UILabel * account = [[UILabel alloc] init];
    account.textAlignment = NSTextAlignmentCenter;
    account.font = [UIFont systemFontOfSize:18];
    account.textColor = Icon_Color;
    account.text = @"账号";
    [self addSubview:account];
    account.sd_layout.leftSpaceToView(firstLine, 0).centerYEqualToView(title).widthRatioToView(title, 1).heightIs(25);
    
    UILabel * passWord = [[UILabel alloc] init];
    passWord.textAlignment = NSTextAlignmentCenter;
    passWord.font = [UIFont systemFontOfSize:18];
    passWord.textColor = Icon_Color;
    passWord.text = @"网址";
    [self addSubview:passWord];
    passWord.sd_layout.leftSpaceToView(self, 20*Screen_Scale).topSpaceToView(title, 20*Screen_Scale).widthIs(ScreenWidth/2-20*Screen_Scale).heightIs(25);
    
    UIView * secondLine = [[UIView alloc] init];
    secondLine.backgroundColor = COLOR_HEX(@"#AAAAAA");
    [self addSubview:secondLine];
    secondLine.sd_layout.leftSpaceToView(passWord, 0).centerYEqualToView(passWord).widthIs(0.5).heightIs(10*Screen_Scale);
    
    UILabel * beiZhu = [[UILabel alloc] init];
    beiZhu.textAlignment = NSTextAlignmentCenter;
    beiZhu.font = [UIFont systemFontOfSize:18];
    beiZhu.textColor = Icon_Color;
    beiZhu.text = @"备注";
    [self addSubview:beiZhu];
    beiZhu.sd_layout.leftSpaceToView(secondLine, 0).centerYEqualToView(passWord).widthRatioToView(passWord, 1).heightIs(25);
}

@end
