//
//  XYMenuBackView.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/27.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenuBackView.h"
#import "XYMenu.h"

@implementation XYMenuBackView


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if ([view isKindOfClass:[self class]]) {
         [XYMenu dismissMenu];
    }
}

@end
