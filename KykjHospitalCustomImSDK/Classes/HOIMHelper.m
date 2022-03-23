//
//  HOIMHelper.m
//  ystdoctor
//
//  Created by yunxin on 2017/5/3.
//  Copyright © 2017年 adtech. All rights reserved.
//

#import "HOIMHelper.h"
#import <RongIMKit/RongIMKit.h> // 融云的SDK
#import <RongIMLib/RongIMLib.h>
#import "HOConsultMessage.h"
#import "Factory.h"
#import "HOPatientMessage.h"
#import "AmsUser.h"

#import "HOIMConsultMsgExtraModel.h"
#import "HOMedrMessage.h"
#import "NSDate+Extension.h"
#import "YXOrderRecordModel.h"
#import "TRTCCalling.h"
#import "MJExtension.h"

@import TXLiteAVSDK_TRTC;
@import ImSDK;
//@import RongIMK

//static NSString *rongIMAppKey = @"tdrvipkst7w75";//重庆云信

/** 图片地址 host */
static NSString *const  serverImageBase_URL = @"http://t-yxhlwyy.jkscw.com.cn";

/** 默认医生头像 */
static NSString *const  kDefaultStaffIconUrl = @"https://hlwyyv2.jkscw.com.cn/ystresource/img/common_staffimg.png";
/** 默认用户头像 */
static NSString *const  kDefaultUserIconUrl = @"https://hlwyyv2.jkscw.com.cn/ystresource/img/user/20200706/20200706101806524_667.png";



#ifdef HO_ENVIRONMENT_TEST

static NSString *rongIMAppKey = @"pvxdm17jpwysr";

#else

static NSString *rongIMAppKey = @"pvxdm17jpwysr";

#endif


@interface HOIMHelper()<RCIMUserInfoDataSource>

@end

@implementation HOIMHelper

+ (HOIMHelper *)shareInstance {
    static HOIMHelper *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (void)initWithAppKey:(NSString*)rongYunIMAppKey{
    [[RCIM sharedRCIM] initWithAppKey:rongYunIMAppKey];
    // 注册HOMessage
    [[RCIM sharedRCIM] registerMessageType:[HOConsultMessage class]];
    [[RCIM sharedRCIM] registerMessageType:[HOPatientMessage class]];
 
    [[RCIM sharedRCIM] registerMessageType:[HOMedrMessage class]];

    [RCIM sharedRCIM].userInfoDataSource = self;
    [RCIM sharedRCIM].globalNavigationBarTintColor = UIColorFromRGB(0x333333);
}



//MARK: - 链接融云服务器
- (void)connectRongYunIMServerWithUserModel:(TYMemberModel*)userModel{
    WS(ws);
//    NSString *tokenString = system.rongYunInfo.token;
    NSString *tokenString = userModel.ryToken;
    [[RCIM sharedRCIM] connectWithToken:tokenString success:^(NSString *userId) {
        NSLog(@"登录成功。当前登录的用户ID：%@", userId);
        [ws rongYunLoginSuccessSetHeaderImageWithUserModel:userModel];
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登录的错误码为:%ld", (long)status);

    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    
    [self timLogin:userModel];
}


//MARK: - 链接融云服务器---带回调
- (void)connectRongYunIMServerWithUserModel:(TYMemberModel*)userModel success:(void(^)(NSString *userID))successBlock
                                  witFaile:(void(^)(RCConnectErrorCode status))faileBlock
                              withOverDate:(void(^)(BOOL isOverDate))overDateBlock {
    WS(ws);
    NSString *tokenString = userModel.ryToken;
    
    if (tokenString.length == 0) {
        // token为空
        
        
    }else{
        // token有值
        dispatch_async(dispatch_get_main_queue(), ^{
            [[RCIM sharedRCIM] connectWithToken:tokenString success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户userID：%@", userId);
                
                [ws rongYunLoginSuccessSetHeaderImageWithUserModel:userModel];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (successBlock) {
                        successBlock(userId);
                    }
                });
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%ld", (long)status);
                if (faileBlock) {
                    faileBlock(status);
                }
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
                if (overDateBlock) {
                    overDateBlock(YES);
                }
            }];
        });
    }
    
    [self timLogin:userModel];
}

- (void)timLogin:(TYMemberModel*)userModel{
    WS(weakself)
    [self requestGetTrtcUserSigWithUserId:userModel.userId and:^(NSString *userSig, NSString *appid) {
        if (userSig.length > 0 && appid.length > 0) {
            uint32_t aid = (uint32_t)appid.integerValue;
            NSString * userid = userModel.userId;
            weakself.userSig = userSig;
            
//            [[TRTCVideoCall shared] loginWithSdkAppID:aid user:userid userSig:userSig success:^{
//                CXTLog(@"TIM 登陆成功");
//            } failed:^(NSInteger code, NSString * _Nonnull msg) {
//                CXTLog(@"TIM 登陆失败 code %li,\nmsg:%@",(long)code,msg);
//            }];
            
            [[TRTCCalling shareInstance] login:aid user:userid userSig:userSig success:^{
                NSLog(@"TIM 登陆成功");
                        
            } failed:^(int code, NSString * _Nonnull des) {
                NSLog(@"TIM 登陆失败 code %li,\nmsg:%@",(long)code,des);
                        
            }];
            
//            TIMLoginParam * loginParam = [[TIMLoginParam alloc] init];
//            loginParam.userSig = userSig;
//            loginParam.identifier = system.loginInfo.USER_ID;
//            loginParam.appidAt3rd = appid;
//            weakself.userSig = userSig;
//
//            [[TIMManager sharedInstance] login:loginParam succ:^{
//                CXTLog(@"TIM 登陆成功");
//            } fail:^(int code, NSString *msg) {
//                CXTLog(@"TIM 登陆失败 code %i,\nmsg:%@",code,msg);
//            }];
        }
    }];
}

- (void)timLogout{
    
//    [[TRTCVideoCall shared] logoutWithSuccess:^{
//        CXTLog(@"TIM 退出登陆成功");
//    } failed:^(NSInteger code, NSString * _Nonnull msg) {
//        CXTLog(@"TIM 退出登陆失败 code %li,\nmsg:%@",(long)code,msg);
//    }];
    
    [[TRTCCalling shareInstance] logout:^{
        NSLog(@"TIM 退出登陆成功");
    } failed:^(int code, NSString * _Nonnull des) {
        NSLog(@"TIM 退出登陆失败 code %li,\nmsg:%@",(long)code,des);
    }];
    
//    [[TIMManager sharedInstance] logout:^{
//        CXTLog(@"TIM 退出登陆成功");
//    } fail:^(int code, NSString *msg) {
//        CXTLog(@"TIM 退出登陆失败 code %i,\nmsg:%@",code,msg);
//    }];
}

//MARK: - RCUserInfo Refresh
- (void)rongYunLoginSuccessSetHeaderImageWithUserModel:(TYMemberModel*)userModel
{
    
    NSString *headerURLString = userModel.userIcon;
    if (headerURLString.length == 0)
        headerURLString = kDefaultUserIconUrl;
    else if (![headerURLString hasPrefix:@"http"])
        headerURLString = [NSString stringWithFormat:@"%@%@", serverImageBase_URL, headerURLString];
    
    RCUserInfo *userInfo = [[RCUserInfo alloc] init];
    userInfo.userId =  userModel.userId;
    userInfo.name =  userModel.nameCn;
    userInfo.portraitUri =[NSString stringWithFormat:@"%@",headerURLString];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [RCIM sharedRCIM].currentUserInfo = userInfo;
    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:userInfo.userId];
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    
}

/*FIXME: -  配置融云的一些其他信息*/
- (void)rongYunConfig:(NSDictionary *)launchOptions timSDKAppId:(int)timSDKAppId withDelegate:(id)delegate {
    
    
    //设置会话列表头像和会话页面头像
    
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:delegate];
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    [RCIMClient sharedRCIMClient].voiceMsgType = RCVoiceMessageTypeHighQuality;
    
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
    //开启用户信息和群组信息的持久化
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置用户信息源和群组信息源
//    [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
//    [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    //设置名片消息功能中联系人信息源和群组信息源
//    [RCContactCardKit shareInstance].contactsDataSource = RCDDataSource;
//    [RCContactCardKit shareInstance].groupDataSource = RCDDataSource;
    
    //设置群组内用户信息源。如果不使用群名片功能，可以不设置
    //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
    //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置接收消息代理
    [RCIM sharedRCIM].receiveMessageDelegate = delegate;
    //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    [RCIM sharedRCIM].disableMessageAlertSound = NO;
    
    //开启已读回执功能的会话类型，默认为 单聊、群聊和讨论组
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[];
    
    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = NO;
    
    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = NO;
    
    //群成员数据源
//    [RCIM sharedRCIM].groupMemberDataSource = RCDDataSource;
    
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = NO;
    
    //开启消息撤回功能
    [RCIM sharedRCIM].enableMessageRecall = NO;
    
    
    //  设置头像为圆形
      [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
      [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    //   设置优先使用WebView打开URL
    //  [RCIM sharedRCIM].embeddedWebViewPreferred = YES;
    
    //  设置通话视频分辨率
    //  [[RCCallClient sharedRCCallClient] setVideoProfile:RC_VIDEO_PROFILE_480P];
    
    //设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    
    
    /**
     * 推送处理1
     */
    /*UIApplication *application = [UIApplication sharedApplication];
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        //注册推送，用于iOS8之前的系统
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
#pragma clang diagnostic pop
    }*/
    /**
     * 统计推送打开率1
     */
    [[RCIMClient sharedRCIMClient] recordLaunchOptionsEvent:launchOptions];
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient]
                                     getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id keyString in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[keyString]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
    }

    
//    imSDK init
    TIMSdkConfig * config = [[TIMSdkConfig alloc] init];
    config.sdkAppId = timSDKAppId;
    config.logLevel = TIM_LOG_WARN;
    [[TIMManager sharedInstance] initSdk:config];
    
}

    
/**
 断开融云链接
 */
- (void)disContent{
    [[RCIM sharedRCIM] disconnect];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self timLogout];
}

- (void)refreshUserInfoWithTargetId:(NSString *)targetId {
    [self refreshUserInfoWithTargetId:targetId andName:nil];
}

- (void)refreshUserInfoWithTargetId:(NSString *)targetId andName:(NSString *)name{
    [self checkUserOnWithUserId:targetId  andName:(NSString *)name completion:^(RCUserInfo *userInfo) {
        [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:targetId];
        [[NSNotificationCenter defaultCenter] postNotificationName:kIMRCUserInfoRefresh object:targetId];
    }];
}

#pragma mark - RCConnectionStatusChangeDelegate

/*!
 IMLib连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMLib消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"status == %ld", (long)status);
}


#pragma mark - RCIMUserInfoDataSource
/*!
 获取用户信息

 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]

 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion{
    if ([userId isEqualToString:self.userId]) {
        RCUserInfo * userInfo = [[RCUserInfo alloc] init];
        userInfo.name = @"cc";
        userInfo.portraitUri = kDefaultStaffIconUrl;
        userInfo.userId = userId;
        completion(userInfo);
    }else{
        [self checkUserOnWithUserId:userId andName:nil completion:completion];
    }
}

-(void)checkUserOnWithUserId:(NSString *)userId  andName:(NSString *)name completion:(void (^)(RCUserInfo *userInfo))completion{
    
    NSMutableDictionary *paramter=[NSMutableDictionary dictionary];
    
    [paramter setObject:@"checkUserOn" forKey:@"method"];
    [paramter setObject:userId forKey:@"userId"];
    [paramter setObject:@"userService" forKey:@"service"];
    
    [HttpOperationManager HTTP_POSTWithParameters:paramter showAlert:NO success:^(id responseObject) {
        if([[responseObject objectForKey:@"result"] isEqualToString:@"success"]){
            NSDictionary * user = [responseObject objectForKey:@"userInfo"];
            if (![user isKindOfClass:[NSDictionary class]]) {
                return ;
            }
            
            AmsUser * amsUser = [AmsUser mj_objectWithKeyValues:user];
            RCUserInfo * userInfo = [[RCUserInfo alloc] init];
            if (name.length > 0) {
                userInfo.name = name;
            }else{
                userInfo.name = amsUser.NAME_CN.length > 0?amsUser.NAME_CN:amsUser.MOBILE;
            }
            userInfo.portraitUri = amsUser.ICON_URL.length>0?[serverImageBase_URL stringByAppendingString:amsUser.ICON_URL]:kDefaultUserIconUrl;
            userInfo.userId = amsUser.USER_ID;
            completion(userInfo);
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)requestGetTrtcUserSigWithUserId:(NSString *)userId and:(void (^)(NSString * userSig,NSString * appid))completBlock{
    if (userId.length == 0) {
        return;
    }
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@"getTrtcUserSig" forKey:@"method"];
    [tempDict setValue:userId forKey:@"userId"];
    [tempDict setObject:@"consultService" forKey:@"service"];
    
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO success:^(id responseObject) {
        if([[responseObject objectForKey:@"result"] isEqualToString:@"success"]){
            NSString * userSig = [responseObject objectForKey:@"userSig"];
            NSString * appId =getSafeString(responseObject[@"appId"]);
            if (completBlock) {
                completBlock(userSig,appId);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
