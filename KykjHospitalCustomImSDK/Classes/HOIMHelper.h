//
//  HOIMHelper.h
//  ystdoctor
//
//  Created by yunxin on 2017/5/3.
//  Copyright © 2017年 adtech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HOIMConsultMsgExtraModel.h"
#import "TYMemberModel.h"
#import "Factory.h"


//@import TXLiteAVSDK_TRTC;
//@import ImSDK;
////@import RongIMKit;
//@import RongIMLib;

@class YXPatientRecordsModel,YXOrderRecordModel;
@interface HOIMHelper : NSObject

///音视频sig
@property (copy, nonatomic) NSString * userSig;
@property (copy, nonatomic) NSString * userId;

+ (HOIMHelper *)shareInstance ;

/**
 初始化
 */
- (void)initWithAppKey:(NSString*)rongYunIMAppKey;

/// 更新融云信息
- (void)rongYunLoginSuccessSetHeaderImageWithUserModel:(TYMemberModel*)userModel;

//MARK: - 链接融云服务器
- (void)connectRongYunIMServerWithUserModel:(TYMemberModel*)userModel;

//MARK: - 链接融云服务器---带回调
//- (void)connectRongYunIMServerWithUserModel:(TYMemberModel*)userModel success:(void(^)(NSString *userID))successBlock
//                                  witFaile:(void(^)(RCConnectErrorCode status))faileBlock
//                              withOverDate:(void(^)(BOOL isOverDate))overDateBlock;


//MARK: - 配置融云的一些其他信息
/*
 @param launchOptions
 **/
- (void)rongYunConfig:(NSDictionary *)launchOptions timSDKAppId:(int)timSDKAppId withDelegate:(id)delegate;
- (void)refreshUserInfoWithTargetId:(NSString *)targetId;
- (void)refreshUserInfoWithTargetId:(NSString *)targetId andName:(NSString *)name;
//-(void)checkUserOnWithUserId:(NSString *)userId  andName:(NSString *)name completion:(void (^)(RCUserInfo *userInfo))completion;
/**
 跳转到聊天界面

 @param userID 用户ID
 @param navigationController NavigationController
 @param titleString 名称
 @param userAction 是否允许用户操作
 @param consultId 咨询ID
 */
//- (void)pushChatPageViewController:(NSString *)userID
//          withNavigationController:(UINavigationController *)navigationController
//                         withTitle:(NSString *)titleString
//                withHeaderImageUrl:(NSString *)headerImageUrl
//                    withUserAction:(BOOL)userAction
//                     withConsultId:(NSString *)consultId
//                      withOpration:(void(^)(BOOL isSuccess, id info))backOpration;
//
//

/**
 断开融云链接
 */
- (void)disContent;


@end
