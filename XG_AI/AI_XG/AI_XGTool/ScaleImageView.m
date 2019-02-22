//
//  ScaleImageView.m
//  AI_XG
//
//  Created by jrweid on 2018/8/6.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "ScaleImageView.h"

@interface ScaleImageView () <UIScrollViewDelegate, XMGActionSheetDelegate>
{
    UIImageView  * _imageView;
}
@end

@implementation ScaleImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.maximumZoomScale = 3.0f;
    scrollView.minimumZoomScale = 0.5f;
    scrollView.delegate = self;
    [self addSubview:_scrollView = scrollView];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [scrollView addSubview:_imageView = imageView];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
    [imageView addGestureRecognizer:doubleTap];//添加双击手势
    
    UILongPressGestureRecognizer * longPressSave = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSaveAction:)];
    [imageView addGestureRecognizer:longPressSave];
}

#pragma mark 缩放
/**
 *  当前缩放的imageview
 *
 *  @param scrollView self.scrollView
 *
 *  @return 当前scrollView里的imageView
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

//缩放后让图片显示到屏幕中间
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize originalSize = _scrollView.bounds.size;
    CGSize contentSize = _scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    _imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

//结束后scale太小就回到初始状态
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGFloat zoneScale = scrollView.zoomScale;
    zoneScale = MAX(zoneScale, 1.0);
    zoneScale = MIN(zoneScale, 3.0);
    [_scrollView setZoomScale:zoneScale animated:YES];
}

//双击
- (void)doubleTapAction:(UITapGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            //以点击点为中心，放大图片
            CGPoint touchPoint = [recognizer locationInView:recognizer.view];
            BOOL zoomOut = _scrollView.zoomScale == 1.0;
            CGFloat scale = zoomOut ? _scrollView.maximumZoomScale:1.0;
            [UIView animateWithDuration:0.3 animations:^{
                _scrollView.zoomScale = scale;
                if(zoomOut)
                {
                    CGFloat x = touchPoint.x * scale - _scrollView.bounds.size.width / 2;
                    CGFloat maxX = _scrollView.contentSize.width - _scrollView.bounds.size.width;
                    CGFloat minX = 0;
                    x = x > maxX ? maxX : x;
                    x = x < minX ? minX : x;
                    
                    CGFloat y = touchPoint.y * scale - _scrollView.bounds.size.height / 2;
                    CGFloat maxY = _scrollView.contentSize.height - _scrollView.bounds.size.height;
                    CGFloat minY = 0;
                    y = y > maxY ? maxY : y;
                    y = y < minY ? minY : y;
                    _scrollView.contentOffset = CGPointMake(x, y);
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)longPressSaveAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView * imageView = (UIImageView *)recognizer.view;
    if (!imageView.image)    return;
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        XMGActionSheet * sheet = [[XMGActionSheet alloc] initWithDelegate:self cancelTitle:@"取消" otherTitles:@[@"保存图片"]];
        [sheet showInCurrentView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1 && _imageView.image) {
        UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error)
    {
        [UIAlertView showAlertMessage:@"保存失败" andDelay:1.0f];
    }
    else
    {
        [UIAlertView showAlertMessage:@"保存成功" andDelay:1.0f];
    }
}

- (void)setImageViewFrameWithImage:(UIImage *)image
{
    if (!image) return;
    _imageView.image = image;
    _scrollView.zoomScale = 1.0f;
    CGFloat width = image.size.width;                       //361
    CGFloat height = image.size.height;                     //4096
    CGFloat maxHeight = _scrollView.bounds.size.height;     //736
    CGFloat maxWidth = _scrollView.bounds.size.width;       //414

    if ((height / width) * maxWidth > maxHeight)
    {
        _scrollView.contentSize = CGSizeMake(0, (height / width) * maxWidth);
        height = (height / width) * maxWidth;
        _imageView.frame = CGRectMake(0, 0, maxWidth, height);
    }
    else
    {
        _scrollView.contentSize = CGSizeZero;
        height = (height / width) * maxWidth;
        _imageView.frame = CGRectMake(0, (maxHeight - height) / 2, maxWidth, height);
    }
}

@end
