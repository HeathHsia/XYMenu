//
//  XYMenuView.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/18.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYMenuView.h"
#import "XYMenuItem.h"

#define kXYMenuContentBackColor [UIColor colorWithWhite:0.4 alpha:1.0]
#define kXYMenuContentLineColor [UIColor colorWithWhite:0.7 alpha:1.0]

#define kItemBtnTag 1001

static const CGFloat kTriangleLength = 16;
static const CGFloat kTriangleHeight = 10;

@interface XYMenuView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, copy) ItemClickBlock itemClickBlock;

@end

@implementation XYMenuView

#pragma mark --- 共通初始化方法

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.contentView];
        self.contentView.frame = frame;
        self.layer.shadowRadius = 2;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 1;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
    return self;
}

- (void)setImagesArr:(NSArray *)imagesArr titles:(NSArray *)titles withRect:(CGRect)rect withItemClickBlock:(ItemClickBlock)block
{
    _imagesArr = [NSArray arrayWithArray:imagesArr];
    _titlesArr = [NSArray arrayWithArray:titles];
    [self setMenuItemsWithRect:(CGRect)rect];
    if (block) {
        _itemClickBlock = block;
    }
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat kContentWidth = self.bounds.size.width;
//    CGFloat kContentHeight = self.bounds.size.height;
    CGFloat kContentMidX = CGRectGetMidX(self.bounds);
    CGFloat triangleX = kContentMidX + (kContentWidth / 4) - (kTriangleLength / 2);
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(triangleX, kTriangleHeight)];
    [trianglePath addLineToPoint:CGPointMake(triangleX + (kTriangleLength / 2), 0)];
    [trianglePath addLineToPoint:CGPointMake(triangleX + kTriangleLength, kTriangleHeight)];
    [kXYMenuContentBackColor set];
    [trianglePath fill];
    
    UIBezierPath *radiusPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, kTriangleHeight, self.bounds.size.width, self.bounds.size.height - kTriangleHeight) cornerRadius:5];
    [kXYMenuContentBackColor set];
    [radiusPath fill];
    
}

- (void)btnAction:(UIButton *)sender
{
    if (_itemClickBlock) {
        _itemClickBlock(sender.tag - 1000);
    }
}

- (void)showContentView
{
    self.contentView.hidden = NO;
    self.contentView.frame = self.bounds;
}

- (void)hideContentView
{
    self.contentView.hidden = YES;
}

#pragma mark --- 创建Items
- (void)setMenuItemsWithRect:(CGRect)rect
{
    NSArray *subViews = self.contentView.subviews;
    for (UIView *subV in subViews) {
        [subV removeFromSuperview];
    }
    CGFloat menuContentWidth = rect.size.width;
    CGFloat menuContentHeight = rect.size.height;

    NSInteger count = self.titlesArr.count;
    CGFloat kContentItemHeight = (menuContentHeight - kTriangleHeight) / count;
    for (int i = 0; i < count; i++) {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(0, (i * kContentItemHeight)+ kTriangleHeight , menuContentWidth, kContentItemHeight);
        itemBtn.backgroundColor = [UIColor clearColor];
        UIImage *buttonHighlightedImage = [self buttonHighlightedImageWithSize:itemBtn.bounds.size];
        [itemBtn setImage:buttonHighlightedImage forState:UIControlStateHighlighted];
        itemBtn.tag = kItemBtnTag + i;
        [itemBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemBtn];
        
        XYMenuItem *item = [[XYMenuItem alloc] initWithFrame:CGRectMake(0, (i * kContentItemHeight) + kTriangleHeight, menuContentWidth, kContentItemHeight) withIconName:self.imagesArr[i] title:self.titlesArr[i]];
        item.userInteractionEnabled = NO;
        if (i != 0) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake((kContentItemHeight / 3) - 4, (i * kContentItemHeight) + kTriangleHeight - 1, menuContentWidth - (kContentItemHeight * 2 / 3) + 8, 0.5);
            lineLayer.cornerRadius = 0.5;
            lineLayer.backgroundColor = kXYMenuContentLineColor.CGColor;
            [self.contentView.layer addSublayer:lineLayer];
        }
        [self.contentView addSubview:item];
    }
}

- (UIImage *)buttonHighlightedImageWithSize:(CGSize)size
{
    UIImage *hightImage = [UIImage new];
    UIGraphicsBeginImageContext(size);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5];
    [[UIColor colorWithWhite:0.3 alpha:1.0] set];
    [bezierPath fill];
    hightImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return hightImage;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}





@end
