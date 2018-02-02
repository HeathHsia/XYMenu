//
//  UIView+XYMenu.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/31.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "UIView+XYMenu.h"

@implementation UIView (XYMenu)

- (void)xy_showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles menuType:(XYMenuType)menuType withItemClickIndex:(ItemClickIndexBlock)block
{
    [XYMenu showMenuWithImages:imagesArr titles:titles inView:self menuType:menuType withItemClickIndex:block];
}

@end
