//
//  HOIMGroupDetailViewController.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/3.
//  Copyright © 2022 cc. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "HOIMConsultMsgExtraModel.h"
#import "TYMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HOIMGroupDetailViewController : RCConversationViewController

@property (nonatomic) BOOL isNeedPopTargetViewController;
//聊天对象的userinfo
@property (strong, nonatomic) RCUserInfo * targetUserInfo;
@property (strong, nonatomic) HOIMMsgExtraModel * extraModel;
@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;

@property (nonatomic, strong) TYMemberModel *model;

@end

NS_ASSUME_NONNULL_END
