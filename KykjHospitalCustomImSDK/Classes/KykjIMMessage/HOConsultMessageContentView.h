//
//  HOConsultMessageContentView.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/3.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HOConsultMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface HOConsultMessageContentView : UIView

@property (strong, nonatomic) HOConsultMessage * message;

+ (CGFloat)getContentViewSizeWith:(CGFloat)width message:(HOConsultMessage *)message;

@end

NS_ASSUME_NONNULL_END
