//
//  DiagnosisPreviewFooter.h
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXOrderRecordModel.h"
#import "Factory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiagnosisPreviewFooter : UIView

@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (nonatomic, copy) NSString *adviceStr;

- (instancetype)initWithFrame:(CGRect)frame isRecipe:(BOOL)isRecipe;

@end

NS_ASSUME_NONNULL_END
