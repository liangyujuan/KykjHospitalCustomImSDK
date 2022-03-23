//
//  TYReportDetailViewController.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/13.
//  Copyright © 2022 cc. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXOrderRecordModel.h"
#import "EMRRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYReportDetailViewController : YXBaseViewController

@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *sourceArray;

@property (nonatomic, strong) EMRRecordModel *emrModel;

@end

NS_ASSUME_NONNULL_END
