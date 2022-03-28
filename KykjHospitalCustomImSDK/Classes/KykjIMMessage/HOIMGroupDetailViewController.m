//
//  HOIMGroupDetailViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/3.
//  Copyright © 2022 cc. All rights reserved.
//

#import "HOIMGroupDetailViewController.h"
#import "GenerateTestUserSig.h"
#import "NSString+Common.h"
#import "HOIMDetailViewController.h"
#import "TYHistoryReportListViewController.h"
#import "HOConsultMessageCell.h"
#import "HODrugRecipeMessageCell.h"
#import "HOConsultMessage.h"
#import "HOPatientMessage.h"
#import "HOMedrMessage.h"
#import "TYReportDetailViewController.h"
#import "YXPatientRecordsModel.h"
#import "Factory.h"
#import "MJExtension.h"

@interface HOIMGroupDetailViewController ()

@property (nonatomic, strong) UIButton * right;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *consultCuntLabel;

@end

@implementation HOIMGroupDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:colorBackground];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [IQKeyboardManager sharedManager].enable = NO;
    [self setupNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGB(249, 249, 249);
    
//    self.navigationController.navigationBarHidden = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
    
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.view.backgroundColor = colorBackground;
    
    [self initConfig];
    
    [self setSubViews];
    
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
//            make.bottom.equalTo(self.bottomListView.mas_top);
        make.bottom.equalTo(self.chatSessionInputBarControl.inputTextView.mas_top).mas_offset(-160);
        make.left.right.equalTo(self.view);
    }];
   
    
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOConsultMessage class]];
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOPatientMessage class]];
    [self registerClass:[HODrugRecipeMessageCell class] forMessageClass:[HOMedrMessage class]];
//    [self requestCreateGroup];
//    [self addUserToGroup];
    // Do any additional setup after loading the view.
}
- (void)setupNav{
    
    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
//    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    
    _right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
//    [_right setImage:[UIImage imageNamed:@"M_setting_ic"] forState:UIControlStateNormal];
    [_right setTitle:@"历史报告" forState:UIControlStateNormal];
    [_right setTitleColor:RGB(1, 111, 255) forState:UIControlStateNormal];
    _right.titleLabel.font = [UIFont systemFontOfSize:14];
    [_right addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_right];
//    _right.hidden = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
    self.titleLabel.text = @"聊天室";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = self.titleLabel;
    
    
}
- (void)initConfig{
//    @weakify(self)
    //屏蔽群组消息
    NSString *groupId = [NSString stringWithFormat:@"%@99999",_model.userId];
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:groupId isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
        NSLog(@"=====nStatus:%ld",nStatus);
        
    } error:^(RCErrorCode status) {
//        @strongify(self)
        NSLog(@"=====status:%ld",status);
//            [LeafNotification showInController:self withText:@"设置失败，请稍后重试!"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [SVProgressHUD showInfoWithStatus:@"设置失败，请稍后重试!"];
//            [SVProgressHUD dismissWithDelay:1.5f];

//        });
//
    }];
}
- (void)rightBarButtonItemPressed:(id)sender{
//    HOIMDetailViewController * vc = [[HOIMDetailViewController alloc] init];
//    vc.conversationType = self.conversationType;
//    vc.targetId = @"17617119";
//    RCUserInfo * userInfo = [[RCUserInfo alloc] init];
//    userInfo.userId = @"17617119";
//    userInfo.name = @"梁永清";
//    userInfo.portraitUri = getImageAddress(_orderRecordModel.ICON_URL).absoluteString;
//    vc.targetUserInfo = userInfo;
// 
//    vc.orderRecordModel = self.orderRecordModel;
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    TYHistoryReportListViewController *vc = [[TYHistoryReportListViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setSubViews
{
    UIEdgeInsets insets;
    if (@available(iOS 11.0, *))
    {
        insets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    else
    {
        insets = UIEdgeInsetsZero;
    }
    
    
    UIButton *videoButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"视频问诊",UIControlStateNormal).titleColorForState([UIColor whiteColor],UIControlStateNormal).titleFont([UIFont boldSystemFontOfSize:20]).backgroundColor(RGB(1, 111, 255)).imageForState([KykjImToolkit getImageResourceForName:@"ty_chat_video"],UIControlStateNormal).addAction(self,@selector(requestCreateOrder),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    videoButton.layer.cornerRadius = 10.f;
    [videoButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [videoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view).mas_offset(-15-insets.bottom);
        make.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
    }];
    
    
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"可用次数" attributes:@{NSForegroundColorAttributeName:RGB(102, 102, 102),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
  
    [attStr1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,[attStr1 length])];
    
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",_model.countLeft.intValue] attributes:@{NSForegroundColorAttributeName:RGB(1, 111, 255),NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc]init];
  
    [attStr2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0,[attStr2 length])];
    [attStr1 insertAttributedString:attStr2 atIndex:attStr1.length];
    
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:@"次" attributes:@{NSForegroundColorAttributeName:RGB(102, 102, 102),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    NSMutableParagraphStyle *style3 = [[NSMutableParagraphStyle alloc]init];
  
    [attStr3 addAttribute:NSParagraphStyleAttributeName value:style3 range:NSMakeRange(0,[attStr3 length])];
    [attStr1 insertAttributedString:attStr3 atIndex:attStr1.length];
    
    _consultCuntLabel = [[UILabel alloc] init];
    _consultCuntLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_consultCuntLabel];
    [_consultCuntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(videoButton.mas_top).mas_offset(-15);
        make.height.mas_equalTo(20);
    }];
    _consultCuntLabel.attributedText = attStr1;
    
    
    [self.chatSessionInputBarControl setHidden:YES];
    
    if (_model.countLeft.intValue>0) {
        videoButton.enabled = YES;
        videoButton.backgroundColor = RGB(1, 111, 255);
    }else{
        videoButton.enabled = NO;
        videoButton.backgroundColor = RGB(205, 205, 205);
    }
}

- (void)didTapMessageCell:(RCMessageModel *)model{
   if ([model.objectName isEqualToString:HOMedrMessageTypeIdentifier]){
        //电子病历消息
        WS(weakself);
        [self requetGetCaseRecordsWith:(HOMedrMessage *)model.content andCompletBlock:^(YXPatientRecordsModel *patientRecord) {
            if (patientRecord) {
                [weakself showEmrDetailVC:patientRecord];
            }
        }];

    }
    else{
        [super didTapMessageCell:model];
    }
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (cell.messageDirection == MessageDirection_SEND) {
        if ([cell isKindOfClass:[RCTextMessageCell class]]) {
            RCTextMessageCell *textCell =(RCTextMessageCell*)cell;
            textCell.textLabel.textColor = [UIColor whiteColor];
        }
        
        if ([cell isKindOfClass:[RCVoiceMessageCell class]]) {
            RCVoiceMessageCell *voiceCell =(RCVoiceMessageCell*)cell;
            voiceCell.voiceDurationLabel.textColor = [UIColor whiteColor];
        }
    }
    
}

- (void)showEmrDetailVC:(YXPatientRecordsModel *)recordModel
{
//    EMRPreviewViewController * vc = [[EMRPreviewViewController alloc] init];
//
//    vc.depId = recordModel.DEP_ID;
//    EMRRecordModel *model = [[EMRRecordModel alloc] init];
//    NSMutableDictionary *jsonDic = [recordModel mj_keyValues];
//    model = [model mj_setKeyValues:jsonDic];
//    vc.emrModel = model;
//
//    YXOrderRecordModel *orderModel = [[YXOrderRecordModel alloc] init];
//    orderModel.USER_ID = model.USER_ID;
//    orderModel.USER_NAME = model.PATIENT_NAME;
//    orderModel.USER_AGE = model.PATIENT_AGE;
//    orderModel.USER_SEX = model.PATIENT_SEX;
//    orderModel.PATIENT_ID = model.PATIENT_ID;
//    orderModel.ID_CARD = model.PATIENT_IDCARD;
//    vc.orderRecordModel = orderModel;
//
//    [self.navigationController pushViewController:vc animated:YES];
    
    TYReportDetailViewController * vc = [[TYReportDetailViewController alloc] init];
 
    EMRRecordModel *model = [[EMRRecordModel alloc] init];
    NSMutableDictionary *jsonDic = [recordModel mj_keyValues];
    vc.emrModel = [model mj_setKeyValues:jsonDic];
    
    YXOrderRecordModel *orderModel = [[YXOrderRecordModel alloc] init];
    orderModel.USER_ID = model.USER_ID;
    orderModel.USER_NAME = model.PATIENT_NAME;
    orderModel.USER_AGE = model.PATIENT_AGE;
    orderModel.USER_SEX = model.PATIENT_SEX;
    orderModel.PATIENT_ID = model.PATIENT_ID;
    orderModel.ID_CARD = model.PATIENT_IDCARD;
    orderModel.START_TIME = model.INQUIRY_TIME;
    orderModel.DEP_NAME = model.DEP_NAME;
    orderModel.STAFF_NAME = model.STAFF_NAME;
    
    vc.orderRecordModel = orderModel;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushVideo:(YXOrderRecordModel*)orderModel
{
    HOIMDetailViewController * vc = [[HOIMDetailViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:orderModel.STAFF_USER_ID];
    vc.isNeedPopTargetViewController = YES;
//    vc.hidesBottomBarWhenPushed = YES;
    
    vc.model = self.model;
    vc.myRoomId = orderModel.DZ_ID;
    vc.orderRecordModel = orderModel;
   
//    vc.isStartVideo = YES;

    RCUserInfo * userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = orderModel.STAFF_USER_ID;
    userInfo.name = orderModel.STAFF_NAME;
    userInfo.portraitUri = getImageAddress(orderModel.STAFF_ICON).absoluteString;;
    vc.targetUserInfo = userInfo;

    RCUserInfo *myUserInfo = [[RCUserInfo alloc] init];
    myUserInfo.userId = orderModel.USER_ID;
    myUserInfo.name = orderModel.USER_NAME;
    myUserInfo.portraitUri = orderModel.ICON_URL;
    [RCIM sharedRCIM].currentUserInfo = myUserInfo;

    [[RCIM sharedRCIM] refreshUserInfoCache:myUserInfo withUserId:myUserInfo.userId];
    
   
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestCreateGroup
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"consultService" forKey:@"service"];
    [param setObject:@"createGroup" forKey:@"method"];
    [param setObject:@"17617114" forKey:@"userId"];
    [param setObject:@"19930330" forKey:@"groupId"];
    [param setObject:@"测试聊天室2" forKey:@"groupName"];
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:YES success:^(id responseObject) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            HOIMDetailViewController * vc = [[HOIMDetailViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"17782031"];
//            vc.isNeedPopTargetViewController = NO;
        //    vc.hidesBottomBarWhenPushed = YES;
//            HOIMMsgExtraModel * extraModel = [[HOIMMsgExtraModel alloc] initWithOrderRecord:orderRecord];
//            vc.extraModel = extraModel;
//            YXOrderRecordModel * orderRecordModel = orderRecord;
//            if (orderRecordModel) {
//                RCUserInfo * userInfo = [[RCUserInfo alloc] init];
//                userInfo.userId = orderRecordModel.USER_ID;
//                userInfo.name = orderRecordModel.USER_NAME;
//                userInfo.portraitUri = getImageAddress(orderRecordModel.ICON_URL).absoluteString;
//                vc.targetUserInfo = userInfo;
//            }
//            vc.isStartVideo = YES;
            [self.navigationController pushViewController:vc animated:YES];
         
        }else{
            NSString *msgString = getSafeString(responseObject[@"info"]);

            if (msgString.length > 0) {
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:msgString];
//                [SVProgressHUD showInfoWithStatus:msgString];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }else{
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:@"系统错误，请稍后再试！"];
//                [SVProgressHUD showInfoWithStatus:@"系统错误，请稍后再试！"];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }
          
           
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
       
    }];
}
- (void)addUserToGroup
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"consultService" forKey:@"service"];
    [param setObject:@"join" forKey:@"method"];
    [param setObject:_model.userId forKey:@"userId"];
    [param setObject:self.targetId forKey:@"groupId"];
    [param setObject:@"聊天室" forKey:@"groupName"];
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:YES success:^(id responseObject) {
      
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            
         
        }else{
            NSString *msgString = getSafeString(responseObject[@"info"]);

            if (msgString.length > 0) {
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:msgString];
//                [SVProgressHUD showInfoWithStatus:msgString];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }else{
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:@"系统错误，请稍后再试！"];
//                [SVProgressHUD showInfoWithStatus:@"系统错误，请稍后再试！"];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }
          
           
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
       
    }];
}

- (void)requetGetCaseRecordsWith:(HOMedrMessage *)message andCompletBlock:(void(^)(YXPatientRecordsModel *patientRecord))completBlock{

    if (message.extraModel.recordId.length == 0) {
        return;
    }
    
    NSDictionary * params = @{@"service" : @"clinicService",
                              @"method" : @"getCaseRecords",
//                              @"staffUserId" : self.orderRecordModel.STAFF_USER_ID,
                              @"MIN_ROWS" : @(0),
                              @"MAX_ROWS" : @(1),
                              @"userId" : self.model.userId,
                              @"recordId" : message.extraModel.recordId
    };
    
    WS(weakself)
    MBProgressHUDShowInThisView;
    [HttpOperationManager HTTP_POSTWithParameters:params showAlert:NO success:^(id responseObject) {
        MBProgressHUDHideAllInThisView(weakself);
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSArray *patientGroups = [responseObject objectForKey:@"list"];
            NSArray * arrayPatientRecords = [YXPatientRecordsModel mj_objectArrayWithKeyValuesArray:patientGroups];
            if (arrayPatientRecords.count > 0 && completBlock) {
                completBlock(arrayPatientRecords[0]);
            }
        }else{
            NSString *msgString = getSafeString(responseObject[@"info"]);
            if (msgString.length > 0) {
                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
        }
    } failure:^(NSError *error) {
        MBProgressHUDHideAllInThisView(weakself);
    }];
}

- (void)requestCreateOrder
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"dzService" forKey:@"service"];
    [param setObject:@"raiseGuidance" forKey:@"method"];
    [param setObject:getSafeString(_model.userId) forKey:@"userId"];
   
    [param setObject:getSafeString(_model.idCard) forKey:@"userIdCard"];

    [param setObject:getSafeString(_model.nameCn) forKey:@"userName"];

    [param setObject:getSafeString(_model.homeTel) forKey:@"userPhone"];

    [param setObject:RegWayCode forKey:@"regWayCode"];

    [param setObject:[KykjImToolkit getUniqueStrByUUID] forKey:@"uuid"];

    @weakify(self)
    
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:YES success:^(id responseObject) {
      
        @strongify(self)
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            
            [self requestGetMcDz:responseObject[@"dzId"]];
            
        }else{
            NSString *msgString = getSafeString(responseObject[@"info"]);

            if (msgString.length > 0) {
                            [LeafNotification showInController:self withText:msgString];
//                [SVProgressHUD showInfoWithStatus:msgString];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }else{
                            [LeafNotification showInController:self withText:@"系统错误，请稍后再试！"];
//                [SVProgressHUD showInfoWithStatus:@"系统错误，请稍后再试！"];
//                [SVProgressHUD dismissWithDelay:1.0f];
            }
          
           
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
       
    }];
}
- (void)requestGetMcDz:(NSString*)dzId{
    
//    MBProgressHUDShowInThisView;
    
   NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@(0) forKey:@"MIN_ROWS"];
    [tempDict setObject:@(1) forKey:@"MAX_ROWS"];
    [tempDict setObject:@"getMcDz" forKey:@"method"];
//    [tempDict setObject:system.loginInfo.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:@"dzService" forKey:@"service"];
    [tempDict setObject:@"C,R,J,D" forKey:@"statusList"];

    [tempDict setObject:@"DZ_ZX_TXT" forKey:@"dzTypeList"];
  
    [tempDict setObject:dzId forKey:@"dzId"];
    [tempDict setObject:@"status" forKey:@"orderBy"];
    
//    WS(weakself)
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO success:^(id responseObject) {
        @strongify(self)
       
    
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSArray * arrayTemp = [YXOrderRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"dzList"]];
            if (arrayTemp.count > 0) {
                if (!self.orderRecordModel || ![self.orderRecordModel isEqualWithOrderRecord:arrayTemp[0]]) {
                    self.orderRecordModel = arrayTemp[0];
//                    [self requestUpadateVideoInfo:self.orderRecordModel];
                    [self pushVideo:self.orderRecordModel];
                }
                
                
               
            }else{
                [LeafNotification showInController:self withText:@"没有查到此订单"];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *msgString = getSafeString(responseObject[@"info"]);
            if (![getSafeString(responseObject[@"code"]) isEqualToString:@"301"]) {
                if (msgString.length > 0) {
                    [LeafNotification showInController:self withText:msgString];
                }else
                    [LeafNotification showInController:self withText:@"系统错误，请稍后再试！"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)requestUpadateVideoInfo:(YXOrderRecordModel*)order
{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
     [tempDict setObject:@"updateVideoInfo" forKey:@"method"];
     [tempDict setObject:order.DZ_ID forKey:@"dzId"];
    [tempDict setObject:order.DZ_ID forKey:@"roomId"];
//    [tempDict setObject:order.DZ_ID forKey:@"videoId"];
    [tempDict setObject:order.USER_ID forKey:@"userId"];
    [tempDict setObject:order.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:@"userCreate" forKey:@"function"];
     [tempDict setObject:@"dzService" forKey:@"service"];
     
     WS(weakself)
     [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO showLog:YES needEncryption:NO  success:^(id responseObject) {
         
         NSString * result = responseObject[@"result"];
         if([result isEqualToString:@"success"]){
//             [weakself pushVideo:responseObject[@"dzId"]];
         }else{
             NSString *msgString = getSafeString(responseObject[@"info"]);
             if (msgString.length > 0) {
                 [LeafNotification showInController:weakself withText:msgString];
             }else
                 [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
         }
        
     } failure:^(NSError *error) {
         
     }];
}

#pragma mark - TRTCCallingDelegate

- (void)onRecvC2CTextMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId text:(NSString *)text
{
    [LeafNotification showInController:self withText:@"videoing ===== onRecvC2CTextMessage"];
    if ([text isEqualToString:@"医生忙碌中，请重新发起视频"]) {
//        [self hungUpAction];
    }
}
- (void)onRecvC2CCustomMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId customData:(NSData *)data
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
