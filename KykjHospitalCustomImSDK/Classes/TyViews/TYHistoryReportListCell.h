//
//  TYHistoryReportListCell.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/13.
//  Copyright © 2022 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMRRecordModel.h"
#import "YXPatientRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHistoryReportListCell : UITableViewCell

@property (nonatomic, strong) EMRRecordModel *emrNetModel;

@end

NS_ASSUME_NONNULL_END
