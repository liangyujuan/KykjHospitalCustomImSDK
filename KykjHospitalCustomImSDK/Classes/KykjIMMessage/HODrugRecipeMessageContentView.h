//
//  HODrugRecipeMessageContentView.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOMedrMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface HODrugRecipeMessageContentView : UIView

@property (strong, nonatomic) HOMedrMessage * message;


+ (CGFloat)getContentViewSizeWith:(CGFloat)width message:(HOMedrMessage *)message;

@end

NS_ASSUME_NONNULL_END
