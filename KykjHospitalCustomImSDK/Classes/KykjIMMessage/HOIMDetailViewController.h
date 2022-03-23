//
//  HOIMDetailViewController.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/1.
//  Copyright © 2020 cc. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "HOIMConsultMsgExtraModel.h"
#import "TYMemberModel.h"

@class TRTCCloud;

NS_ASSUME_NONNULL_BEGIN
@class YXOrderRecordModel,HOIMMsgExtraModel;
@interface HOIMDetailViewController : RCConversationViewController

@property (nonatomic) BOOL isNeedPopTargetViewController;
//聊天对象的userinfo
@property (strong, nonatomic) RCUserInfo * targetUserInfo;
@property (strong, nonatomic) HOIMMsgExtraModel * extraModel;
@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (nonatomic, copy) NSString *myRoomId;

@property (nonatomic, strong) TYMemberModel *model;

@property (nonatomic, assign) BOOL isStartVideo;


@end

NS_ASSUME_NONNULL_END
