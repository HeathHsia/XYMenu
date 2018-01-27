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
    
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];

    [XYMenu showMenuWithImages:imageArr titles:titleArr inView:sender withItemClickIndex:^(NSInteger index) {
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
    }];
   
}

- (void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}



@end
