//
//  EMRPreviewHeaderView.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/8.
//  Copyright © 2022 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXOrderRecordModel.h"
#import "EMRRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EMRPreviewHeaderView : UIView

@property (nonatomic ,strong) YXOrderRecordModel *orderRecordModel;

@property (nonatomic, strong) EMRRecordModel *emrModel;

@end

NS_ASSUME_NONNULL_END
