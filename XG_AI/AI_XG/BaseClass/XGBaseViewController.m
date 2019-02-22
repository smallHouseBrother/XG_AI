//
//  XGBaseViewController.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "XGBaseViewController.h"
#import <UMAnalytics/MobClick.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <UShareUI/UShareUI.h>

@interface XGBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation XGBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_HEX(@"#f0eef4");
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSStringFromClass([self class]) stringByAppendingFormat:@"_%@", self.title]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSStringFromClass([self class]) stringByAppendingFormat:@"_%@", self.title]];
}

- (void)setBackItem
{
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:0 target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)backAction
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setDismissWithLeft:(BOOL)isLeft withTitle:(NSString *)titleName
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithTitle:titleName style:0 target:self action:@selector(backAction)];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (NSString *)obtainCurrentDayString
{
    NSDate * currentDate = [NSDate date];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:currentDate];
    NSDate * dateNow = [currentDate dateByAddingTimeInterval:time];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0000"];
    return [formatter stringFromDate:dateNow];
}

- (NSString *)weekdayStringFromDate:(NSDate *)inputDate
{
    NSArray * weekdays = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone * timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone:timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents * components = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:components.weekday];
}

#pragma mark - 开始验证按钮点击事件
- (void)vertifyWithSuccessBlock:(void (^)(BOOL isSuccess))successBlock withAuthFailureBlock:(void (^)(LAContext * ctx, NSInteger code))failureBlock
{
    LAContext * context = [[LAContext alloc] init];
    NSError * error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error])
    {
        NSString * string = (iPhoneX) ? @"通过Face ID验证已有手机面容" : @"通过Home键验证已有手机指纹";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:string reply:^(BOOL success, NSError * _Nullable error)
         {
             if (success && successBlock) {
                 successBlock(YES);
                 return;
             }
             if (failureBlock) {
                 failureBlock(context, error.code);
             }
         }];
    }
    else
    {
        if (failureBlock && error.code == -5) {
            failureBlock(context, LAErrorPasscodeNotSet);
        } else if (failureBlock) {
            failureBlock(context, -1);
        }
    }
}

- (void)BaseShareAction
{
    NSMutableArray * title = [NSMutableArray array];
    NSMutableArray * image = [NSMutableArray array];
    if ([WXApi isWXAppInstalled])
    {
        [title addObject:@"微信"];
        [title addObject:@"朋友圈"];
        [image addObject:@"wechat"];
        [image addObject:@"timeLine"];
    }
    if ([QQApiInterface isQQInstalled]) {
        [title addObject:@"QQ"];
        [title addObject:@"空间"];
        [image addObject:@"qq"];
        [image addObject:@"sky"];
    }
    if (title.count == 0)
    {
        [UIAlertController showAlertMessage:@"安装了微信、QQ才能分享~_~" andDelay:1.0f withPresentVC:self];
        return;
    }
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView * backView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:backView];
    
    CGFloat height = ScreenHeight-44-StatusBarHeight-250*ScreenWidth/750;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-1920*height/1080)/2, ScreenHeight-height, 1920*height/1080, height)];
    NSString * key = [self obtainCurrentDayString];
    NSString * imageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    imageView.userInteractionEnabled = YES;
    [backView addSubview:imageView];
    
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = backView.bounds;
    [backView addSubview:effectView];
    
    NSString * dayString = [self obtainCurrentDayString];
    NSString * today = [dayString substringWithRange:NSMakeRange(8, 2)];
    CGSize size = [today sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:35]}];
    UILabel * day = [[UILabel alloc] initWithFrame:CGRectMake(20, 38+StatusBarHeight, size.width, 40)];
    day.textColor = Main_Color;day.text = today;
    day.font = [UIFont systemFontOfSize:35];
    [backView addSubview:day];
    
    UILabel * week = [[UILabel alloc] initWithFrame:CGRectMake(day.right+12, day.center.y-16, 100, 14)];
    week.textColor = Main_Color;
    week.font = [UIFont systemFontOfSize:12];
    week.text = [self weekdayStringFromDate:[NSDate date]];
    [backView addSubview:week];
    
    UILabel * year = [[UILabel alloc] initWithFrame:CGRectMake(day.right+12, day.center.y+2, 100, 14)];
    year.textColor = Main_Color;
    year.font = [UIFont systemFontOfSize:12];
    year.text = [[dayString substringWithRange:NSMakeRange(5, 2)] stringByAppendingFormat:@"/%@", [dayString substringWithRange:NSMakeRange(0, 4)]];
    [backView addSubview:year];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBackView:)];
    [backView addGestureRecognizer:tap];
    
    CGFloat margin = (ScreenWidth - 63 * title.count) / (title.count + 1);
    for (NSInteger i = 0; i < title.count; i++)
    {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake((i+1)*margin+63*i, ScreenHeight, 63, 100)];
        [button setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 37, 0);
        [button addTarget:self action:@selector(shareWithButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 10;
        [backView addSubview:button];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, button.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = Main_Color;
        label.tag = i + 100;
        label.text = title[i];
        [button addSubview:label];
    }
    UIButton * wechat = [backView viewWithTag:10]; UIButton * timeLine = [backView viewWithTag:11];
    UIButton * qq = [backView viewWithTag:12];     UIButton * sky = [backView viewWithTag:13];
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        wechat.top = ScreenHeight - 200;
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        timeLine.top = ScreenHeight - 200;
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        qq.top = ScreenHeight - 200;
    } completion:nil];
    
    [UIView animateWithDuration:0.5f delay:0.15 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        sky.top = ScreenHeight - 200;
    } completion:nil];
}

- (void)removeBackView:(UITapGestureRecognizer *)recognizer
{
    UIView * backView = recognizer.view;
    UIButton * wechat = [backView viewWithTag:10]; UIButton * timeLine = [backView viewWithTag:11];
    UIButton * qq = [backView viewWithTag:12];     UIButton * sky = [backView viewWithTag:13];
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        sky.top = ScreenHeight+20;
    } completion:nil];
    [UIView animateWithDuration:0.5f delay:0.05 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        qq.top = ScreenHeight+20;
    } completion:nil];
    [UIView animateWithDuration:0.5f delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        timeLine.top = ScreenHeight+20;
    } completion:nil];
    [UIView animateWithDuration:0.5f delay:0.15 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        wechat.top = ScreenHeight+20;
    } completion:^(BOOL finished) {
        [backView removeFromSuperview];
    }];
}

- (void)shareWithButton:(UIButton *)button
{
    UILabel * label = [button viewWithTag:button.tag - 10 + 100];
    if ([label.text isEqualToString:@"微信"])
    {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
    }
    if ([label.text isEqualToString:@"朋友圈"])
    {
        [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
    }
    if ([label.text isEqualToString:@"QQ"])
    {
        [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
    }
    if ([label.text isEqualToString:@"空间"])
    {
        [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
    }
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject * messageObject = [UMSocialMessageObject messageObject];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [App_IconArray lastObject]]];
    NSString * title = [NSString stringWithFormat:@"↖(^ω^)↗【%@】看过来，看过来，看过来↖(^ω^)↗", App_Name];
    NSString * desc = [NSString stringWithFormat:@"密码忘记了！o(︶︿︶)o 怎么办？用我呀(≧∇≦)"];
    UMShareWebpageObject * shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:image];
    NSString * appUrl = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", AppId];
    shareObject.webpageUrl = appUrl;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
    }];
}

@end
