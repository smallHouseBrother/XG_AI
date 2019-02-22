//
//  XGDatePickView.h
//  AI_XG
//
//  Created by 小马哥 on 2017/8/26.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGDatePickView : UIView

@property (nonatomic, copy) void(^selectedTimeBlock)(NSString * timeString);

- (instancetype)initWithTitleString:(NSString *)titleString dateString:(NSString *)dateString withMaxDate:(NSDate *)maxDate withMinDate:(NSString *)minDate;

@end
