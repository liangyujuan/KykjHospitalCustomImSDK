//
//  DiagnosisPreviewHeader.h
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Factory.h"
#import "EMRRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiagnosisPreviewHeader : UIView

@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (nonatomic, strong) EMRRecordModel *emrModel;

@end

NS_ASSUME_NONNULL_END
