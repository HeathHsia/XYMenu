//
//  XYMenu.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/26.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemClickIndexBlock)(NSInteger index);

@interface XYMenu : NSObject

+ (void)showMenuWithImages:(NSArray *)imagesArr titles:(NSArray *)titles inView:(UIView *)view withItemClickIndex:(ItemClickIndexBlock)block;

+ (void)dismissMenu;

@end
