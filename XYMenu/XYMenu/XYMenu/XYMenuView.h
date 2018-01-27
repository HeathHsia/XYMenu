//
//  XYMenuView.h
//  XYMenu
//
//  Created by FireHsia on 2018/1/18.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemClickBlock)(NSInteger index);

@interface XYMenuView : UIView
- (void)setImagesArr:(NSArray *)imagesArr titles:(NSArray *)titles withRect:(CGRect)rect withItemClickBlock:(ItemClickBlock)block;

- (void)showContentView;

- (void)hideContentView;

@end
