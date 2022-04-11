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
#import "HOIMHelper.h"

@interface HOIMGroupDetailViewController ()

@property (nonatomic, strong) UIView *navBgView;
@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, strong) UILabel *consultCuntLabel;

@property (nonatomic, copy) NSString *cerNo;

@property (nonatomic, strong) UIView *cerView;

@property (nonatomic, strong) UILabel *cerLabel;

@property (nonatomic, strong) UIButton *videoButton;

@end

@implementation HOIMGroupDetailViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kIMRCUnReadCountRefresh" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.navigationBarHidden = YES;
    [self setupNav];
    [self scrollToBottomAnimated:YES];
    [self requestMemberWithSearchString:self.model.homeTel];
   
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGB(249, 249, 249);
    
//    self.navigationController.navigationBarHidden = NO;
//    self.title = @"聊天室";
   
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
//    self.navigationItem.hidesBackButton = YES;
    
    [self setupNav];
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.view.backgroundColor = colorBackground;
    
    [self initConfig];
    
    [self setSubViews];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRCKitDispatchMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imAgainConnect) name:@"kIMStatusChangeDrops" object:nil];

    
    self.conversationMessageCollectionView.backgroundColor = colorBackground;
    
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOConsultMessage class]];
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOPatientMessage class]];
    [self registerClass:[HODrugRecipeMessageCell class] forMessageClass:[HOMedrMessage class]];
//    [self requestCreateGroup];
//    [self addUserToGroup];
    // Do any additional setup after loading the view.
}
#pragma mark - 收到消息
- (void)refreshRCKitDispatchMessageNotification:(NSNotification*)noti
{
    NSLog(@"refreshRCKitDispatchMessageNotification=====");
    @weakify(self)
    RCMessage * message = noti.object;
    RCMessageContent * content = message.content;
    if ([content respondsToSelector:@selector(extra)]) {
        NSString * extra = [content valueForKey:@"extra"];
        NSLog(@"extra==:%@",extra);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self setupNav];
//            [self scrollToBottomAnimated:YES];
            
        });
        
    }
}
- (void)imAgainConnect
{
    [[HOIMHelper shareInstance] connectRongYunIMServerWithUserModel:self.model];
}

- (void)setupNav{
    
//    self.titleLabel.textColor = [UIColor blackColor];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
 
//
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] style:UIBarButtonItemStylePlain target:nil action:@selector(leftBarButtonAction)];
//    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] style:UIBarButtonItemStylePlain target:nil action:@selector(leftBarButtonAction)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
////
//    self.navigationItem.titleView = self.titleLabel;
//    self.title = @"聊天室";
//    self.navigationItem.titleView.tintColor = [UIColor blackColor];
    
    self.navBgView.hidden = NO;
}

- (void)leftBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
   
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
    
    
    _bottomBgView = [[UIView alloc] init];
    _bottomBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomBgView];
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(insets.bottom+115);
    }];
    
    
    _videoButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"视频问诊",UIControlStateNormal).titleColorForState([UIColor whiteColor],UIControlStateNormal).titleFont([UIFont boldSystemFontOfSize:20]).backgroundColor(RGB(1, 111, 255)).imageForState([KykjImToolkit getImageResourceForName:@"ty_chat_video"],UIControlStateNormal).addAction(self,@selector(actionCreateOrder),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    _videoButton.layer.cornerRadius = 10.f;
    [_videoButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [_videoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    [_videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view).mas_offset(-15-insets.bottom);
        make.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
    }];
    
    
    
    
    _consultCuntLabel = [[UILabel alloc] init];
    _consultCuntLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_consultCuntLabel];
    [_consultCuntLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.videoButton.mas_top).mas_offset(-15);
        make.height.mas_equalTo(20);
    }];
  
    [self.chatSessionInputBarControl setHidden:YES];
    
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(NavStaHeight);
//            make.bottom.equalTo(self.bottomListView.mas_top);
        make.bottom.equalTo(self.consultCuntLabel.mas_top).mas_offset(-20);
        make.left.right.equalTo(self.view);
    }];
    
    [self refreshUI];
   
}

- (void)refreshUI
{
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
    
    _consultCuntLabel.attributedText = attStr1;
    
    
    
    if (_model.countLeft.intValue>0) {
        _videoButton.enabled = YES;
        _videoButton.backgroundColor = RGB(1, 111, 255);
    }else{
        _videoButton.enabled = NO;
        _videoButton.backgroundColor = RGB(205, 205, 205);
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
/*!
 点击Cell中头像的回调

 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    
//    if (![userId isEqualToString:self.model.userId]) {
//        [self getStaffLicenseInfoWithStaffUserId:userId];
//    }

    
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
//    vc.isNeedPopTargetViewController = YES;
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
                [LeafNotification showHint:msgString yOffset:100];
//                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
           
           
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
                [LeafNotification showHint:msgString yOffset:100];
//                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
           
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
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
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
                [LeafNotification showHint:msgString yOffset:100];
//                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
    }];
}

- (void)actionCreateOrder
{
    @weakify(self)
    [KykjImToolkit checkVideoAuthorityWithCallBack:^{
        [KykjImToolkit checkMicroAuthorityWithCallBack:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)
                           
                           [self requestCreateOrder];
 
            });
        }];
    }];
}

- (void)requestCreateOrder
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"dzService" forKey:@"service"];
    [param setObject:@"raiseGuidance" forKey:@"method"];
    [param setObject:getSafeString(_model.userId) forKey:@"userId"];

    [param setObject:getSafeString(_model.idCard) forKey:@"userIdCard"];

    [param setObject:getSafeString(_model.nameCn) forKey:@"userName"];

    [param setObject:getSafeString(_model.homeTel) forKey:@"userPhone"];

    [param setObject:RegWayCode forKey:@"regWayCode"];

    [param setObject:[KykjImToolkit getUniqueStrByUUID] forKey:@"uuid"];

    //写死
    
//    [param setObject:@"raiseGuidanceForTesting" forKey:@"method"];
//    [param setObject:@"307430" forKey:@"staffId"];
//
//    [param setObject:@"梁玉娟" forKey:@"staffName"];
//
//    [param setObject:@"17784915" forKey:@"expertUserId"];
//
//    [param setObject:getSafeString(_model.userId) forKey:@"userId"];
//
//    [param setObject:getSafeString(_model.idCard) forKey:@"userIdCard"];
//
//    [param setObject:getSafeString(_model.nameCn) forKey:@"userName"];
//
//    [param setObject:getSafeString(_model.homeTel) forKey:@"userPhone"];
//
//    [param setObject:RegWayCode forKey:@"regWayCode"];
//
//    [param setObject:[KykjImToolkit getUniqueStrByUUID] forKey:@"uuid"];

    @weakify(self)
    
    self.videoButton.enabled = NO;
    
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:YES success:^(id responseObject) {
      
        @strongify(self)
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            
            [self requestGetMcDz:responseObject[@"dzId"]];
            
        }else{
            self.videoButton.enabled = YES;
            NSString *msgString = getSafeString(responseObject[@"info"]);

            if (msgString.length > 0) {
                [LeafNotification showHint:msgString yOffset:100];
//                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        @strongify(self)
        self.videoButton.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)requestGetMcDz:(NSString*)dzId{
    
    MBProgressHUDShowInThisView;
    
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
        self.videoButton.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
                
                [LeafNotification showHint:@"没有查到此订单" yOffset:100];
              
            }
        }else{
            self.videoButton.enabled = YES;
            NSString *msgString = getSafeString(responseObject[@"info"]);
            if (![getSafeString(responseObject[@"code"]) isEqualToString:@"301"]) {
                if (msgString.length > 0) {
                    [LeafNotification showHint:msgString yOffset:100];
    //                [LeafNotification showInController:weakself withText:msgString];
                }else
                    [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
    //                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
            }
        }
    } failure:^(NSError *error) {
        
        @strongify(self)
        self.videoButton.enabled = YES;
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
                 [LeafNotification showHint:msgString yOffset:100];
 //                [LeafNotification showInController:weakself withText:msgString];
             }else
                 [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
 //                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
         }
        
     } failure:^(NSError *error) {
         
     }];
}

- (void)getStaffLicenseInfoWithStaffUserId:(NSString*)staffUserId{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@"getStaffLicenseInfo" forKey:@"method"];
    [tempDict setObject:staffUserId forKey:@"staffId"];
    [tempDict setObject:@"consultService" forKey:@"service"];
    
    WS(weakself)
    MBProgressHUDShowInThisView;
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO showLog:YES needEncryption:NO  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSDictionary *rowsDic = [responseObject objectForKey:@"rows"];
            if (rowsDic!=nil) {
                weakself.cerNo = rowsDic[@"PHYSICIAN_CERTIFICATE"];
                dispatch_async(dispatch_get_main_queue(),^{

                    weakself.cerView.hidden = YES;
                    weakself.cerLabel.text = [NSString stringWithFormat:@"医生资格证书编号\n%@",self.cerNo.length>0 ? self.cerNo : @""];
                    [weakself showCerView];
                    [weakself performSelector:@selector(hiddenCerView) withObject:nil afterDelay:3.f];

                });
            }
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(),^{

                weakself.cerView.hidden = YES;
                weakself.cerLabel.text = [NSString stringWithFormat:@"医生资格证书编号"];
                [weakself showCerView];
                [weakself performSelector:@selector(hiddenCerView) withObject:nil afterDelay:3.f];

            });
//            NSString *msgString = getSafeString(responseObject[@"info"]);
//            if (msgString.length > 0) {
//                [LeafNotification showInController:weakself withText:msgString];
//            }else
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
    }];
}
- (void)requestMemberWithSearchString:(NSString*)searhString
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"dzService" forKey:@"service"];
    [param setObject:@"searchUserInfo" forKey:@"method"];
    [param setObject:searhString forKey:@"homeTel"];
    
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:NO success:^(id responseObject) {
      @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       
        if (responseObject!=nil) {

//            system.TOKEN = getSafeString(responseObject[@"token"]);
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                TYMemberModel *temp = [[TYMemberModel alloc] init];
                if (responseObject[@"rows"] != nil) {
                    temp = [temp mj_setKeyValues:responseObject[@"rows"]];
                    self.model = temp;
                    
                    [self refreshUI];
                    
                    [[HOIMHelper shareInstance] connectRongYunIMServerWithUserModel:self.model];
                    
                }
                else{
                    [LeafNotification showHint:@"未查询到会员信息！" yOffset:-ScreenHeight/2];
                }
            }else{
                NSString *msgString = getSafeString(responseObject[@"info"]);
                if (msgString.length > 0) {
                    [LeafNotification showHint:msgString yOffset:-ScreenHeight/2];
    //                [LeafNotification showInController:weakself withText:msgString];
                }else
                    [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:-ScreenHeight/2];
    //                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
            }
     
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showHint:@"网络连接失败" yOffset:-ScreenHeight/2];
    }];
}

#pragma mark - TRTCCallingDelegate

- (void)onRecvC2CTextMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId text:(NSString *)text
{
//    [LeafNotification showInController:self withText:@"videoing ===== onRecvC2CTextMessage"];
//    if ([text isEqualToString:@"医生忙碌中，请重新发起视频"]) {
//        [self hungUpAction];
//    }
}
- (void)onRecvC2CCustomMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId customData:(NSData *)data
{
    
}

#pragma mark - RCConnectionStatusChangeDelegate
- (void)onConnectionStatusChanged:(RCConnectionStatus)status{
    NSLog(@"status == %ld", (long)status);
    if(status == 11 || status == 6){
        [[HOIMHelper shareInstance] connectRongYunIMServerWithUserModel:self.model];
    }
}

- (UIView*)cerView
{
    if (!_cerView) {
        _cerView = [[UIView alloc] init];
        _cerView.backgroundColor = [UIColor whiteColor];
        _cerView.layer.cornerRadius = 10.f;
        _cerView.layer.shadowOpacity = 0.6;
        _cerView.layer.shadowColor = RGB(153, 153, 153).CGColor;
        _cerView.layer.shadowOffset = CGSizeMake(0, 1);
        _cerView.layer.shadowRadius = 2;
        [[UIApplication sharedApplication].delegate.window addSubview:_cerView];
        [_cerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(290);
            make.height.mas_equalTo(63);
            make.centerX.centerY.equalTo([UIApplication sharedApplication].delegate.window);
        }];
        
        _cerView.hidden = YES;
        
        _cerLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
            make.backgroundColor([UIColor whiteColor]).textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:14]).numberOfLines(0).addToSuperView(self.cerView);
        }];
        [_cerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.cerView);
            
        }];
    }
    return _cerView;
}
- (void)hiddenCerView
{
    _cerView.hidden = YES;
    [UIView animateWithDuration:.3f animations:^{
        [self.cerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.cerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
                make.height.mas_equalTo(0);
                make.centerX.centerY.equalTo(self.view);
            }];
        }];
}
- (void)showCerView
{
    _cerView.hidden = NO;
    [UIView animateWithDuration:.3f animations:^{
        [self.cerView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.cerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(290);
                make.height.mas_equalTo(63);
                make.centerX.centerY.equalTo(self.view);
            }];

        }];
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
        _titleLabel.text = @"聊天室";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.navigationItem.titleView = _titleLabel;
    }
 
    return _titleLabel;
    
}

- (UIView*)navBgView
{
    if (!_navBgView) {
        _navBgView = [[UIView alloc] init];
        _navBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_navBgView];
        [_navBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(NavStaHeight);
        }];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, StatuBarHeight, ScreenWidth-240, 44)];
        _titleLabel.text = @"聊天室";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_navBgView addSubview:_titleLabel];
      
        
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, StatuBarHeight, 95, 44)];
    //    [_right setImage:[UIImage imageNamed:@"M_setting_ic"] forState:UIControlStateNormal];
        [_rightButton setTitle:@"历史报告" forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGB(1, 111, 255) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setFrame:CGRectMake(0, StatuBarHeight, 75, 44)];
        [_leftButton setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];

        
        [_leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_navBgView addSubview:_rightButton];
        
        [_navBgView addSubview:_leftButton];
        
    }
    return _navBgView;
}
- (UIButton*)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    //    [_right setImage:[UIImage imageNamed:@"M_setting_ic"] forState:UIControlStateNormal];
        [_rightButton setTitle:@"历史报告" forState:UIControlStateNormal];
        [_rightButton setTitleColor:RGB(1, 111, 255) forState:UIControlStateNormal];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightButton addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
       
    }
   

    return _rightButton;
}
- (UIButton*)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];

        
        [_leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 44));
        }];
        
    }

    return _leftButton;
}
- (void)dealloc{
    [_cerView removeFromSuperview];
    _cerView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
