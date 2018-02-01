//
//  XYMenu.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenu.h"
#import "XYMenuView.h"

#define kXYMenuScreenWidth [UIScreen mainScreen].bounds.size.width
#define kXYMenuScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat XYMenuWidth = 120; // Menu宽度
static const CGFloat XYMenuItemHeight = 60; // item高度


@interface XYMenu () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) XYMenuView *menuView;
@property (nonatomic, assign) XYMenuType menuType;
@property (nonatomic, assign) CGRect menuInitRect;
@property (nonatomic, assign) CGRect menuResultRect;
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation XYMenu

// 还是需要一个全局的静态变量

- (instancetype)init
{
    if (self = [super init]) {
        _isDismiss = NO;
        _menuType = XYMenuNormal;
        // 添加pan手势, 防止视图响应scrollview的滚动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        self.frame = CGRectMake(0, 0, kXYMenuScreenWidth, kXYMenuScreenHeight);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.menuView];
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
    if (![self isInMenuViewWithPoint:point]) {
        [XYMenu dismissMenuInView:self.superview];
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)isInMenuViewWithPoint:(CGPoint)point
{
    NSArray *subViews = self.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[XYMenuView class]]) {
            XYMenuView *menuView = (XYMenuView *)subView;
            CGPoint menuVPoint = [self convertPoint:point toView:menuView];
            BOOL isInMenu = [menuView pointInside:menuVPoint withEvent:nil];
            return isInMenu;
        }
    }
    return NO;
}

#pragma mark --- 展示菜单
+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    XYMenu *xy_menu = [[XYMenu alloc] init];
    [xy_menu showMenuWithImages:imagesArr titles:titles inView:view menuType:menuType withItemClickIndex:block];
}

+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC withItemClickIndex:(ItemClickIndexBlock)block
{
    
    XYMenu *xy_menu = [[XYMenu alloc] init];
    [xy_menu showMenuWithImages:imagesArr titles:titles menuType:menuType currentNavVC:currentNavVC withItemClickIndex:block];
    
}

#pragma mark --- 隐藏菜单

+ (void)dismissMenuInView:(UIView *)view
{
    XYMenu *menu = [XYMenu XYMenuInView:view];
    if (menu) {
        [menu dimissXYMenu];
    }
}

+ (XYMenu *)XYMenuInView:(UIView *)view
{
    UIView *rootView = [XYMenu rootViewFromSubView:view];
    NSArray *subViews = rootView.subviews;
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[XYMenu class]]) {
            XYMenu *menu = (XYMenu *)view;
            return menu;
        }
    }
    return nil;
}

- (void)dimissXYMenu
{
    if (_isDismiss) return;
    _isDismiss = YES;
    [self.menuView hideContentView];
    self.menuView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.frame = self.menuInitRect;
        self.menuView.alpha = 0.1;
    } completion:^(BOOL finished) {
        _isDismiss = NO;
        [self removeFromSuperview];
    }];
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC  withItemClickIndex:(ItemClickIndexBlock)block
{
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    switch (menuType) {
        case XYMenuLeftNavBar:
        {
            // 左侧NaviBar
            self.menuInitRect = CGRectMake(10 + (XYMenuWidth / 4), 64, 1, 1);
            self.menuResultRect = CGRectMake(10, 64, XYMenuWidth, XYMenuHeight);
        }
            break;
        case XYMenuRightNavBar:
        {
            // 右侧NaviBar
            self.menuInitRect = CGRectMake(kXYMenuScreenWidth - (XYMenuWidth / 4) - 10, 64, 1, 1);
            self.menuResultRect = CGRectMake(kXYMenuScreenWidth - XYMenuWidth - 10, 64, XYMenuWidth, XYMenuHeight);
        }
            break;
        default:
            break;
    }
    [currentNavVC.view addSubview:self];
    __weak typeof(self) weakSelf = self;
    [self.menuView setImagesArr:imagesArr titles:titles withRect:self.menuResultRect withMenuType:menuType withItemClickBlock:^(NSInteger index) {
        [weakSelf dimissXYMenu];
        block(index);
    }];
    
    self.menuView.frame = self.menuInitRect;
    [self.menuView hideContentView];
    self.menuView.alpha = 0.1;
    [UIView animateWithDuration:0.1 animations:^{
        self.menuView.alpha = 1.0;
        self.menuView.frame = self.menuResultRect;
    } completion:^(BOOL finished) {
        [self.menuView showContentView];
    }];
    
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [self configRectWithMenuType:menuType inView:view titles:titles];
    __weak typeof(self) weakSelf = self;
    [self.menuView setImagesArr:imagesArr titles:titles withRect:self.menuResultRect withMenuType:menuType withItemClickBlock:^(NSInteger index) {
        [weakSelf dimissXYMenu];
        block(index);
    }];
    
    self.menuView.frame = self.menuInitRect;
    [self.menuView hideContentView];
    self.menuView.alpha = 0.1;
    [UIView animateWithDuration:0.1 animations:^{
        self.menuView.alpha = 1.0;
        self.menuView.frame = self.menuResultRect;
    } completion:^(BOOL finished) {
        [self.menuView showContentView];
    }];
}

- (void)configRectWithMenuType:(XYMenuType)menuType inView:(UIView *)view titles:(NSArray *)titles
{
    _menuType = menuType;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *vcView = [XYMenu rootViewFromSubView:view];
    UIView *superView = view.superview;
    CGRect viewRect = view.frame;
    CGRect viewRectFromWindow = [superView convertRect:viewRect toView:keyWindow];
    CGFloat midX = CGRectGetMidX(viewRectFromWindow);
    CGFloat maxX = CGRectGetMaxX(viewRectFromWindow);
    CGFloat maxY = CGRectGetMaxY(viewRectFromWindow);
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    self.menuInitRect = CGRectMake(maxX, maxY, 1, 1);
    self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
    [vcView addSubview:self];
}

#pragma mark --- LoadView

- (XYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[XYMenuView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

#pragma mark --- 返回当前View的控制器的view
+ (UIView *)rootViewFromSubView:(UIView *)view
{
    UIViewController *vc = nil;
    UIResponder *next = view.nextResponder;
    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            vc = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    } while (next != nil);
    if (vc == nil) {
        do {
            if ([next isKindOfClass:[UIViewController class]]) {
                vc = (UIViewController *)next;
                break;
            }
            next = next.nextResponder;
        } while (next != nil);
    }
    return vc.view;
}

@end
