//
//  NSObject+XMGReviewNull.h
//  AI_XG
//
//  Created by 小马哥 on 2017/9/23.
//  Copyright © 2017年 Zhao Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XMGReviewNull)

/**
 *  检查对象是否为null
 *
 *  @return 空时返回nil 否则返回对象
 */
- (id)reviewNil;

/**
 *  检查对象是否为null、<null>
 *
 *  @return 空时返回@"" 否则返回对象
 */
- (id)reviewEmpty;

@end
