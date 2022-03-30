//
//  YXBaseViewController.m
//  YstPatientEdition
//
//  Created by cc_yunxin on 2017/5/16.
//  Copyright © 2017年 adtech. All rights reserved.
//

#import "YXBaseViewController.h"
#import "Factory.h"

@interface YXBaseViewController ()

@property (nonatomic, strong) UIButton *baseRightButton;

/**
 友盟 页面时长统计进行标志
 
 **/
@property (atomic, assign) BOOL isLogPageing;

@end

@implementation YXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
//    [left setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftItemSelector) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setHudQuene:(NSInteger)hudQuene{
    _hudQuene = hudQuene;
    if (hudQuene > 0) {
        MBProgressHUDShowInThisView;
    }else{
//        MBProgressHUDHideAllInThisView(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
}

- (void)leftItemSelector{
    if (self.isNeedPopTargetViewController){
        [self popTargetViewController];
    }else
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popTargetViewController{
    __block UIViewController * targetVC;
    if (self.navigationController.viewControllers.count > 2) {
        NSArray<UIViewController *> * viewControllers = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count-1)];
        
        __block NSInteger tag = 0;
        [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.view.tag >= tag) {
                tag = obj.view.tag;
                targetVC = obj;
            }
        }];
    }
    
    if (targetVC) {
        [self.navigationController popToViewController:targetVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    self.isLogPageing = YES;
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    self.isLogPageing = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:colorBackground];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


 
- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationOverFullScreen;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}
@end
