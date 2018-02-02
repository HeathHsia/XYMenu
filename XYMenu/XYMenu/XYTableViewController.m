//
//  XYTableViewController.m
//  XYMenu
//
//  Created by FireHsia on 2018/1/27.
//  Copyright © 2018年 FireHsia. All rights reserved.
//

#import "XYTableViewController.h"
#import "UIView+XYMenu.h"

@interface XYTableViewController ()

@end

@implementation XYTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delaysContentTouches = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [XYMenu dismissMenuInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYCell" forIndexPath:indexPath];
    return cell;
}


- (IBAction)leftCellMenu:(id)sender {
    
    [self showMenu:(UIView *)sender menuType:XYMenuLeftNormal];
}
- (IBAction)midCellMenu:(id)sender {
    [self showMenu:(UIView *)sender menuType:XYMenuMidNormal];
}

- (IBAction)rightCellMenu:(id)sender {
    [self showMenu:(UIView *)sender menuType:XYMenuRightNormal];
}

- (void)showAlertMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)showMenu:(UIView *)sender menuType:(XYMenuType)menuType
{
    NSArray *imageArr = @[@"swap", @"selected", @"code"];
    NSArray *titleArr = @[@"扫一扫", @"拍    照", @"付款码"];
    [sender xy_showMenuWithImages:imageArr titles:titleArr menuType:menuType withItemClickIndex:^(NSInteger index) {
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


@end
