//
//  FeedBackViewController.m
//  AI_XG
//
//  Created by jrweid on 2018/7/16.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "FeedBackViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "XMGProgressView.h"

@interface FeedBackViewController ()
{
    UITextView * _textView;
}
@end

@implementation FeedBackViewController

- (void)loadView
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    
    [self setDismissWithLeft:NO withTitle:@"取消"];
    
    [self addSubViews];
}

- (void)addSubViews
{
    UITextView * textView = [[UITextView alloc] init];
    textView.layer.borderColor = Main_Color.CGColor;
    textView.textColor = Main_Color;
    textView.layer.borderWidth = 0.5f;
    textView.layer.cornerRadius = 5.0f;
    textView.layer.masksToBounds = YES;
    textView.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:_textView = textView];
    textView.sd_layout.leftSpaceToView(self.view, 12).topSpaceToView(self.view, 12).rightSpaceToView(self.view, 12).heightIs(100);
    
    UILabel * introduce = [[UILabel alloc] init];
    introduce.textColor = Main_Color;
    introduce.font = [UIFont systemFontOfSize:14];
    introduce.numberOfLines = 0;
    introduce.text = @"可以填写你的建议和意见，如需得到回复，请留下你的联系方式~_~";
    [self.view addSubview:introduce];
    introduce.sd_layout.leftEqualToView(textView).topSpaceToView(textView, 8).rightEqualToView(textView).heightIs(40);
    
    UIButton * saveBtn = [[UIButton alloc] init];
    saveBtn.backgroundColor = Main_Color;
    saveBtn.layer.cornerRadius = 5.0f;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveCurrentFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.sd_layout.leftEqualToView(textView).topSpaceToView(introduce, 50).rightEqualToView(textView).heightIs(44);
    UIScrollView * scrollView = (UIScrollView *)self.view;
    
    GADBannerView * bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.backgroundColor = [UIColor clearColor];
    bannerView.rootViewController = self;
    bannerView.adUnitID = textId;
    [self.view addSubview:bannerView];
    [bannerView loadRequest:[GADRequest request]];
    
    CGFloat bottom = 0; if (iPhoneX) bottom = 34;
    bannerView.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, bottom+StatusBarHeight+44).rightEqualToView(self.view).heightIs(50);
    
    CGFloat height = ScreenHeight - 64;
    if (iPhoneX)
    {
        height = ScreenHeight - 88 - 34;
    }
    scrollView.contentSize = CGSizeMake(0, height + 0.3);
}

- (void)saveCurrentFeedBack:(UIButton *)button
{
    [XMGProgressView showHUDAddedTo:self.view];
    AVObject * object = [AVObject objectWithClassName:@"pwFeedBack"];
    [object setObject:_textView.text forKey:@"App_FeedBack"];
    [object setObject:App_Version forKey:@"App_Version"];
    [object setObject:App_Build forKey:@"App_Build"];
    [object setObject:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [object setObject:[NSString phoneType] forKey:@"Phone_Type"];
    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [button setTitleColor:Main_Color forState:UIControlStateNormal];
        [XMGProgressView hideHUDForView:self.view];
        [UIAlertView showAlertMessage:@"感谢你的反馈，生活有你而美↖(^ω^)↗" andDelay:1.0f];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
