//
//  XGPicker.m
//  AI_XG
//
//  Created by 小马哥 on 2017/10/11.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "XGPicker.h"

@interface XGPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView * _picker;
    UIView       * _backView;
    NSArray      * _dataArray;
}
@end

@implementation XGPicker

- (instancetype)initWithTitle:(NSString *)title withSelectedText:(NSString *)text withArray:(NSArray *)pickerArray
{
    self = [super init];
    if (self)
    {
        _dataArray = [pickerArray copy];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviewsWithTitle:title withSelectedText:text];
    }
    return self;
}

- (void)addSubviewsWithTitle:(NSString *)title withSelectedText:(NSString *)text
{
    UIPickerView * picker = [[UIPickerView alloc] init];
    picker.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    picker.showsSelectionIndicator = YES;
    picker.delegate = self;
    picker.dataSource = self;
    [self addSubview:_picker = picker];
    picker.sd_layout.leftEqualToView(self).rightEqualToView(self).bottomEqualToView(self).heightIs(162);
    
    if ([_dataArray containsObject:text])
    {
        NSInteger index = [_dataArray indexOfObject:text];
        [picker selectRow:index inComponent:0 animated:YES];
    }
    
    UIView * backView = [[UIView alloc] init];
    backView.backgroundColor = COLOR_HEX(@"#eeeeee");
    [self addSubview:_backView = backView];
    backView.sd_layout.leftEqualToView(picker).rightEqualToView(picker).bottomSpaceToView(picker, 0).heightIs(40);
    
    UIButton * cancel = [[UIButton alloc] init];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:COLOR_HEX(@"#287dfb") forState:UIControlStateNormal];
    cancel.backgroundColor = COLOR_HEX(@"#dadada");
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    cancel.layer.cornerRadius = 10.0f;
    [cancel addTarget:self action:@selector(removePicker) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancel];
    cancel.sd_layout.leftSpaceToView(backView, 12).centerYEqualToView(backView).widthIs(60).heightIs(25);
    
    UIButton * sure = [[UIButton alloc] init];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sure.backgroundColor = COLOR_HEX(@"#287dfb");
    sure.titleLabel.font = [UIFont systemFontOfSize:15];
    sure.layer.cornerRadius = 10.0f;
    [sure addTarget:self action:@selector(sureToSetDay:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sure];
    sure.sd_layout.rightSpaceToView(backView, 12).centerYEqualToView(backView).widthIs(60).heightIs(25);
    
    XGLabel * titleLabel = [[XGLabel alloc] initWithTextColor:@"#666666" withFont:15];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    titleLabel.sd_layout.leftSpaceToView(cancel, 0).rightSpaceToView(sure, 0).topEqualToView(backView).heightRatioToView(backView, 1);
}

- (void)removePicker
{
    [self.delegate pickerCancelSelectWithPicker:self];
}

- (void)sureToSetDay:(UIButton *)sure
{
    [self removePicker];
    
    NSInteger row = [_picker selectedRowInComponent:0];
    NSString * selectedString = _dataArray[row];
    [self.delegate pickerSureToSelectWithPicker:self withSelectedText:selectedString];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}

@end
