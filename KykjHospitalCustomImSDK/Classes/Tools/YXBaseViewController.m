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

@property (nonatomic, strong) UIView *stateBgView;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *titleLabel;

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
    
    self.stateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatuBarHeight)];
    self.stateBgView.backgroundColor = colorBackground;
    [self.view addSubview:self.stateBgView];
    
    self.navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, StatuBarHeight, ScreenWidth, 44)];
    self.navBarView.backgroundColor = colorBackground;
    [self.view addSubview:self.navBarView];

    
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [left setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftItemSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_leftButton];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2, 0, ScreenWidth-200, 44)];
    _titleLabel.text = @"";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.navBarView addSubview:_titleLabel];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 0, 100, 44)];
//    [_right setImage:[UIImage imageNamed:@"M_setting_ic"] forState:UIControlStateNormal];
    [_rightButton setTitle:@"" forState:UIControlStateNormal];
    [_rightButton setTitleColor:RGB(1, 111, 255) forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton addTarget:self action:@selector(rightBarButtonItemPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:_rightButton];
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

- (void)rightBarButtonItemPressed
{
    
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
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:colorBackground];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar lt_reset];
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

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}
- (void)setNavBgColor:(UIColor *)navBgColor
{
    _navBarView.backgroundColor = navBgColor;
    _stateBgView.backgroundColor = navBgColor;
}
- (void)setLeftTitle:(NSString *)leftTitle
{
    [_leftButton setTitle:leftTitle forState:UIControlStateNormal];
}
- (void)setRightTitle:(NSString *)rightTitle
{
    [_rightButton setTitle:rightTitle forState:UIControlStateNormal];
}
- (void)setLeftImage:(NSString *)leftImage
{
   [_leftButton setImage:[KykjImToolkit getImageResourceForName:leftImage] forState:UIControlStateNormal];
}
- (void)setRightImage:(NSString *)rightImage
{
    [_rightButton setImage:[KykjImToolkit getImageResourceForName:rightImage] forState:UIControlStateNormal];
}

@end
