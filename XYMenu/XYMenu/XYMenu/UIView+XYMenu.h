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

- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block;

@end
