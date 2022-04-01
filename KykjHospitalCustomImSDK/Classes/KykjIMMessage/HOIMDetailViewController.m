#import "HOIMDetailViewController.h"
#import "HOConsultMessageCell.h"
#import "HOConsultMessage.h"
#import "HOPatientMessage.h"
#import "HOMedrMessage.h"
#import "HOIMHelper.h"
#import "YXPatientRecordsModel.h"

#import "HODrugRecipeMessageCell.h"

#import "YXOrderRecordModel.h"
#import "HOIMConsultMsgExtraModel.h"

#import "UINavigationController+FDFullscreenPopGesture.h"

#import "KYTRTCVideoCallingViewController.h"
#import "GenerateTestUserSig.h"
#import "NSString+Common.h"
#import "TYHistoryReportListViewController.h"
#import "TYReportDetailViewController.h"
#import "TYMemberSearchDetailViewController.h"
#import "HOIMGroupDetailViewController.h"
#import "Factory.h"
#import "MJExtension.h"

@interface HOIMDetailViewController ()<KYTRTCVideoCallingViewControllerDelegate>

@property (strong, nonatomic) RCInformationNotificationMessage * notificationMessage;

@property (assign, nonatomic) CGFloat orginHeight;

@property (nonatomic, strong) KYTRTCVideoCallingViewController *kyVideoVC;

@property (nonatomic, strong) UIButton * leftButton;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *cerNo;

@property (nonatomic, strong) UIView *cerView;

@property (nonatomic, strong) UILabel *cerLabel;

@property (nonatomic, strong) UIView *endBottomView;

@end

@implementation HOIMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = self.targetUserInfo.name;
    
//    if (self.isNeedPopTargetViewController) {
        self.fd_interactivePopDisabled = YES;
//    }
    
//    self.navigationController.navigationBarHidden = NO;
    
    self.view.tag = 100;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
    [self setupNav];
    
    [self setupPluginBoard];
//    MBProgressHUDShowInThisView;
    [self requestGetMcDz:YES];
    
    
    self.conversationMessageCollectionView.backgroundColor = colorBackground;
    
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOConsultMessage class]];
    [self registerClass:[HOConsultMessageCell class] forMessageClass:[HOPatientMessage class]];
    [self registerClass:[HODrugRecipeMessageCell class] forMessageClass:[HOMedrMessage class]];

    if (self.targetUserInfo){
        [[RCIM sharedRCIM] refreshUserInfoCache:self.targetUserInfo withUserId:self.targetUserInfo.userId];
    }
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRCKitDispatchMessageNotification:) name:RCKitDispatchMessageNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pictureAllow:) name:@"appRefreshLocation" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEnd) name:kIMStatusChangeDrops object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imAgainConnect) name:@"kIMStatusChangeDrops" object:nil];
    
    [KykjImToolkit checkMustLibraryAuthorityWithCallBack:^{

    }];

    
    if (@available(iOS 11.0, *)) {
        self.conversationMessageCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (![KykjImToolkit isStringBlank:_myRoomId]) {
        [self actionTRCT];
    }
//    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];

    [self.chatSessionInputBarControl setHidden:YES];
    
//        self.endBottomView.hidden = YES;
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.chatSessionInputBarControl.inputTextView.mas_top).mas_offset(-20);
        make.right.left.equalTo(self.view);
    }];
//    [self getStaffLicenseInfo];
}
- (void)pictureAllow:(NSNotification*)noti
{
//    if (@available(iOS 15.2, *)) {
        [KykjImToolkit checkMustLibraryAuthorityWithCallBack:^{

            }];
//    }
}
#pragma mark - 收到消息
- (void)refreshRCKitDispatchMessageNotification:(NSNotification*)noti
{
    NSLog(@"refreshRCKitDispatchMessageNotification=====");
    WS(weakself)
    RCMessage * message = noti.object;
    RCMessageContent * content = message.content;
    if ([content respondsToSelector:@selector(extra)]) {
        NSString * extra = [content valueForKey:@"extra"];
        NSLog(@"extra==:%@",extra);
        if([extra isKindOfClass:[NSString class]]){
            if (extra.length > 0 && [message.targetId isEqualToString:self.targetId]) {
                HOIMMsgExtraModel * extraModel = [HOIMMsgExtraModel mj_objectWithKeyValues:[extra mj_JSONObject]];
                if (![extraModel.status isEqualToString:weakself.orderRecordModel.STATUS]) {
                    [weakself requestGetMcDz:NO];
                }
            }
        }else{
            if (extra!=nil && [message.targetId isEqualToString:self.targetId]) {
                HOIMMsgExtraModel * extraModel = [HOIMMsgExtraModel mj_objectWithKeyValues:[extra mj_JSONObject]];
                if (![extraModel.status isEqualToString:weakself.orderRecordModel.STATUS]) {
                    [weakself requestGetMcDz:NO];
                }
            }
        }
        
    }
}

- (void)imAgainConnect
{
    NSLog(@"im挤下线");
    [[HOIMHelper shareInstance] connectRongYunIMServerWithUserModel:self.model];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self setupNav];
   
    
//    if (self.kyVideoVC!=nil) {
//        [self setupNav];
//        self.kyVideoVC.view.transform = CGAffineTransformIdentity;
        
//        [self.kyVideoVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
//
//            make.size.left.equalTo(self.navigationController.view);
//            make.top.equalTo(self.navigationController.view);
//        }];
//        self.kyVideoVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,  .25f, .2f);
        
//        [self.navigationController.view bringSubviewToFront:self.kyVideoVC.view];
//    }
   
//    [self refreshNav];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.orginHeight == 0) {
        self.orginHeight = self.conversationMessageCollectionView.bounds.size.height;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kIMRCUnReadCountRefresh" object:nil];
    }
}

- (void)dealloc{
    [_cerView removeFromSuperview];
    _cerView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_kyVideoVC stopAndQuit];
//    [_kyVideoVC removeFromParentViewController];

}

- (UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationOverFullScreen;
}

- (void)setupNav{
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];

    self.navigationItem.titleView = self.titleLabel;
    
}

- (void)refreshNav
{
    self.titleLabel.text = _orderRecordModel.STAFF_NAME;
}

- (void)setOrderRecordModel:(YXOrderRecordModel *)orderRecordModel{
    _orderRecordModel = orderRecordModel;

    self.extraModel = [[HOIMMsgExtraModel alloc] initWithOrderRecord:orderRecordModel];
    
    RCUserInfo * userInfo = [[RCUserInfo alloc] init];
    userInfo.userId = orderRecordModel.STAFF_USER_ID;
    userInfo.name = orderRecordModel.STAFF_NAME;
    userInfo.portraitUri = getImageAddress(orderRecordModel.STAFF_ICON).absoluteString;
    self.targetUserInfo = userInfo;
    [[RCIM sharedRCIM] refreshUserInfoCache:self.targetUserInfo withUserId:orderRecordModel.STAFF_USER_ID];
    
    
    RCUserInfo * myUserInfo = [[RCUserInfo alloc] init];
    myUserInfo.userId = orderRecordModel.USER_ID;
    myUserInfo.name = orderRecordModel.USER_NAME;
    myUserInfo.portraitUri = getImageAddress(orderRecordModel.ICON_URL).absoluteString;

    [RCIM sharedRCIM].currentUserInfo = myUserInfo;
    
    [[RCIM sharedRCIM] refreshUserInfoCache:myUserInfo withUserId:myUserInfo.userId];
    
//    @weakify(self)
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        @strongify(self)
        if ([orderRecordModel.STATUS isEqualToString:@"C"]) {
            [self.chatSessionInputBarControl setHidden:NO];
    //        self.endBottomView.hidden = YES;
            [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.chatSessionInputBarControl.inputTextView.mas_top).mas_offset(-20);
                make.right.left.equalTo(self.view);
            }];
          

        }else{
            [self.chatSessionInputBarControl setHidden:YES];
    //        self.endBottomView.hidden = NO;
            [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.view).mas_offset(-20);
                make.right.left.equalTo(self.view);
            }];
          
            
        }
//    });
//
//    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view);
////            make.bottom.equalTo(self.bottomListView.mas_top);
//        make.bottom.equalTo(self.chatSessionInputBarControl.inputTextView.mas_top).mas_offset(-20);
//        make.right.left.equalTo(self.view);
//    }];
    
   
  
    
    [self scrollToBottomAnimated:YES];
    
    [self setupPluginBoard];
    
    [self setupNav];
    
//    [self.conversationMessageCollectionView layoutIfNeeded];
}


- (void)setupPluginBoard{
    [self.chatSessionInputBarControl.pluginBoardView removeAllItems];
    
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[KykjImToolkit getImageResourceForName:@"IM_pluginImg"] title:@"图片" tag:2000];
    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:[KykjImToolkit getImageResourceForName:@"IM_pluginCamera"] title:@"拍摄" tag:2001];
    
    
//    if ([self.orderRecordModel.DZ_TYPE isEqualToString:@"DZ_FZ"]) {
//        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginDeugRecipe") title:@"病历" tag:2003];
//        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginRecipe") title:@"医嘱" tag:2007];
//    }else{
//        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginRecipe") title:@"检验检查" tag:2008];
//    }
    
    
    
//    [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginShotReplay") title:@"快捷回复" tag:2002];
    
//     [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginRecDoctor") title:@"推荐医生" tag:2004];
    
    
//    if (![system.loginUser.ORG_CODE isEqualToString:HAINANHLWYY_ORG_CODE]) {
//        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginTRTCAudio") title:@"语音通话" tag:2006];
//        [self.chatSessionInputBarControl.pluginBoardView insertItemWithImage:IMAGE_WITH_NAME(@"IM_pluginTRTC") title:@"视频通话" tag:2005];
//    }
    
    
}

/*!

 更新导航栏返回按钮中显示的未读消息数

 @discussion 如果您重写此方法，需要注意调用super。

 */

- (void)notifyUpdateUnreadMessageCount{
    [self performSelectorOnMainThread:@selector(refreshNav) withObject:nil waitUntilDone:YES];
}

/*!
 点击扩展功能板中的扩展项的回调

 @param pluginBoardView 当前扩展功能板
 @param tag             点击的扩展项的唯一标示符
 */
- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    switch (tag) {
        case 2000:
            [self actionPhoto];
            break;
        case 2001:
            [self actionCamera];
            break;
        
        default:
            break;
    }
}
- (void)didSendMessage:(NSInteger)status content:(RCMessageContent *)messageContent
{
    if ([messageContent.senderUserInfo.userId isEqualToString:self.model.userId]) {
        NSString *groupId = [NSString stringWithFormat:@"%@99999",_orderRecordModel.USER_ID];
        [[RCIM sharedRCIM] sendMessage:ConversationType_GROUP targetId:groupId content:messageContent pushContent:nil pushData:nil success:^(long messageId) {
            NSLog(@"didSendMessage ConversationType_GROUP success");
        } error:^(RCErrorCode nErrorCode, long messageId) {
            NSLog(@"didSendMessage ConversationType_GROUP fail");
        }];
    }
    
}
- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    messageCotent = [super willSendMessage:messageCotent];
    
    NSLog(@"messageCotent text:%@",messageCotent);
    
    if (self.extraModel) {
         NSMutableDictionary * extraDict = [self.extraModel mj_keyValues];
         if ([messageCotent isKindOfClass:[RCInformationNotificationMessage class]]) {
             RCInformationNotificationMessage * message = (RCInformationNotificationMessage *)messageCotent;
             if (message.extra.length > 0) {
                 [extraDict setObject:message.extra forKey:@"cancelReason"];
             }
         }
         [messageCotent setValue:[extraDict mj_JSONString]  forKey:@"extra"];
        NSLog(@"messageCotent extraDict:%@",extraDict);
        
     }
    
    return messageCotent;
}

//.1视频中-弹出提示挂断视频，2.非视频中-弹出提示，返回聊天室
- (void)leftBarButtonAction{

   //1
    if(self.kyVideoVC!=nil){
        @weakify(self)
        [LYJAlertView showConfirmAlertWithContent:@"退出后，将结束与医生问诊，确认退出？" confirmAction:^{
           @strongify(self)
            [self requestUpadateVideoInfoFunction:@"userLeft"];
            
            [self requestGetMcDzByDzId:self.orderRecordModel.DZ_ID isLeft:YES];
            
        } cancleAction:^(id  _Nonnull obj) {

        }];
       
    }
    //2
    else{
        @weakify(self)
        [LYJAlertView showConfirmAlertWithContent:@"退出后，将结束与医生问诊，确认退出？" confirmAction:^{
           @strongify(self)
            
            [self.navigationController popViewControllerAnimated:YES];
        } cancleAction:^(id  _Nonnull obj) {

        }];
    }
   
}

- (void)popGroupViewController
{
    for(UIViewController*controller in self.navigationController.viewControllers) {

    if([controller isKindOfClass:[HOIMGroupDetailViewController class]]) {

        HOIMGroupDetailViewController *revise =(HOIMGroupDetailViewController *)controller;

      [self.navigationController popToViewController:revise animated:YES];


    }
    }
}
- (void)popTargetViewController{
//    __block UIViewController * targetVC;
//    if (self.navigationController.viewControllers.count > 2) {
//        NSArray<UIViewController *> * viewControllers = [self.navigationController.viewControllers subarrayWithRange:NSMakeRange(0, self.navigationController.viewControllers.count-1)];
//
//        __block NSInteger tag = 0;
//        [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (obj.view.tag >= tag) {
//                tag = obj.view.tag;
//                targetVC = obj;
//            }
//        }];
//    }
//
//    if (targetVC) {
//        [self.navigationController popToViewController:targetVC animated:NO];
//    }else{
//        [self.navigationController popViewControllerAnimated:NO];
//    }
//
    for(UIViewController*controller in self.navigationController.viewControllers) {

    if([controller isKindOfClass:[TYMemberSearchDetailViewController class]]) {

        TYMemberSearchDetailViewController *revise =(TYMemberSearchDetailViewController *)controller;

      [self.navigationController popToViewController:revise animated:YES];


    }
    }

}

/*!
 点击Cell中的消息内容的回调

 @param model 消息Cell的数据模型

 @discussion SDK在此点击事件中，针对SDK中自带的图片、语音、位置等消息有默认的处理，如查看、播放等。
 您在重写此回调时，如果想保留SDK原有的功能，需要注意调用super。
 */
- (void)didTapMessageCell:(RCMessageModel *)model{
    if ([model.objectName isEqualToString:HOMedrMessageTypeIdentifier]){
        //电子病历消息
        WS(weakself);
        [self requetGetCaseRecordsWith:(HOMedrMessage *)model.content andCompletBlock:^(YXPatientRecordsModel *patientRecord) {
            if (patientRecord) {
                [weakself showEmrDetailVC:patientRecord];
            }
        }];

    }else if ([model.objectName isEqualToString:HOConsultMessageTypeIdentifier]){
        //咨询消息
        
        
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
//    vc.orderRecordModel = self.orderRecordModel;
//    vc.depId = recordModel.DEP_ID;
//    EMRRecordModel *model = [[EMRRecordModel alloc] init];
//    NSMutableDictionary *jsonDic = [recordModel mj_keyValues];
//    vc.emrModel = [model mj_setKeyValues:jsonDic];
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
/*!
 点击Cell中头像的回调

 @param userId  点击头像对应的用户ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
//    if (userId == self.targetId && self.targetUserInfo) {
//        HOPatientInformationViewController * vc = [[HOPatientInformationViewController alloc] init];
//        vc.patientName = self.targetUserInfo.name;
//        vc.userId = self.targetUserInfo.userId;
//        vc.portraitUri = self.targetUserInfo.portraitUri;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    if (![userId isEqualToString:self.model.userId]) {
        self.cerView.hidden = YES;
        self.cerLabel.text = [NSString stringWithFormat:@"医生资格证书编号：\n%@",self.cerNo.length>0 ? self.cerNo : @""];
        [self showCerView];
        [self performSelector:@selector(hiddenCerView) withObject:nil afterDelay:3.f];
    }

    
}
- (void)rightBarButtonItemPressed:(id)sender{

    TYHistoryReportListViewController *vc = [[TYHistoryReportListViewController alloc] init];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)sendTipsMessageForState:(NSInteger)state{
    
    NSString * tips ;
    switch (state) {
        case 0://接诊
            
            tips = @"医生已接诊";
            
            break;
        case 1://拒诊
            if([self.orderRecordModel.DZ_TYPE isEqualToString:@"DZ_KFGL_ZX"]){
                tips = @"医生已拒收，本次问诊已取消";
            }else{
                tips = @"医生已拒诊，本次问诊已取消";
            }
            
            
            break;
        case 2://恢复问诊
            tips = @"医生已恢复问诊，本次问诊可持续24小时";
            
            break;
        case 3://结束问诊
            tips = @"已结束问诊";
        case 4://结束问诊
            tips = @"本次视频结束";
      
        break;
            
        default:
            break;
    }
    
    RCInformationNotificationMessage * notification = [RCInformationNotificationMessage notificationWithMessage:tips extra:@""];
    self.notificationMessage = notification;
}


- (void)actionPhoto{
//    @weakify(self)
//    [KYToolKit checkLibraryAuthorityWithCallBack:^{
//        @strongify(self)
//        [self.chatSessionInputBarControl openSystemAlbum];
//    }];
    [self.chatSessionInputBarControl openSystemAlbum];
}
- (void)actionCamera{
    @weakify(self)
    [KykjImToolkit checkVideoAuthorityWithCallBack:^{
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.chatSessionInputBarControl openSystemCamera];
        });
        
    }];
//    [self.chatSessionInputBarControl openSystemCamera];
}

- (void)actionTRCT{
    
    @weakify(self)
    [KykjImToolkit checkVideoAuthorityWithCallBack:^{
        [KykjImToolkit checkMicroAuthorityWithCallBack:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self)

                self.kyVideoVC = [[KYTRTCVideoCallingViewController alloc]
                                                                                                                     initWithRoomId:self.orderRecordModel.DZ_ID.intValue
                                                                                                                     userId:self.orderRecordModel.USER_ID];
                self.kyVideoVC.orderRecordModel = self.orderRecordModel;
                
                [self requestUpadateVideoInfoFunction:@"userCreate"];

//                [self.navigationController addChildViewController:self.kyVideoVC];
//
                [[UIApplication sharedApplication].delegate.window addSubview:self.kyVideoVC.view];
              
//                [self.view addSubview:self.kyVideoVC.view];

                self.kyVideoVC.delegate = self;
                [self.kyVideoVC.view mas_makeConstraints:^(MASConstraintMaker *make) {

                    make.size.left.equalTo([UIApplication sharedApplication].delegate.window);
                    make.top.equalTo([UIApplication sharedApplication].delegate.window);
                }];

                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
                [self.kyVideoVC.view addGestureRecognizer:pan];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [self.kyVideoVC.view addGestureRecognizer:tap];
            });
        }];
    }];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (self.kyVideoVC.minimizeButton.selected) {
        CGPoint transP = [pan translationInView:self.kyVideoVC.view];
        self.kyVideoVC.view.transform = CGAffineTransformTranslate(self.kyVideoVC.view.transform, transP.x, transP.y);
        [pan setTranslation:CGPointZero inView:self.kyVideoVC.view];
    }
}
- (void)tap:(UIPanGestureRecognizer *)tap
{
    self.kyVideoVC.minimizeButton.selected = NO;
    self.kyVideoVC.view.transform = CGAffineTransformIdentity;
    [self changeKyVideoVCMinize:NO];
}
//退出视频流程：1.用户主动挂断 2.用户点击返回（挂断视频且结束问诊） 3.医生挂断视频 4.医生开诊断报告（挂断视频且结束问诊） 5.用户等待超时自动挂断视频
- (void)hungUpDelegateActionWithType:(NSString *)type
{
    if (self.kyVideoVC!=nil) {
//        [self.kyVideoVC.trtcCloud stopLocalPreview];
//        [self.kyVideoVC.trtcCloud exitRoom];
        [self.kyVideoVC stopAndQuit];
    }
    [self.kyVideoVC.view removeFromSuperview];
    [self.kyVideoVC removeFromParentViewController];
    self.kyVideoVC = nil;
//    if ([type isEqualToString:@"2"]) {
        [self requestUpadateVideoInfoFunction:@"userLeft"];
        
//    }
    [self requestGetMcDzByDzId:self.orderRecordModel.DZ_ID isLeft:NO];
//    if ([_orderRecordModel.STATUS isEqualToString:@"D"]) {
//        [self requestEndStatus:NO];
//    }
//    [self requestGetMcDz];
//    [self requestUpadateVideoInfoFunction:@"userLeft" isPop:NO];
}
- (void)minizeDelegateAction:(BOOL)isMin
{
    
    [self changeKyVideoVCMinize:YES];
    
}

- (void)changeKyVideoVCMinize:(BOOL)isMin
{
    self.kyVideoVC.hungUpButton.hidden = isMin;
    self.kyVideoVC.muteButton.hidden = isMin;
    self.kyVideoVC.speakerButton.hidden = isMin;
    self.kyVideoVC.minimizeButton.hidden = isMin;
    
    self.kyVideoVC.waiteHungButton.hidden = isMin;


    if (isMin)
    {
        
        self.kyVideoVC.collectionView.scrollEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.kyVideoVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,  .25f, .2f);
        }];
    }
    else
    {
        [self.chatSessionInputBarControl.inputTextView resignFirstResponder];
        self.kyVideoVC.collectionView.scrollEnabled = YES;
        self.kyVideoVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,  1, 1);
 
        
    }
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.navigationController.view layoutIfNeeded];
//    }];
}

#pragma mark -- NET
//(超时未接诊，医生未接诊时患者挂断时调用)
- (void)requestEndStatus:(BOOL)isPop{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@"tyCancelStatus" forKey:@"method"];
    [tempDict setObject:self.orderRecordModel.DZ_ID forKey:@"dzId"];
    [tempDict setObject:@"dzService" forKey:@"service"];
    
    WS(weakself)
    MBProgressHUDShowInThisView;
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO showLog:YES needEncryption:NO  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
//            [[NSNotificationCenter defaultCenter] postNotificationName:kDZConsultStatusUpdateNoti object:tempDict[@"dzId"]];
//            [weakself sendTipsMessageForState:3];
//            [weakself requestGetMcDz];
            if (weakself.kyVideoVC!=nil) {
                [weakself requestUpadateVideoInfoFunction:@"userLeft"];
            }
            
            if (isPop) {
                [weakself popTargetViewController];
            }else{
                [weakself.navigationController popViewControllerAnimated:NO];
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
- (void)getStaffLicenseInfo{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@"getStaffLicenseInfo" forKey:@"method"];
    [tempDict setObject:_orderRecordModel.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:@"consultService" forKey:@"service"];
    
    WS(weakself)
    MBProgressHUDShowInThisView;
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO showLog:YES needEncryption:NO  success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:weakself.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSDictionary *rowsDic = [responseObject objectForKey:@"rows"];
            if (![rowsDic isEqual:[NSNull null]]){
                weakself.cerNo = rowsDic[@"PHYSICIAN_CERTIFICATE"];
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
- (void)requestUpadateVideoInfoFunction:(NSString*)function
{
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
     [tempDict setObject:@"updateVideoInfo" forKey:@"method"];
     [tempDict setObject:self.orderRecordModel.DZ_ID forKey:@"dzId"];
    [tempDict setObject:self.orderRecordModel.DZ_ID forKey:@"roomId"];
//    [tempDict setObject:self.orderRecordModel.DZ_ID forKey:@"videoId"];
    [tempDict setObject:self.orderRecordModel.USER_ID forKey:@"userId"];
    [tempDict setObject:self.orderRecordModel.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:function forKey:@"function"];
     [tempDict setObject:@"dzService" forKey:@"service"];
     
     @weakify(self)
    MBProgressHUDShowInThisView;
     [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO showLog:YES needEncryption:NO  success:^(id responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         @strongify(self)
         NSString * result = responseObject[@"result"];
         if([result isEqualToString:@"success"]){
            
            
             if ([[tempDict objectForKey:@"function"] isEqualToString:@"userCreate"]){
                 [self requestUpadateVideoInfoFunction:@"userEnter"];
             }
             else if([[tempDict objectForKey:@"function"] isEqualToString:@"userEnter"]){
                 [self requestGetCountInLine];
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
         @strongify(self)
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)requestGetCountInLine
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"dzService" forKey:@"service"];
    [param setObject:@"getCountInLine" forKey:@"method"];
    [param setObject:self.orderRecordModel.USER_ID forKey:@"userId"];
    [param setObject:self.orderRecordModel.DZ_ID forKey:@"dzId"];
    
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:NO success:^(id responseObject) {
      @strongify(self)

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (responseObject!=nil) {

//            system.TOKEN = getSafeString(responseObject[@"token"]);
            if ([responseObject[@"result"] isEqualToString:@"success"]) {
                if (responseObject[@"count"]!=nil) {
                    
                    if ([responseObject[@"count"] intValue] >0) {
                        self.kyVideoVC.countString = responseObject[@"count"];
                    }
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
     
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        @strongify(self)

          [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showHint:@"网络连接失败" yOffset:-ScreenHeight/2];
    }];
}

#pragma mark -- NET
//挂断视频，查询订单状态
- (void)requestGetMcDzByDzId:(NSString*)dzId isLeft:(BOOL)isLeft{
    
    MBProgressHUDShowInThisView;
    
   NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@(0) forKey:@"MIN_ROWS"];
    [tempDict setObject:@(1) forKey:@"MAX_ROWS"];
    [tempDict setObject:@"getMcDz" forKey:@"method"];
    [tempDict setObject:dzId forKey:@"dzId"];
    [tempDict setObject:@"dzService" forKey:@"service"];
    [tempDict setObject:@"C,R,J,D" forKey:@"statusList"];

    [tempDict setObject:@"DZ_ZX_TXT" forKey:@"dzTypeList"];
  
   
    
//    WS(weakself)
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO success:^(id responseObject) {
        @strongify(self)
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSArray * arrayTemp = [YXOrderRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"dzList"]];
            if (arrayTemp.count > 0) {
                self.orderRecordModel = arrayTemp[0];
                if (!self.orderRecordModel || ![self.orderRecordModel isEqualWithOrderRecord:arrayTemp[0]]) {
                    
                    //待接诊/超时未接诊，患者自己结束订单
                    if ([self.orderRecordModel.STATUS isEqualToString:@"D"]) {
//                        [LYJAlertView showConfirmAlertWithContent:@"退出后，将结束与医生问诊，确认退出？" confirmAction:^{
//                            if (self.kyVideoVC!=nil) {
//                                [self hungUpDelegateActionWithType:@"2"];
//                            }
//
//                            [self requestEndStatus:YES];
//                        } cancleAction:^(id  _Nonnull obj) {
//
//                        }];
                        
//                        if (self.kyVideoVC!=nil) {
//                            [self hungUpDelegateActionWithType:@"2"];
//                        }
                        
                        [self requestEndStatus:NO];
                        
                    }
//                    //超时未接诊/拒诊
                    else if ([self.orderRecordModel.STATUS isEqualToString:@"R"]){
                        
                        [self popGroupViewController];
                    }
//
                    else if([self.orderRecordModel.STATUS isEqualToString:@"C"]){

//                        [self.chatSessionInputBarControl setHidden:NO];
//                        self.endBottomView.hidden = YES;
                        
                        if (isLeft) {
                            [self.kyVideoVC stopAndQuit];
                            [self.kyVideoVC.view removeFromSuperview];
                            [self.kyVideoVC removeFromParentViewController];
                            self.kyVideoVC = nil;
                            [self.navigationController popViewControllerAnimated:YES];
                           
                        }
                        

                    }
//                    else if([self.orderRecordModel.STATUS isEqualToString:@"F"]){
//
////                        [self.chatSessionInputBarControl setHidden:YES];
////                        self.endBottomView.hidden = NO;
//
//                    }
                    
                    else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            }else{
//                [LeafNotification showInController:self withText:@"没有查到此订单"];
//                [self popTargetViewController];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)requestGetMcDz:(BOOL)isMainThread{
    
   NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@(0) forKey:@"MIN_ROWS"];
    [tempDict setObject:@(1) forKey:@"MAX_ROWS"];
    [tempDict setObject:@"getMcDz" forKey:@"method"];
    [tempDict setObject:_orderRecordModel.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:@"dzService" forKey:@"service"];
    [tempDict setObject:@"C,R,J,D" forKey:@"statusList"];

    [tempDict setObject:@"DZ_ZX_TXT" forKey:@"dzTypeList"];
  
    [tempDict setObject:self.orderRecordModel.USER_ID forKey:@"opUserId"];
    [tempDict setObject:@"" forKey:@"orderBy"];
    
//    WS(weakself)
    @weakify(self)
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO success:^(id responseObject) {
        @strongify(self)
       
    
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            
            NSArray * arrayTemp = [YXOrderRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"dzList"]];
            if (arrayTemp.count > 0) {
//                if (!self.orderRecordModel || ![self.orderRecordModel isEqualWithOrderRecord:arrayTemp[0]]) {
                    self.orderRecordModel = arrayTemp.firstObject;
                [self getStaffLicenseInfo];
//                }
                if (self.notificationMessage) {
                    [self sendMessage:self.notificationMessage pushContent:self.notificationMessage.message];
                    self.notificationMessage = nil;
                }
                
            }else{
                [LeafNotification showHint:@"没有查到此订单" yOffset:100];
                if (!isMainThread) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

                        // Do something...

                        dispatch_async(dispatch_get_main_queue(),^{

                            [MBProgressHUD hideHUDForView:self.view animated:YES];

                        });

                    });
                }
                
            }
        }else{
            if (!isMainThread) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

                    // Do something...

                    dispatch_async(dispatch_get_main_queue(),^{

                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    });

                });
            }
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
        if (!isMainThread) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

                // Do something...

                dispatch_async(dispatch_get_main_queue(),^{

                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                });

            });
        }
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
//        MBProgressHUDHideAllInThisView(weakself);
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
- (UIView*)endBottomView
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
    if (!_endBottomView) {
        _endBottomView = [[UIView alloc] init];
//        _endBottomView.hidden = YES;
        [self.view addSubview:_endBottomView];
        _endBottomView.backgroundColor = [UIColor whiteColor];
        [_endBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.chatSessionInputBarControl.inputTextView.mas_top).mas_offset(-20);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(5);
        }];
    }
    return _endBottomView;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
        _titleLabel.text = @"聊天室";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _titleLabel;
    
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
    }
    return _rightButton;
}
- (UIButton*)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
        [_leftButton setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    //    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
@end

