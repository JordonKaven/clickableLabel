//
//  UILabel+Clickable.h
//  ClickableLabel
//
//  Created by 彭柯柱 on 2016/10/27.
//  Copyright © 2016年 彭柯柱. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^actionBlock)(void);

@interface UILabel (Clickable)

- (void)addAction:(actionBlock)action forString:(NSString *)string underLine:(BOOL)needUnderLine;

@end
