//
//  UIBarButtonItem+XYMenu.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/29.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "UIBarButtonItem+XYMenu.h"

@implementation UIBarButtonItem (XYMenu)

- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType currentNavVC:(UINavigationController *)currentNavVC withItemClickIndex:(ItemClickIndexBlock)block
{
    [XYMenu showMenuWithImages:imagesArr titles:titles menuType:menuType currentNavVC:currentNavVC withItemClickIndex:block];
}

@end
