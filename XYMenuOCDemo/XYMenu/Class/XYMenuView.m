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
static const CGFloat kTriangleHeight = 10;

@interface XYMenuView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, assign) XYMenuType menuType;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, copy) ItemClickBlock itemClickBlock;

@end

@implementation XYMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isDown = YES;
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

- (void)setImagesArr:(NSArray *)imagesArr titles:(NSArray *)titles withRect:(CGRect)rect withMenuType:(XYMenuType)menuType isDown:(BOOL)isDown withItemClickBlock:(ItemClickBlock)block
{
    _isDown = isDown;
    _menuType = menuType;
    _imagesArr = [NSArray arrayWithArray:imagesArr];
    _titlesArr = [NSArray arrayWithArray:titles];
    [self setMenuItemsWithRect:(CGRect)rect];
    if (block) {
        _itemClickBlock = block;
    }
    [self setNeedsDisplay];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat kContentWidth = self.bounds.size.width;
    CGFloat kContentHeight = self.bounds.size.height;
    CGFloat kContentMidX = CGRectGetMidX(self.bounds);
    CGFloat triangleX;
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    if (_isDown) {
        switch (_menuType) {
            case XYMenuLeftNormal:
            case XYMenuLeftNavBar:
            {
                triangleX = (kContentWidth / 4) - (kTriangleLength / 2);
            }
                break;
            case XYMenuRightNormal:
            case XYMenuRightNavBar:
            {
                triangleX = kContentMidX + (kContentWidth / 4) - (kTriangleLength / 2);
            }
                break;
            default:
                triangleX = kContentMidX - (kTriangleLength / 2);
                break;
        }
        
        [trianglePath moveToPoint:CGPointMake(triangleX, kTriangleHeight)];
        [trianglePath addLineToPoint:CGPointMake(triangleX + (kTriangleLength / 2), 0)];
        [trianglePath addLineToPoint:CGPointMake(triangleX + kTriangleLength, kTriangleHeight)];
    }else {
        switch (_menuType) {
            case XYMenuLeftNormal:
            case XYMenuLeftNavBar:
            {
                triangleX = (kContentWidth / 4) - (kTriangleLength / 2);
            }
                break;
            case XYMenuRightNormal:
            case XYMenuRightNavBar:
            {
                triangleX = kContentMidX + (kContentWidth / 4) - (kTriangleLength / 2);
            }
                break;
            default:
                triangleX = kContentMidX - (kTriangleLength / 2);
                break;
        }
        [trianglePath moveToPoint:CGPointMake(triangleX, kContentHeight - kTriangleHeight)];
        [trianglePath addLineToPoint:CGPointMake(triangleX + (kTriangleLength / 2), kContentHeight)];
        [trianglePath addLineToPoint:CGPointMake(triangleX + kTriangleLength, kContentHeight - kTriangleHeight)];
    }
    
    [kXYMenuContentBackColor set];
    [trianglePath fill];
    
    if (_isDown) {
        UIBezierPath *radiusPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, kTriangleHeight, self.bounds.size.width, self.bounds.size.height - kTriangleHeight) cornerRadius:5];
        [kXYMenuContentBackColor set];
        [radiusPath fill];
    }else {
        UIBezierPath *radiusPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kTriangleHeight) cornerRadius:5];
        [kXYMenuContentBackColor set];
        [radiusPath fill];
    }
    
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
        itemBtn.backgroundColor = [UIColor clearColor];
        itemBtn.layer.cornerRadius = 5;
        itemBtn.layer.masksToBounds = YES;
        itemBtn.tag = kItemBtnTag + i;
        [itemBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemBtn];
        XYMenuItem *item = [[XYMenuItem alloc] initWithIconName:self.imagesArr[i] title:self.titlesArr[i]];
        item.userInteractionEnabled = NO;
        [self.contentView addSubview:item];
        if (_isDown) {
            [item setUpViewsWithRect:CGRectMake(0, (i * kContentItemHeight) + kTriangleHeight, menuContentWidth, kContentItemHeight)];
            itemBtn.frame = CGRectMake(0, (i * kContentItemHeight)+ kTriangleHeight , menuContentWidth, kContentItemHeight);
            if (i != 0) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.cornerRadius = 0.5;
                lineLayer.backgroundColor = kXYMenuContentLineColor.CGColor;
                lineLayer.frame = CGRectMake((kContentItemHeight / 3) - 4, (i * kContentItemHeight) + kTriangleHeight - 1, menuContentWidth - (kContentItemHeight * 2 / 3) + 8, 0.5);
                [self.contentView.layer addSublayer:lineLayer];
            }
        }else {
            [item setUpViewsWithRect:CGRectMake(0, (i * kContentItemHeight), menuContentWidth, kContentItemHeight)];
            itemBtn.frame = CGRectMake(0, (i * kContentItemHeight), menuContentWidth, kContentItemHeight);
            if (i != 0) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.cornerRadius = 0.5;
                lineLayer.backgroundColor = kXYMenuContentLineColor.CGColor;
                lineLayer.frame = CGRectMake((kContentItemHeight / 3) - 4, (i * kContentItemHeight) - 1, menuContentWidth - (kContentItemHeight * 2 / 3) + 8, 0.5);
                [self.contentView.layer addSublayer:lineLayer];
            }
        }
        UIImage *buttonHighlightedImage = [self buttonHighlightedImageWithSize:itemBtn.bounds.size];
        [itemBtn setImage:buttonHighlightedImage forState:UIControlStateHighlighted];
    }
}

- (UIImage *)buttonHighlightedImageWithSize:(CGSize)size
{
    UIImage *hightImage = [UIImage new];
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
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

