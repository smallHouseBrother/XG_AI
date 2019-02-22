//
//  XGCountDownBtn.m
//  AI_XG
//
//  Created by 小马哥 on 2017/9/20.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XGCountDownBtn.h"

@interface XGCountDownBtn ()
{
    dispatch_source_t _timer;
    __block NSInteger _downNumber;
}
@end

@implementation XGCountDownBtn

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self)
    {
        [self initTimerWithTitle:title];
    }
    return self;
}

- (void)initTimerWithTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    dispatch_queue_t queue = dispatch_queue_create("countDown.Queue", DISPATCH_QUEUE_CONCURRENT);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _downNumber--;
            NSString * titleString = _downNumber > 0 ? [NSString stringWithFormat:@"%@s", @(_downNumber)] : title;
            [self setTitle:titleString forState:UIControlStateNormal];
            self.enabled = NO;
            if (_downNumber <= 0)
            {
                self.enabled = YES;
                dispatch_suspend(_timer);
            }
        });
    });
}

- (void)startCountDownWithNumber:(NSInteger)number
{
    _downNumber = number;
    dispatch_resume(_timer);
}

///初始化  未发送时的title 格式变化,  left 58s right
- (instancetype)initWithTitle:(NSString *)title withLeftContent:(NSString *)left withRightContent:(NSString *)right
{
    self = [super init];
    if (self)
    {
        [self initTimerWithTitle:title withLeftContent:left withRightContent:right];
    }
    return self;
}


- (void)initTimerWithTitle:(NSString *)title withLeftContent:(NSString *)left withRightContent:(NSString *)right
{
    [self setTitle:title forState:UIControlStateNormal];
    dispatch_queue_t queue = dispatch_queue_create("countDown.Queue", DISPATCH_QUEUE_CONCURRENT);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            _downNumber--;
            NSString * titleString = _downNumber > 0 ? [NSString stringWithFormat:@"%@%@s%@", left, @(_downNumber), right] : title;
            [self setTitle:titleString forState:UIControlStateNormal];
            self.enabled = NO;
            if (_downNumber <= 0)
            {
                self.enabled = YES;
                dispatch_suspend(_timer);
            }
        });
    });
}

@end
