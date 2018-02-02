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
@property (nonatomic, assign) BOOL isDown;

@end

@implementation XYMenu

- (instancetype)init
{
    if (self = [super init]) {
        _isDismiss = NO;
        _isDown = YES;
        // 添加pan手势, 防止视图响应scrollview的滚动手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:pan];
        self.frame = CGRectMake(0, 0, kXYMenuScreenWidth, kXYMenuScreenHeight);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.menuView];
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    if ([pan.view isKindOfClass:[XYMenu class]]) {
        return ;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![self isInMenuViewWithPoint:point]) {
        [self dismissXYMenu];
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
        [menu dismissXYMenu];
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

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC  withItemClickIndex:(ItemClickIndexBlock)block
{
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat statusHeight = statusRect.size.height;
    CGFloat navigationBarHeight =  currentNavVC.navigationBar.bounds.size.height;
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    switch (menuType) {
        case XYMenuLeftNavBar:
        {
            self.menuInitRect = CGRectMake(10 + (XYMenuWidth / 4), statusHeight + navigationBarHeight, 1, 1);
            self.menuResultRect = CGRectMake(10, statusHeight + navigationBarHeight, XYMenuWidth, XYMenuHeight);
        }
            break;
        case XYMenuRightNavBar:
        {
            self.menuInitRect = CGRectMake(kXYMenuScreenWidth - (XYMenuWidth / 4) - 10, statusHeight + navigationBarHeight, 1, 1);
            self.menuResultRect = CGRectMake(kXYMenuScreenWidth - XYMenuWidth - 10, statusHeight + navigationBarHeight, XYMenuWidth, XYMenuHeight);
        }
            break;
        default:
            break;
    }
    [currentNavVC.view addSubview:self];
    [self showAnimateMenuWithImages:imagesArr titles:titles menuType:menuType withBlock:block];
    
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [self configRectWithMenuType:menuType inView:view titles:titles];
    [self showAnimateMenuWithImages:imagesArr titles:titles menuType:menuType withBlock:block];
}

- (void)showAnimateMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType withBlock:(ItemClickIndexBlock)block
{
    __weak typeof(self) weakSelf = self;
    [self.menuView setImagesArr:imagesArr titles:titles withRect:self.menuResultRect withMenuType:menuType isDown:_isDown withItemClickBlock:^(NSInteger index) {
        [weakSelf dismissXYMenu];
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

- (void)dismissXYMenu
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

- (void)configRectWithMenuType:(XYMenuType)menuType inView:(UIView *)view titles:(NSArray *)titles
{
    _menuType = menuType;
    UIView *vcView = [XYMenu rootViewFromSubView:view];
    UIView *superView = view.superview;
    CGRect viewRect = view.frame;
    CGRect viewRectFromWindow = [superView convertRect:viewRect toView:vcView];
    CGFloat midX = CGRectGetMidX(viewRectFromWindow);
    CGFloat maxY = CGRectGetMaxY(viewRectFromWindow);
    CGFloat minY = CGRectGetMinY(viewRectFromWindow);
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    
    
//    UIScrollView *viewScrollView = [XYMenu scrollViewFromView:view];
//    if ((viewScrollView && ((maxY + XYMenuHeight + 5 - viewScrollView.contentOffset.y) > kXYMenuScreenHeight)) || (!viewScrollView && ((maxY + XYMenuHeight + 5) > kXYMenuScreenHeight))) {
//        _isDown = NO;
//    }
    
    if ((maxY + XYMenuHeight + 5) > kXYMenuScreenHeight) {
        _isDown = NO;
    }
    
    switch (_menuType) {
        case XYMenuLeftNormal:
        {
            if (_isDown) {
                self.menuInitRect = CGRectMake(midX, maxY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 4), maxY + 5, XYMenuWidth, XYMenuHeight);
            }else {
                self.menuInitRect = CGRectMake(midX, minY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 4), minY - 5 - XYMenuHeight, XYMenuWidth, XYMenuHeight);
            }
        }
            break;
        case XYMenuRightNormal:
        {
            if (_isDown) {
                self.menuInitRect = CGRectMake(midX, maxY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth * 3 / 4), maxY + 5, XYMenuWidth, XYMenuHeight);
            }else {
                self.menuInitRect = CGRectMake(midX, minY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth * 3 / 4), minY - 5 - XYMenuHeight, XYMenuWidth, XYMenuHeight);
            }
            
            break;
        }
        case XYMenuMidNormal:
        {
            if (_isDown) {
                self.menuInitRect = CGRectMake(midX, maxY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
            }else {
                self.menuInitRect = CGRectMake(midX, minY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), minY - 5 - XYMenuHeight, XYMenuWidth, XYMenuHeight);
            }
        }
            break;
            default:
        {
            if (_isDown) {
                self.menuInitRect = CGRectMake(midX, maxY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
            }else {
                self.menuInitRect = CGRectMake(midX, minY, 1, 1);
                self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), minY - 5 - XYMenuHeight, XYMenuWidth, XYMenuHeight);
            }
        }
            break;
    }
    [vcView addSubview:self];
}

- (XYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[XYMenuView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

+ (UIView *)rootViewFromSubView:(UIView *)view
{
    UIViewController *vc = nil;
    UIResponder *next = view.nextResponder;
    do {
         if ([next isKindOfClass:[UINavigationController class]]) {
            vc = (UIViewController *)next;
            break ;
        }
        next = next.nextResponder;
    } while (next != nil);
    if (vc == nil) {
        next = view.nextResponder;
        do {
            if ([next isKindOfClass:[UIViewController class]] || [next isKindOfClass:[UITableViewController class]]) {
                vc = (UIViewController *)next;
                break ;
            }
            next = next.nextResponder;
        } while (next != nil);
    }
    return vc.view;
}

+ (UIScrollView *)scrollViewFromView:(UIView *)view
{
    UIScrollView *scroView = nil;
    UIResponder *next = view.nextResponder;
    do {
        if ([next isKindOfClass:[UIScrollView class]]) {
            scroView = (UIScrollView *)next;
            break ;
        }
        next = next.nextResponder;
    } while (next != nil);
    return scroView;
}

@end
