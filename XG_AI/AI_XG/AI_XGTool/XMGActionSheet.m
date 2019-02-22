//
//  AI_XGActionSheet.m
//  AI_XG
//
//  Created by 小马哥 on 16/4/19.
//  Copyright © 2016年 小马哥. All rights reserved.
//

#import "XMGActionSheet.h"

// 每个按钮的高度
#define buttonHeight 50

// 取消按钮上面的间隔高度
#define margin 8

#define HJCColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

// 背景色
#define GlobelBgColor HJCColor(237, 240, 242)

// 分割线颜色
#define GlobelSeparatorColor HJCColor(234, 234, 234)

// 普通状态下的图片
#define normalImage [self createImageWithColor:HJCColor(255, 255, 255)]

// 高亮状态下的图片
#define highImage [self createImageWithColor:HJCColor(242, 242, 242)]

// 字体
#define HeitiLight(f) [UIFont systemFontOfSize:f]


@interface XMGActionSheet ()
{
    NSInteger _buttonTag;
}

@property (nonatomic, weak) XMGActionSheet * actionSheet;
@property (nonatomic, weak) UIView * sheetView;

@end


@implementation XMGActionSheet

- (instancetype)initWithDelegate:(id <XMGActionSheetDelegate>)delegate cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles
{
    self = [super init];
    if (self)
    {
        self.actionSheet = self;
        self.actionSheet.delegate = delegate;
        
        // 黑色遮盖
        self.actionSheet.frame = [UIScreen mainScreen].bounds;
        self.actionSheet.backgroundColor = [UIColor blackColor];
        self.actionSheet.alpha = 0.0;
        self.actionSheet.tag = 676767;
        [[UIApplication sharedApplication].keyWindow addSubview:self.actionSheet];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewClickAction)];
        [self.actionSheet addGestureRecognizer:tapGesture];
        
        // sheet
        UIView * sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        sheetView.backgroundColor = GlobelBgColor;
        [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
        sheetView.tag = 676767;
        self.sheetView = sheetView;
        sheetView.hidden = YES;
        
        _buttonTag = 1;
        
        if (otherTitles)
        {
            for (NSInteger i = 0; i < otherTitles.count; i++)
            {
                [self addButtonOnTheSheetViewWith:otherTitles[i]];
            }
        }
        
        CGRect sheetViewF = sheetView.frame;
        sheetViewF.size.height = buttonHeight * _buttonTag + margin;
        sheetView.frame = sheetViewF;
        
        // 取消按钮
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, sheetView.frame.size.height - buttonHeight, ScreenWidth, buttonHeight)];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [button setTitle:cancelTitle forState:UIControlStateNormal];
        [button setTitleColor:COLOR_HEX(@"#444444") forState:UIControlStateNormal];
        button.titleLabel.font = HeitiLight(16);
        button.tag = 0;
        [button addTarget:self action:@selector(sheetButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:button];
    }
    return self;
}

- (void)addButtonOnTheSheetViewWith:(NSString *)title
{
    // 创建按钮
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonHeight * (_buttonTag - 1) , ScreenWidth, buttonHeight)];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:COLOR_HEX(@"#444444") forState:UIControlStateNormal];
    button.titleLabel.font = HeitiLight(16);
    button.tag = _buttonTag;
    [button addTarget:self action:@selector(sheetButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:button];
    
    // 最上面画分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    line.backgroundColor = GlobelSeparatorColor;
    [button addSubview:line];
    
    _buttonTag++;
}

- (void)showInCurrentView
{
    self.sheetView.hidden = NO;
    CGRect sheetViewFame = self.sheetView.frame;
    sheetViewFame.origin.y = ScreenHeight;
    self.sheetView.frame = sheetViewFame;
    
    CGRect newSheetViewFrame = self.sheetView.frame;
    newSheetViewFrame.origin.y = ScreenHeight - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.sheetView.frame = newSheetViewFrame;
        
        self.actionSheet.alpha = 0.3;
    }];
}

- (void)backGroundViewClickAction
{
    CGRect sheetViewFame = self.sheetView.frame;
    sheetViewFame.origin.y = ScreenHeight;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.sheetView.frame = sheetViewFame;
        self.actionSheet.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.actionSheet removeFromSuperview];
        self.actionSheet = nil;
        [self.sheetView removeFromSuperview];
        self.sheetView = nil;
        
    }];
}

- (void)sheetButtonClickAction:(UIButton *)button
{
    if (button.tag == 0) 
    {
        [self backGroundViewClickAction];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) 
    {
        [self.delegate actionSheet:self.actionSheet clickedButtonAtIndex:button.tag];
        [self backGroundViewClickAction];
    }
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
