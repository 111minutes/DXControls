//
//  DXSwitch.h
//  DXSwitcher
//
//  Created by Andriy Fedin on 8/1/12.
//  Copyright (c) 2012 111 Minutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DXSwitch : UIControl

- (id)initWithOnBackgroundName:(NSString *)onBackName offBackgroundName:(NSString *)offBackName leverName:(NSString *)leverName maskName:(NSString *)maskName;
- (void)setOnImage:(NSString *)onImgName offImage:(NSString *)offImgName;
- (void)setLabelsWithFont:(UIFont *)font onText:(NSString *)onText offText:(NSString *)offText onTextColor:(UIColor *)onTextColor offTextColor:(UIColor *)offTextColor;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
- (BOOL)on;

@end
