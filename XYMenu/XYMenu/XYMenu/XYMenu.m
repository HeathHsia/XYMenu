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

static const CGFloat XYMenuWidth = 120; // Menu宽度
static const CGFloat XYMenuItemHeight = 60; // item高度

static  XYMenu *menu;

@interface XYMenu ()

@property (nonatomic, strong) XYMenuBackView *backView; // 背景View
@property (nonatomic, strong) XYMenuView *menuView; // 展示的菜单View
@property (nonatomic, assign) CGRect menuInitRect;
@property (nonatomic, assign) CGRect menuResultRect;

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
        [self.backView addSubview:self.menuView];
    }
    return self;
}

#pragma mark --- 展示菜单
+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view withItemClickIndex:(ItemClickIndexBlock)block
{
    [[self shareMenu] showMenuWithImages:imagesArr titles:titles inView:view withItemClickIndex:block];
}

#pragma mark --- 隐藏菜单
+ (void)dismissMenu
{
    [[XYMenu shareMenu] dimissXYMenu];
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view withItemClickIndex:(ItemClickIndexBlock)block
{
    UIView *vcView = [self rootViewFromSubView:view];
    CGRect viewRect = view.frame;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect viewRectFromWindow = [vcView convertRect:viewRect toView:keyWindow];
    CGFloat midX = CGRectGetMidX(viewRectFromWindow);
    CGFloat maxX = CGRectGetMaxX(viewRectFromWindow);
    CGFloat maxY = CGRectGetMaxY(viewRectFromWindow);
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    self.menuInitRect = self.menuView.frame = CGRectMake(maxX, maxY, 1, 1);
    self.menuResultRect = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
    
    __weak typeof(self) weakSelf = self;
    [self.menuView setImagesArr:imagesArr titles:titles withRect:self.menuResultRect withItemClickBlock:^(NSInteger index) {
        [weakSelf dimissXYMenu];
        block(index);
    }];
    [vcView addSubview:self.backView];
    
    [self.menuView hideContentView];
    self.menuView.alpha = 0.1;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.alpha = 1.0;
        self.menuView.frame = self.menuResultRect;
    } completion:^(BOOL finished) {
        [self.menuView showContentView];
    }];
    
}

- (void)dimissXYMenu
{
    [self.menuView hideContentView];
    self.menuView.alpha = 1.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.frame = self.menuInitRect;
        self.menuView.alpha = 0.1;
    } completion:^(BOOL finished) {
         [self.backView removeFromSuperview];
    }];
    
}

#pragma mark --- LoadView
- (XYMenuBackView *)backView
{
    if (!_backView) {
        _backView = [[XYMenuBackView alloc] init];
        _backView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
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

#pragma mark --- 返回当前View的控制器的view
- (UIView *)rootViewFromSubView:(UIView *)view
{
    UIViewController *vc = [UIViewController new];
    UIResponder *next = view.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    } while (next != nil);
    return vc.view;
}

@end
