//
//  HOMedrMessage.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/5/9.
//  Copyright © 2020 cc. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import "HOIMConsultMsgExtraModel.h"

NS_ASSUME_NONNULL_BEGIN


/*!
 测试消息的类型名
 */
#define HOMedrMessageTypeIdentifier @"YST:medrMsg"

@interface HOMedrMessage : RCMessageContent

/*!
 测试消息的内容
 */
@property(nonatomic, strong) NSString *content;

/*!
 测试消息的标题
 */
@property(nonatomic, strong) NSString *title;

/*!
 测试消息的附加信息
 */
@property(nonatomic, strong) NSString *extra;
 
@property(nonatomic, strong) HOIMPreMsgExtraModel * extraModel;
/*!
 初始化测试消息
 
 @param content 文本内容
 @return        测试消息对象
 */
+ (instancetype)messageWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
