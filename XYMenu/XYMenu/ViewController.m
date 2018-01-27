//
//  ViewController.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/18.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "ViewController.h"
#import "XYMenu.h"

@interface ViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *clickButton;

@property (nonatomic, strong) UIView *contentV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_clickButton setTitle:@"Menu" forState:UIControlStateSelected];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XYMenu dismissMenu];
}

- (IBAction)alertMenu:(id)sender {
//    NSArray *imageArr = @[@"swap", @"selected", @"code"];
//    NSArray *titleArr = @[@"扫一扫", @"拍照", @"付款码"];
    NSArray *imageArr = @[@"swap"];
    NSArray *titleArr = @[@"扫一扫"];
    [XYMenu showMenuWithImages:imageArr titles:titleArr onView:sender];
   
}



@end
