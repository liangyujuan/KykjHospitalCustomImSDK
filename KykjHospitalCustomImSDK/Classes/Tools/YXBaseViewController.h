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
- (void)popTargetViewController;

@property (nonatomic) BOOL isNeedPopTargetViewController;
@property (nonatomic) BOOL isNeedLogin;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger hudQuene;
@end
