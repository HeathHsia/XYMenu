//
//  XYMenuItem.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYMenuItem : UIView

- (instancetype)initWithIconName:(NSString *)iconName title:(NSString *)title;

- (void)setUpViewsWithRect:(CGRect)rect;

@end
