//
//  UIView+XYMenu.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/31.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMenu.h"

@interface UIView (XYMenu)

/**
 View Show XYMenu
 @param imagesArr 图片
 @param titles 标题
 @param menuType 菜单类型( XYMenuLeftNormal,XYMenuMidNormal,XYMenuRightNormal)
 @param block 回调Block
 */
- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block;

@end
