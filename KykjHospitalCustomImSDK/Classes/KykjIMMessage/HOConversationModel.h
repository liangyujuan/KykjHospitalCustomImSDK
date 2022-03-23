//
//  HOConversationModel.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/1.
//  Copyright © 2020 cc. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "HOIMConsultMsgExtraModel.h"
//#import "SWSMessage.h"

NS_ASSUME_NONNULL_BEGIN
@class YXOrderRecordModel;
@interface HOConversationModel : NSObject

@property (strong, nonatomic) RCConversationModel * conversationModel;
@property (strong, nonatomic) YXOrderRecordModel * orderRecordModel;
@property (strong, nonatomic) HOIMMsgExtraModel * extraModel;

/**
 
 根据时间判读订单状态是否需要更新。
 
 */
- (BOOL)checkOrderNeedUpdate;
- (BOOL)checkOrderNeedUpdateWith:(YXOrderRecordModel *)orderRecord;
@end

NS_ASSUME_NONNULL_END
