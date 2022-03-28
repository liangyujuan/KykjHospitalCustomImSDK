//
//  TYMemberSearchDetailViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/10.
//  Copyright © 2022 cc. All rights reserved.
//

#import "TYMemberSearchDetailViewController.h"
#import "HOIMGroupDetailViewController.h"
#import "HOIMDetailViewController.h"
#import "Factory.h"
#import "HOIMHelper.h"
#import "MJExtension.h"

@interface TYMemberSearchDetailViewController ()

@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userSexLabel;
@property (nonatomic, strong) UILabel *userAgeLabel;
@property (nonatomic, strong) UILabel *isMyLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *videoImg;

@property (nonatomic, strong) UIButton *videoingButton;

@end

@implementation TYMemberSearchDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar lt_setBackgroundColor:colorBackground];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"健康问诊";
//    self.navigationController.navigationBarHidden = NO;
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNav];
    
    
//
//    self.navigationController.navigationBar.translucent = NO;
    
//    self.view.backgroundColor = RGB(249, 249, 249);

    [self setSubViews];
    [self requestLoginIm:self.model];
    // Do any additional setup after loading the view.
}
- (void)setupNav{
    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
    

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
    titleLabel.text = @"健康问诊";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
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
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 10.f;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
        make.height.mas_equalTo(70);
    }];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestGetMcDz)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoAction)];
    [bgView addGestureRecognizer:tap];
    
    _headerImg = [[UIImageView alloc] init];
    [_headerImg sd_setImageWithURL:[NSURL URLWithString:_model.userIcon] placeholderImage:[KykjImToolkit getImageResourceForName:@"defaultPatientIcon"]];
    [bgView addSubview:_headerImg];
    [_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.top.equalTo(bgView).mas_offset(15);
    }];
//    headerImg sd_setImageWithURL:<#(nullable NSURL *)#> placeholderImage:<#(nullable UIImage *)#>
    
//    self.userName.text = _tyModel.USER_NAME;
//    self.userAge.text = [NSString stringWithFormat:@"%@岁",_tyModel.USER_AGE];
//    NSString * sex = _tyModel.USER_SEX.intValue==1?@"男":@"女";
    
    _userNameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).addToSuperView(bgView);
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImg.mas_right).mas_offset(10);
        make.top.equalTo(bgView).mas_offset(15);
    }];
    
    _userSexLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:15]).addToSuperView(bgView);
    }];
    [_userSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).mas_offset(10);
        make.top.equalTo(bgView).mas_offset(15);
    }];
    
    _userAgeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:15]).addToSuperView(bgView);
    }];
    [_userAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userSexLabel.mas_right).mas_offset(10);
        make.top.equalTo(bgView).mas_offset(15);
    }];
    
    _isMyLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"[本人]").textColor(RGB(1, 111, 255)).font([UIFont boldSystemFontOfSize:15]).addToSuperView(bgView);
    }];
    [_isMyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAgeLabel.mas_right).mas_offset(10);
        make.top.equalTo(bgView).mas_offset(15);
    }];
    
    _countLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(153, 153, 153)).numberOfLines(0).font([UIFont systemFontOfSize:12]).addToSuperView(bgView);
    }];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel);
        make.top.equalTo(self.userSexLabel.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(ScreenWidth-80-75-30-10);
    }];
    
    UIView *videoBgView = [[UIView alloc] init];
    videoBgView.backgroundColor = RGB(1, 111, 255);
    videoBgView.layer.cornerRadius = 10.f;
    [bgView addSubview:videoBgView];
    [videoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.right.equalTo(bgView).mas_offset(-12.5);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(75);
    }];
    
   
    
    _videoImg = [[UIImageView alloc] init];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:path];
//    NSString *file = [bundle pathForResource:@"arrow_left" ofType:@"png"];
//    UIImage *img = [UIImage imageWithContentsOfFile:file];
    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK.bundle" ofType:nil];
//    NSBundle *bundle = [NSBundle bundleWithPath:path];
//
//    _videoImg.image = [UIImage imageNamed:@"ty_member_video" inBundle:bundle compatibleWithTraitCollection:nil];
    
//

    _videoImg.image = [KykjImToolkit getImageResourceForName:@"ty_member_video"];
    [videoBgView addSubview:_videoImg];
    [_videoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.top.equalTo(videoBgView).mas_offset(5);
        make.centerX.equalTo(videoBgView);
    }];
    
    UILabel *videoLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"进入聊天").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:15]).addToSuperView(videoBgView);
    }];
    [videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(videoBgView);
        make.top.equalTo(self.videoImg.mas_bottom).mas_offset(2);
    }];
    
    _videoingButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"视频中",UIControlStateNormal).titleColorForState(RGB(1, 111, 255),UIControlStateNormal).titleFont([UIFont systemFontOfSize:14]).imageForState([KykjImToolkit getImageResourceForName:@"ty_videoing"],UIControlStateNormal).addToSuperView(bgView);
    }];
    [_videoingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(24);
        make.centerY.equalTo(self.countLabel);
        make.right.equalTo(videoBgView.mas_left);
    }];
    _videoingButton.hidden = YES;
    
    _userNameLabel.text = _model.nameCn.length>0 ? _model.nameCn : @"";
    _userSexLabel.text = [_model.gender isEqualToString:@"1"] ? @"男" : @"女";
    NSString *age = [KykjImToolkit getIdentityCardAge:_model.idCard].length>0 ? [NSString stringWithFormat:@"%@岁",[KykjImToolkit getIdentityCardAge:_model.idCard]] : @"";
    _userAgeLabel.text = age;
    _countLabel.text = [NSString stringWithFormat:@"问诊可用次数：%d",_model.countLeft.intValue];
    

    
    if (_model.onBehalf.intValue == 1) {
        _isMyLabel.text= @"[本人]";
    }else{
        _isMyLabel.text = @"";
    }

}
- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)videoAction
{
    NSString *groupId = [NSString stringWithFormat:@"%@99999",_model.userId];
    HOIMGroupDetailViewController *vc = [[HOIMGroupDetailViewController alloc] initWithConversationType:ConversationType_GROUP targetId:groupId];
    
    vc.model = self.model;

    RCUserInfo *myUserInfo = [[RCUserInfo alloc] init];
    myUserInfo.userId = self.model.userId;
    myUserInfo.name = self.model.nameCn;
    myUserInfo.portraitUri = self.model.userIcon;
    [RCIM sharedRCIM].currentUserInfo = myUserInfo;

    [[RCIM sharedRCIM] refreshUserInfoCache:myUserInfo withUserId:myUserInfo.userId];
    
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}



- (void)pushVideo:(YXOrderRecordModel*)orderModel
{
    
    HOIMDetailViewController * vc = [[HOIMDetailViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:orderModel.STAFF_USER_ID];
    vc.isNeedPopTargetViewController = NO;
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.model = self.model;
    if(self.model.isInChatRoom.intValue == 1){
        vc.myRoomId = orderModel.DZ_ID;
    }
    
    vc.orderRecordModel = orderModel;
   

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
    
    //视频中
    if (_model.isInChatRoom.intValue == 1) {
        vc.isStartVideo = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestLoginIm:(TYMemberModel*)model
{
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:model.userId,@"userId",model.ryToken,@"token", nil];
//    [system saveRongYunInfo:[NSMutableDictionary dictionaryWithDictionary:dic]];
    [[HOIMHelper shareInstance] connectRongYunIMServerWithUserModel:model];
}
//- (void)requestDzid
//{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@"dzService" forKey:@"service"];
//    [param setObject:@"getLatestConsult" forKey:@"method"];
//    [param setObject:self.model.userId forKey:@"userId"];
//    [param setObject:[[SystemHelper shareInstance] getUniqueStrByUUID] forKey:@"uuid"];
//
//
//    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:NO success:^(id responseObject) {
//
//
//            if ([responseObject[@"result"] isEqualToString:@"success"]) {
//                NSDictionary *dzDic = [responseObject objectForKey:@"dzInfo"];
//                if(dzDic!=nil){
//                    NSString *dzId = [dzDic objectForKey:@"dzId"];
//                    if(dzId.length>0){
//                        [self videoAction:dzId];
//                    }else{
//                        [self videoAction:@""];
//                    }
//                }else{
//                    [self videoAction:@""];
//                }
//            }else{
//                NSString *msgString = getSafeString(responseObject[@"info"]);
//                if (msgString.length > 0) {
//                    [LeafNotification showInController:self withText:msgString];
//                }else
//                    [LeafNotification showInController:self withText:@"系统错误，请稍后再试！"];
//            }
//    } failure:^(NSError *error) {
//        CXTLog(@"error:%@",error.userInfo);
//
//        [LeafNotification showInController:[KYToolKit getCurrentVC] withText:error.userInfo];
//    }];
//}

- (void)requestGetMcDz{
    
//    MBProgressHUDShowInThisView;
    
   NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
    [tempDict setObject:@(0) forKey:@"MIN_ROWS"];
    [tempDict setObject:@(1) forKey:@"MAX_ROWS"];
    [tempDict setObject:@"getMcDz" forKey:@"method"];
//    [tempDict setObject:system.loginInfo.STAFF_ID forKey:@"staffId"];
    [tempDict setObject:@"dzService" forKey:@"service"];
    [tempDict setObject:@"C,R,J,D" forKey:@"statusList"];

    [tempDict setObject:@"DZ_ZX_TXT" forKey:@"dzTypeList"];
  
    [tempDict setObject:self.model.userId forKey:@"opUserId"];
    [tempDict setObject:@"" forKey:@"orderBy"];
    
    WS(weakself)
  
    [HttpOperationManager HTTP_POSTWithParameters:tempDict showAlert:NO success:^(id responseObject) {
       
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSArray * arrayTemp = [YXOrderRecordModel mj_objectArrayWithKeyValuesArray:responseObject[@"dzList"]];
            if (arrayTemp.count > 0) {
                YXOrderRecordModel *orderRecordModel = arrayTemp[0];
                
//                    [self requestUpadateVideoInfo:self.orderRecordModel];
                if ([orderRecordModel.STATUS isEqualToString:@"C"]) {
                    [weakself pushVideo:orderRecordModel];
                }
                else{
                    [weakself videoAction];
                }
               
            }else{
                [weakself videoAction];
//                [LeafNotification showInController:self withText:@"没有查到此订单"];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
