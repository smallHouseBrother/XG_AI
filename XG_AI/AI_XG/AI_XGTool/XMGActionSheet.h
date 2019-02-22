//
//  AI_XGActionSheet.h
//  AI_XG
//
//  Created by 小马哥 on 16/4/19.
//  Copyright © 2016年 小马哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMGActionSheet;

@protocol XMGActionSheetDelegate <NSObject>

@optional

- (void)actionSheet:(XMGActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface XMGActionSheet : UIView

@property (nonatomic, weak) id <XMGActionSheetDelegate> delegate;

- (instancetype)initWithDelegate:(id <XMGActionSheetDelegate>)delegate cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles;

- (void)showInCurrentView;

@end
