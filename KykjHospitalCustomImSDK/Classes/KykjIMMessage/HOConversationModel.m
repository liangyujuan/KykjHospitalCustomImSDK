//
//  HOConversationModel.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/1.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HOConversationModel.h"
#import "Factory.h"
#import "MJExtension.h"

@implementation HOConversationModel


/**
 
 根据时间判读订单状态是否需要更新。
 
 */
- (BOOL)checkOrderNeedUpdate{
    return [self checkOrderNeedUpdateWith:self.orderRecordModel];
}

- (BOOL)checkOrderNeedUpdateWith:(YXOrderRecordModel *)orderRecord{
    if ([orderRecord.STATUS isEqualToString:@"D"]) {
        //待接诊 判读创建时间24小时
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * creatDate = [dateFormatter dateFromString:orderRecord.CREATE_TIME];
        NSTimeInterval timeInterval = fabs([creatDate timeIntervalSinceNow]);
        if (timeInterval > 24*60*60) {
            return YES;
        }
    }else if ([orderRecord.STATUS isEqualToString:@"C"]){
        if (orderRecord.START_TIME.length == 0) {
            return NO;
        }
        
        //进行中 判读开始时间24小时
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate * startDate = [dateFormatter dateFromString:orderRecord.START_TIME];
        NSTimeInterval timeInterval = fabs([startDate timeIntervalSinceNow]);
        if (timeInterval > 24*60*60) {
            return YES;
        }
    }
    
    NSString * extra;
    if ([self.conversationModel.lastestMessage respondsToSelector:@selector(extra)]) {
         extra = [self.conversationModel.lastestMessage valueForKey:@"extra"];
        if (extra.length > 0) {
            HOIMMsgExtraModel * extraModel = [HOIMMsgExtraModel mj_objectWithKeyValues:[extra mj_JSONString]];
            if (![extraModel.status isEqualToString:orderRecord.STATUS]
                && self.conversationModel.lastestMessageId != orderRecord.messageId) {
                return YES;
            }
        }
    }
    
    return NO;
}
@end
