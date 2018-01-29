//
//  XYMenu.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYMenuView;

typedef enum : NSUInteger {
    XYMenuLeftNavBar,
    XYMenuRightNavBar,
    XYMenuNormal,
    XYMenuLeftTopNormal,
    XYMenuMidTopNormal,
    XYMenuRightTopNormal,
    XYMenuLeftDownNormal,
    XYMenuMidDownNormal,
    XYmenuRightDownNormal,
} XYMenuType;

typedef void(^ItemClickIndexBlock)(NSInteger index);

@interface XYMenu : NSObject

+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block;

+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inBarButtonItem:(UIBarButtonItem *)barButtonItem menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block;

+ (void)dismissMenu;

+ (BOOL)isInMenuViewWithPoint:(CGPoint)point;

@end
