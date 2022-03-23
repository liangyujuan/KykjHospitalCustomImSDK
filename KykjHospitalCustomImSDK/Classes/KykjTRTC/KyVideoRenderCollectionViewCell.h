//
//  KyVideoRenderCollectionViewCell.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/2/25.
//  Copyright © 2022 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXOrderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN


@import TXLiteAVSDK_TRTC;

@interface KyVideoRenderCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) TRTCCloud *trtcCloud;

- (void)setCellWithUserId:(NSString *)userId orderUserId:(NSString*)orderUserId;

@end

NS_ASSUME_NONNULL_END
