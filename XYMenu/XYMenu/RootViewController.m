//
//  RootViewController.m
//  XYMenu
//
//  Created by FireHsia on 2018/2/2.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "RootViewController.h"
#import "UIBarButtonItem+XYMenu.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XYMenu dismissMenuInView:self.view];;
}

- (IBAction)leftBar:(id)sender {
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];
    [item xy_showMenuWithImages:imageArr titles:titleArr menuType:XYMenuLeftNavBar currentNavVC:self.navigationController withItemClickIndex:^(NSInteger index) {
        [self showMessage:index];
    }];
    
}
- (IBAction)rightBar:(id)sender {
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];
    [item xy_showMenuWithImages:imageArr titles:titleArr menuType:XYMenuRightNavBar currentNavVC:self.navigationController withItemClickIndex:^(NSInteger index) {
        [self showMessage:index];
    }];
}



- (void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showMessage:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self showAlertMessage:@"扫一扫"];
        }
            break;
        case 2:
        {
            [self showAlertMessage:@"拍   照"];
        }
            break;
        case 3:
        {
            [self showAlertMessage:@"付款码"];
        }
            break;
        default:
            break;
    }
}






@end
