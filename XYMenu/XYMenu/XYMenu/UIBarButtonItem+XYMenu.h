//
//  UIBarButtonItem+XYMenu.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/29.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYMenu.h"

@interface UIBarButtonItem (XYMenu)

- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC withItemClickIndex:(ItemClickIndexBlock)block;

@end
