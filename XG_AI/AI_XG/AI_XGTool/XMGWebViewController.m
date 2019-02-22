//
//  XGRefundProtocolViewController.m
//  XYGJ
//
//  Created by Zhao Chen on 2017/10/19.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import "XMGWebViewController.h"
#import <WebKit/WebKit.h>

@interface XMGWebViewController () <WKNavigationDelegate>
{
    GADBannerView * _bannerView;
    WKWebView     * _webView;
    UIView        * _progressView;
    NSString      * _titleString;
    NSString      * _urlString;
}
@end

@implementation XMGWebViewController

- (instancetype)initWithTitle:(NSString *)title withUrl:(NSString *)urlString
{
    self = [super init];
    if (self)
    {
        _titleString  = title;
        _urlString    = urlString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _titleString;
    
    [self addSubViews];
    
    [self setNavigation];
}

- (void)setNavigation
{
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:0 target:self action:@selector(backAction)];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage imageNamed:@"navigation_close"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(10, -5, 10, 25);
    [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * close = [[UIBarButtonItem alloc] initWithCustomView:button];

    if ([_webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[back, close];
    } else {
        self.navigationItem.leftBarButtonItems = @[back];
    }
}

- (void)addSubViews
{
    WKWebView * webView = [[WKWebView alloc] init];
    webView.backgroundColor = COLOR_HEX(@"#f5f5f5");
    webView.navigationDelegate = self;
    self.view = _webView = webView;
    webView.allowsBackForwardNavigationGestures = YES;
    UIEdgeInsets insets = webView.scrollView.contentInset;
    webView.scrollView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom+50, insets.right);
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    [webView loadRequest:request];
    
    _bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _bannerView.backgroundColor = [UIColor clearColor];
    _bannerView.rootViewController = self;
    _bannerView.adUnitID = textId;
    [self.view addSubview:_bannerView];
    [_bannerView loadRequest:[GADRequest request]];
    _bannerView.sd_layout.leftEqualToView(self.view).bottomSpaceToView(self.view, BottomSafeArea).rightEqualToView(self.view).heightIs(50);
}

// 决定导航的动作，通常用于处理跨域的链接能否导航。
// WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
// 但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //  在发送请求之前，决定是否跳转
    self.title = webView.title;
    if (navigationAction.navigationType == WKNavigationTypeBackForward) {//判断是返回类型
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
        [self setNavigation];
        //可以在这里找到指定的历史页面做跳转
//        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
//            DLog(@"%@",webView.backForwardList.backList);
//            DLog(@"%@",webView.backForwardList.currentItem);
//            WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
//            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
//                //添加判断条件
//                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
//            }
//        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 是否接收响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}

//main frame的导航开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if ([webView.URL.absoluteString hasPrefix:@"http://"] || [webView.URL.absoluteString hasPrefix:@"https://"]) {
        [self loadStart];
    }
}

//当main frame导航完成时，会回调  页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.title = webView.title;
    
    [self loadFinish];
    
    [self setNavigation];
}

/**
 *  开始加载
 */
- (void)loadStart
{
    CGFloat top = iPhoneX ? 88 : 64;
    [_progressView removeFromSuperview];
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, top, 0, 2)];
    _progressView.backgroundColor = Main_Color;
    [self.view addSubview:_progressView];
    
    if (iPhoneX)
    {
        [UIView animateWithDuration:0.8f animations:^{
            _progressView.frame = CGRectMake(0, 88, ScreenWidth*2/3, 2);
        }];
        return;
    }
    [UIView animateWithDuration:0.8f animations:^{
        _progressView.frame = CGRectMake(0, 64, ScreenWidth*2/3, 2);
    }];
}

/**
 *  加载完成
 */
- (void)loadFinish
{
    if (iPhoneX)
    {
        [UIView animateWithDuration:0.3f animations:^{
            _progressView.frame = CGRectMake(0, 88, ScreenWidth, 2);
        } completion:^(BOOL finished) {
            [_progressView removeFromSuperview];
            _progressView = nil;
        }];
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _progressView.frame = CGRectMake(0, 64, ScreenWidth, 2);
    } completion:^(BOOL finished) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }];
}

- (void)backAction
{
    if ([_webView canGoBack]) {
        [_webView goBack];return;
    }
    [super backAction];
}

- (void)closeAction
{
    [super backAction];
}

@end
