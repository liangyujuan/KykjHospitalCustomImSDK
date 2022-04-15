//
//  YXBaseViewController.h
//  YstPatientEdition
//
//  Created by cc_yunxin on 2017/5/16.
//  Copyright © 2017年 adtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXBaseViewController : UIViewController
 

- (void)leftItemSelector;
- (void)rightBarButtonItemPressed;
- (void)popTargetViewController;

@property (nonatomic) BOOL isNeedPopTargetViewController;
@property (nonatomic) BOOL isNeedLogin;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger hudQuene;

@property (nonatomic, strong) UIView *navBarView;

@property (nonatomic, strong) UIColor *navBgColor;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;

@property (nonatomic, copy) NSString *leftImage;
@property (nonatomic, copy) NSString *rightImage;

@end
