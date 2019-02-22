//
//  XGPicker.h
//  AI_XG
//
//  Created by 小马哥 on 2017/10/11.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XGPicker;

@protocol XGPickerDelegate <NSObject>

- (void)pickerCancelSelectWithPicker:(XGPicker *)picker;

- (void)pickerSureToSelectWithPicker:(XGPicker *)picker withSelectedText:(NSString *)selectedText;

@end

@interface XGPicker : UIView

/**
 *  自定义选择
 *
 *  @param  title       标题
 *  @param  text        默认选中
 *  @param  pickerArray 可选的内容
 *
 */
- (instancetype)initWithTitle:(NSString *)title withSelectedText:(NSString *)text withArray:(NSArray *)pickerArray;

@property (nonatomic, weak) id <XGPickerDelegate> delegate;

@end
