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

static const CGFloat XYMenuWidth = 138;
static const CGFloat XYMenuItemHeight = 60;

@interface XYMenu ()

@property (nonatomic, strong) UIView *backView; // 背景View
@property (nonatomic, strong) XYMenuView *menuView; // 展示的菜单View

@end

@implementation XYMenu

+ (instancetype)shareMenu
{
    static dispatch_once_t onceToken;
    static XYMenu *menu = nil;
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
+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles onView:(UIView *)view
{
    [[self shareMenu] showMenuWithImages:imagesArr titles:titles onView:view];
}

#pragma mark --- 隐藏菜单
+ (void)dismissMenu
{
    [[XYMenu shareMenu] dimissXYMenu:nil];
}

- (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles onView:(UIView *)view
{
    UIView *vcView = [self rootViewFromSubView:view];
    CGRect viewRect = view.frame;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect viewRectFromWindow = [vcView convertRect:viewRect toView:keyWindow];
    CGFloat midX = CGRectGetMidX(viewRectFromWindow);
    CGFloat maxY = CGRectGetMaxY(viewRectFromWindow);
    CGFloat XYMenuHeight = XYMenuItemHeight * titles.count;
    
    self.menuView.frame = CGRectMake(midX - (XYMenuWidth / 2), maxY + 5, XYMenuWidth, XYMenuHeight);
    [self.menuView setImagesArr:imagesArr titles:titles];
    [vcView addSubview:self.backView];
}

- (void)dimissXYMenu:(UITapGestureRecognizer *)tap
{
    [self.backView removeFromSuperview];
}

#pragma mark --- LoadView
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = CGRectMake(0, 0, kXYMenuScreenWidth, kXYMenuScreenHeight);
        _backView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *backTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimissXYMenu:)];
        [_backView addGestureRecognizer:backTapGesture];
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
