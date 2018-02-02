//
//  ViewController.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/18.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "ViewController.h"
#import "UIView+XYMenu.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *clickButton;

@property (nonatomic, strong) UIView *contentV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [XYMenu dismissMenuInView:self.view];;
}

- (IBAction)alertLeftMenu:(id)sender {
    [self showMenu:(UIView *)sender menuType:XYMenuLeftNormal];
}
- (IBAction)alertMidMenu:(id)sender {
    [self showMenu:(UIView *)sender menuType:XYMenuMidNormal];
}
- (IBAction)alertRightMenu:(id)sender {
    [self showMenu:(UIView *)sender menuType:XYMenuRightNormal];
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

- (void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)showMenu:(UIView *)sender menuType:(XYMenuType)type
{
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];
    [sender xy_showMenuWithImages:imageArr titles:titleArr menuType:type withItemClickIndex:^(NSInteger index) {
        [self showMessage:index];
    }];
   
}





@end
