
//
//  XGDatePickView.m
//  AI_XG
//
//  Created by 小马哥 on 2017/8/26.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XGDatePickView.h"

@interface XGDatePickView ()

@property (nonatomic, strong) UIDatePicker * picker;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation XGDatePickView

- (NSDateFormatter *)formatter
{
    if (!_formatter)
    {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy.MM.dd"];
    }
    return _formatter;
}

- (instancetype)initWithTitleString:(NSString *)titleString dateString:(NSString *)dateString withMaxDate:(NSDate *)maxDate withMinDate:(NSString *)minDate
{
    self = [super init];
    if (self)
    {
        [self addSubViewsWithTitle:titleString dateString:dateString withMaxDate:maxDate withMinDate:minDate];
    }
    return self;
}

- (void)addSubViewsWithTitle:(NSString *)title dateString:(NSString *)dateString withMaxDate:(NSDate *)maxDate withMinDate:(NSString *)minDate
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePicker)];
    [self addGestureRecognizer:tap];
    
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    backView.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(256);
    
    UIView * topBack = [[UIView alloc] init];
    topBack.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self addSubview:topBack];
    topBack.sd_layout.leftEqualToView(self).rightEqualToView(self).topEqualToView(self).bottomSpaceToView(backView, 0);
    
    UIButton * cancel = [[UIButton alloc] init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:COLOR_HEX(@"#287dfb") forState:UIControlStateNormal];
    cancel.backgroundColor = COLOR_HEX(@"#dadada");
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    cancel.layer.cornerRadius = 10.0f;
    [cancel addTarget:self action:@selector(removePicker) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancel];
    cancel.sd_layout.leftSpaceToView(backView, 12).topSpaceToView(backView, 7.5).widthIs(60).heightIs(25);
    
    UIButton * sure = [[UIButton alloc] init];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = COLOR_HEX(@"#287dfb");
    sure.titleLabel.font = [UIFont systemFontOfSize:15];
    sure.layer.cornerRadius = 10.0f;
    [sure addTarget:self action:@selector(sureToSetDay) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sure];
    sure.sd_layout.rightSpaceToView(backView, 12).topSpaceToView(backView, 7.5).widthIs(60).heightIs(25);
    
    XGLabel * titleLabel = [[XGLabel alloc] initWithTextColor:@"#666666" withFont:15];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(cancel, 0).rightSpaceToView(sure, 0).centerYEqualToView(cancel).heightRatioToView(backView, 1);
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR_HEX(@"#e5e5e5");
    [backView addSubview:lineView];
    lineView.sd_layout.leftEqualToView(backView).rightEqualToView(backView).topSpaceToView(backView, 40).heightIs(0.5);
    
    _picker = [[UIDatePicker alloc] init];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.datePickerMode = UIDatePickerModeDate;
    if (minDate && ![minDate isEqualToString:@""]) {
        _picker.minimumDate = [self.formatter dateFromString:minDate];
    }
    if (maxDate) {
        _picker.maximumDate = maxDate;
    }
    
    if (dateString && ![dateString isEqualToString:@""]) {
        [_picker setDate:[self.formatter dateFromString:dateString]];
    } else {
        [_picker setDate:[NSDate date]];
    }
    [backView addSubview:_picker];
    _picker.sd_layout.leftEqualToView(backView).rightEqualToView(backView).topSpaceToView(lineView, 0).heightIs(216);
}

- (void)sureToSetDay
{
    if (self.selectedTimeBlock)
    {
        self.selectedTimeBlock([self.formatter stringFromDate:_picker.date]);
    }
    
    [self removePicker];
}

- (void)removePicker
{
    [self removeFromSuperview];
}

@end
