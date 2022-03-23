//
//  KYTRTCVideoCallingViewController.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/2/25.
//  Copyright © 2022 cc. All rights reserved.
//

#import "YXBaseViewController.h"
#import "YXOrderRecordModel.h"

@class TRTCCalling,TRTCCloud;

NS_ASSUME_NONNULL_BEGIN

@protocol KYTRTCVideoCallingViewControllerDelegate <NSObject>

- (void)hungUpDelegateActionWithType:(NSString *)type;//1-医生挂断 2-患者挂断

- (void)minizeDelegateAction:(BOOL)isMin;

@end

@interface KYTRTCVideoCallingViewController : YXBaseViewController

@property (nonatomic, weak) id<KYTRTCVideoCallingViewControllerDelegate>delegate;

@property (nonatomic, strong) UIButton * hungUpButton;//挂断
@property (nonatomic, strong) UIButton * speakerButton;//免提
@property (nonatomic, strong) UIButton * muteButton;//静音
@property (nonatomic, strong) UIButton * minimizeButton;//最小化
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *waiteHungButton;

@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (strong, nonatomic) TRTCCloud *trtcCloud;

- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId;

- (void)stopAndQuit;

@end

NS_ASSUME_NONNULL_END
