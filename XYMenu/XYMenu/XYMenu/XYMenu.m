//
//  XYMenu.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenu.h"
#import "XYMenuView.h"
#import "XYMenuBackView.h"

#define kXYMenuScreenWidth [UIScreen mainScreen].bounds.size.width
#define kXYMenuScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat XYMenuWidth = 120; // Menu宽度
static const CGFloat XYMenuItemHeight = 60; // item高度

static  XYMenu *menu;

@interface XYMenu ()

@property (nonatomic, strong) XYMenuBackView *backView;
@property (nonatomic, strong) XYMenuView *menuView;
@property (nonatomic, assign) XYMenuType menuType;
@property (nonatomic, assign) CGRect menuInitRect;
@property (nonatomic, assign) CGRect menuResultRect;
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation XYMenu

+ (instancetype)shareMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[XYMenu alloc] init];
    });
    return menu;
}

- (instancetype)init
{
    if (self = [super init]) {
        _isDismiss = NO;
        _menuType = XYMenuNormal;
        [self.backView addSubview:self.menuView];
    }
    return self;
}

#pragma mark --- 展示菜单
+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [[self shareMenu] showMenuWithImages:imagesArr titles:titles inView:view menuType:menuType withItemClickIndex:block];
}

+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inBarButtonItem:(UIBarButtonItem *)barButtonItem menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [[self shareMenu] showMenuWithImages:imagesArr titles:titles inBarButtonItem:barButtonItem menuType:menuType withItemClickIndex:block];
}

#pragma mark --- 隐藏菜单
+ (void)dismissMenu
{
    [[XYMenu shareMenu] dimissXYMenu];
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
        [self.backView removeFromSuperview];
    }];
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inBarButtonItem:(UIBarButtonItem *)barButtonItem menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [self configRectWithMenuType:menuType inView:view titles:titles];
    __weak typeof(self) weakSelf = self;
    [self.menuView setImagesArr:imagesArr titles:titles withRect:self.menuResultRect withItemClickBlock:^(NSInteger index)
    {
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
    UIView *vcView = [self rootViewFromSubView:view];
    UIView *superView = view.superview;
    CGRect viewRect = view.frame;
    CGRect viewRectFromWindow = [superView convertRect:viewRect toView:keyWindow];
    
    CGFloat midX = CGRectGetMidX(viewRectFromWindow);
    CGFloat maxX = CGRectGetMaxX(viewRectFromWindow);
    CGFloat maxY = CGRectGetMaxY(viewRectFromWindow);
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    self.menuInitRect = CGRectMake(maxX, maxY, 1, 1);
    self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
    [vcView addSubview:self.backView];
}

#pragma mark --- LoadView
- (XYMenuBackView *)backView
{
    if (!_backView) {
        _backView = [[XYMenuBackView alloc] init];
        _backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _backView.userInteractionEnabled = YES;
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

- (XYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[XYMenuView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

+ (BOOL)isInMenuViewWithPoint:(CGPoint)point
{
    return [[XYMenu shareMenu] isInMenuViewWithPoint:point];
}

- (BOOL)isInMenuViewWithPoint:(CGPoint)point
{
    CGPoint menuVPoint = [self.backView convertPoint:point toView:self.menuView];
    return [self.menuView pointInside:menuVPoint withEvent:nil];
}

#pragma mark --- 返回当前View的控制器的view
- (UIView *)rootViewFromSubView:(UIView *)view
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
