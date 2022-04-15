//
//  KYKJViewController.m
//  KykjHospitalCustomImSDK
//
//  Created by liangyujuan on 02/23/2022.
//  Copyright (c) 2022 liangyujuan. All rights reserved.
//

#import "KYKJViewController.h"
#import "TYMemberSearchDetailViewController.h"

@interface KYKJViewController ()

@end

@implementation KYKJViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"测试";
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
   

    
    // Do any additional setup after loading the view.
}
- (void)tapAction
{
    TYMemberSearchDetailViewController *vc = [[TYMemberSearchDetailViewController alloc] init];
    vc.searchString = @"320826198909270810";
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
