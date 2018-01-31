//
//  XYMenuBackView.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/27.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenuBackView.h"
#import "XYMenu.h"

@interface XYMenuBackView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) XYMenuView *menuView;
@property (nonatomic, assign) XYMenuType menuType;
@property (nonatomic, assign) CGRect menuInitRect;
@property (nonatomic, assign) CGRect menuResultRect;
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation XYMenuBackView

- (instancetype)init
{
    if (self = [super init]) {
        // 添加pan手势, 防止视图响应scrollview的滚动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan
{
    if ([pan.view isEqual:self]) {
        return ;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![XYMenu isInMenuViewWithPoint:point]) {
        [XYMenu dismissMenu];
    }
    return [super hitTest:point withEvent:event];
}



@end
