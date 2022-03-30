//
//  KYTRTCVideoCallingViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/2/25.
//  Copyright © 2022 cc. All rights reserved.
//

#import "KYTRTCVideoCallingViewController.h"
#import "GenerateTestUserSig.h"
#import "KyVideoRenderCollectionViewCell.h"
#import "Factory.h"

#import <ImSDK/V2TIMManager.h>
#import <ImSDK/V2TIMManager+Signaling.h>

#import "TRTCCallingUtils.h"
#import "TRTCCallingHeader.h"
#import "TRTCCalling.h"
//#import "TRTCCallingDelegate.h"
#import "TRTCCalling+Signal.h"

@import TXLiteAVSDK_TRTC;

static const NSInteger maxRemoteUserNum = 9;

@interface KYTRTCVideoCallingViewController ()<TRTCCloudDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TRTCCallingDelegate>

@property (assign, nonatomic) UInt32 roomId;
@property (strong, nonatomic) NSString* userId;

@property (strong, nonatomic) NSMutableOrderedSet *remoteUidSet;
@property (assign, nonatomic) BOOL isFrontCamera;

@property (nonatomic, strong) NSMutableArray *showUserArray;

@property (nonatomic, strong) UIView *callWaitingView;

@property (nonatomic, strong) UIView *centerTempView;

@property (nonatomic, strong) UILabel *callingTimeLabel;

@property (nonatomic, strong) UILabel *waiteTimeLabel;

@property (nonatomic, strong) UILabel *waitTitleLabel;
@property (nonatomic, strong) UILabel *waiteCountLabel;
@property (nonatomic, strong) UIImageView *doctorHeaderImg;
@property (nonatomic, strong) UILabel *doctorNameLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSTimer *callTimeTimer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, assign) NSInteger callTimeCount;

@end

@implementation KYTRTCVideoCallingViewController

//- (void)addSimpleMsgListener{
//    [[V2TIMManager sharedInstance] addSimpleMsgListener:self];
//}
//
//- (void)removeSimpleMsgListener {
//    [[V2TIMManager sharedInstance] removeSimpleMsgListener:self];
//}

- (TRTCCloud*)trtcCloud {
    if (!_trtcCloud) {
        _trtcCloud = [TRTCCloud sharedInstance];
//        [self addSimpleMsgListener];
    }
    return _trtcCloud;
}

- (NSMutableOrderedSet *)remoteUidSet {
    if (!_remoteUidSet) {
        _remoteUidSet = [[NSMutableOrderedSet alloc] initWithCapacity:maxRemoteUserNum];
    }
//    if (_remoteUidSet.count > 1) {
//        _callWaitingView.hidden = YES;
//    }else{
//
//        _callWaitingView.hidden = NO;
//    }
    for (NSString *uId in _remoteUidSet) {
        if ([uId isEqualToString:self.orderRecordModel.STAFF_USER_ID]) {
            _callWaitingView.hidden = YES;
            break;
        }
    }
    return _remoteUidSet;
}


- (instancetype)initWithRoomId:(UInt32)roomId userId:(NSString *)userId {
    self = [super init];
    if (self) {
        _roomId = roomId;
        _userId = userId;
        _showUserArray = [NSMutableArray array];
        
        [[TRTCCalling shareInstance] addDelegate:self];
//        [[TRTCCalling shareInstance] addSimpleMsgListener];
        
        

    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFrontCamera = YES;
    self.trtcCloud.delegate = self;

    
    [self setupTRTCCloud];
    
    [self.timer fire];
    
//    [self.view sendSubviewToBack:self.view];
    // Do any additional setup after loading the view.
}
- (void)setSubViews
{
    self.view.backgroundColor = [UIColor blackColor];
    
    float collectionCellH = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 80 - 30 - 10);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake([UIApplication sharedApplication].delegate.window.bounds.size.width, collectionCellH);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
//    layout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
//    _collectionView.layer.cornerRadius = 10.f;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[KyVideoRenderCollectionViewCell class] forCellWithReuseIdentifier:@"KyVideoRenderCollectionViewCell"];
   
//    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
        make.top.equalTo(self.view);
//        make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.hungUpButton.mas_top).mas_offset(-10);
        make.height.mas_equalTo(collectionCellH);
    }];
    _collectionView.hidden = NO;
    
    _minimizeButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.titleForState(@"缩放",UIControlStateNormal).titleColorForState([UIColor whiteColor],UIControlStateNormal).titleFont([UIFont boldSystemFontOfSize:20]).imageForState([KykjImToolkit getImageResourceForName:@"video_calling_miniz"],UIControlStateNormal).addAction(self,@selector(minimizAction:),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    [_minimizeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_minimizeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_minimizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(110);
        make.top.equalTo(self.view).mas_offset(StatuBarHeight+10);
        make.left.equalTo(self.view).mas_offset(15);
//        make.bottom.equalTo(self.view).mas_offset(-120);
//        make.left.equalTo(self.hungUpButton.mas_right).mas_offset(50);
    }];
    
    _minimizeButton.selected = NO;
    
    
    _callingTimeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"00:01").textAlignment(NSTextAlignmentCenter).textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:20]).addToSuperView(self.view);
    }];
    [_callingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.minimizeButton);
        make.centerX.equalTo(self.view);
//        make.right.equalTo(self.callWaitingView).mas_offset(-15);
    }];
    
    _hungUpButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState([KykjImToolkit getImageResourceForName:@"calling_ic_hangup"],UIControlStateNormal).addAction(self,@selector(hungUpAction),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    [_hungUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-30);
    }];
    
    _muteButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState([KykjImToolkit getImageResourceForName:@"ic_mute"],UIControlStateNormal).imageForState([KykjImToolkit getImageResourceForName:@"ic_mute_on"],UIControlStateSelected).addAction(self,@selector(muteAction:),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    [_muteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerY.equalTo(self.hungUpButton);
//        make.bottom.equalTo(self.view).mas_offset(-120);
        make.right.equalTo(self.hungUpButton.mas_left).mas_offset(-50);
    }];
    
    _speakerButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState([KykjImToolkit getImageResourceForName:@"ic_camera_change"],UIControlStateNormal).imageForState([KykjImToolkit getImageResourceForName:@"ic_camera_change"],UIControlStateSelected).addAction(self,@selector(speakerAction:),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    [_speakerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerY.equalTo(self.hungUpButton);
//        make.bottom.equalTo(self.view).mas_offset(-120);
        make.left.equalTo(self.hungUpButton.mas_right).mas_offset(50);
    }];
    
    
    [_collectionView reloadData];
    
    _callWaitingView = [[UIView alloc] init];
    _callWaitingView.backgroundColor = [UIColor blackColor];
    _callWaitingView.userInteractionEnabled = YES;
    [self.view addSubview:_callWaitingView];
    [_callWaitingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(0);
    }];
    
    _waitTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"等待医生接听...").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:20]).addToSuperView(self.callWaitingView);
    }];
    [_waitTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.callWaitingView).mas_offset(22+NavStaHeight);
        make.centerX.equalTo(self.callWaitingView);
    }];
    
    _centerTempView = [[UIView alloc] init];
    [self.callWaitingView addSubview:_centerTempView];
    
    [_centerTempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self.callWaitingView);
        make.top.equalTo(self.waitTitleLabel.mas_bottom).mas_offset(15);
    }];
    _waiteTimeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"已等待1秒钟").textAlignment(NSTextAlignmentCenter).textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont systemFontOfSize:18]).addToSuperView(self.callWaitingView);
    }];
    [_waiteTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waitTitleLabel.mas_bottom).mas_offset(15);
//        make.left.equalTo(self.callWaitingView).mas_offset(15);
        make.centerX.equalTo(self.callWaitingView);
//        make.right.equalTo(self.callWaitingView).mas_offset(-15);
    }];
    
    _waiteCountLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textAlignment(NSTextAlignmentLeft).textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont systemFontOfSize:18]).addToSuperView(self.callWaitingView);
    }];
    _waiteCountLabel.hidden = YES;
    [_waiteCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waitTitleLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.centerTempView.mas_right);
//        make.right.equalTo(self.callWaitingView).mas_offset(-15);
    }];
    
    _doctorHeaderImg = [[UIImageView alloc] init];
    [_doctorHeaderImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",getImageAddress(_orderRecordModel.STAFF_ICON).absoluteString]] placeholderImage:[KykjImToolkit getImageResourceForName:@"video_doctor_header_default"]];
    _doctorHeaderImg.layer.cornerRadius = 10.f;
    [_callWaitingView addSubview:_doctorHeaderImg];
    [_doctorHeaderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.top.equalTo(self.waiteCountLabel.mas_bottom).mas_offset(50);
        make.centerX.equalTo(self.callWaitingView);
    }];
    
    
    _doctorNameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(getSafeString(self.orderRecordModel.STAFF_NAME)).textColor([UIColor whiteColor]).textAlignment(NSTextAlignmentCenter).numberOfLines(0).font([UIFont systemFontOfSize:18]).addToSuperView(self.callWaitingView);
    }];
    [_doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.doctorHeaderImg.mas_bottom).mas_offset(30);
        make.left.equalTo(self.callWaitingView).mas_offset(15);
        make.right.equalTo(self.callWaitingView).mas_offset(-15);
    }];
    
    _waiteHungButton = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState([KykjImToolkit getImageResourceForName:@"calling_ic_hangup"],UIControlStateNormal).addAction(self,@selector(hungUpAction),UIControlEventTouchUpInside).addToSuperView(self.view);
    }];
    [_waiteHungButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-30);
    }];
    [_callWaitingView addSubview:_waiteHungButton];
    
}
- (void)setupTRTCCloud {
    [self.remoteUidSet removeAllObjects];
    [self.remoteUidSet insertObject:_userId atIndex:0];
    [self.trtcCloud startLocalPreview:_isFrontCamera view:self.collectionView];
    
    TRTCParams *params = [TRTCParams new];
    params.sdkAppId = SDKAppID;
    params.roomId = _roomId;
    params.userId = _userId;
    params.role = TRTCRoleAnchor;
    params.userSig = [GenerateTestUserSig genTestUserSig:params.userId];
    
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
    
    TRTCVideoEncParam *encParams = [TRTCVideoEncParam new];
    encParams.videoResolution = TRTCVideoResolution_640_360;
    encParams.videoBitrate = 550;
    encParams.videoFps = 15;
    
    [self.trtcCloud setVideoEncoderParam:encParams];
    [self.trtcCloud startLocalAudio:TRTCAudioQualityMusic];
    
    [self setSubViews];
}

- (void)dealloc {
    [self.trtcCloud exitRoom];
    [TRTCCloud destroySharedIntance];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_callTimeTimer) {
        [_callTimeTimer invalidate];
        _callTimeTimer = nil;
    }
    
//    [self removeSimpleMsgListener];
}
//患者挂断
- (void)hungUpAction
{
//    sender.selected = !sender.selected;
//    if ([sender isSelected]) {
//        [_trtcCloud stopLocalPreview];
//    } else {
//        [_trtcCloud startLocalPreview:_isFrontCamera view:self.view];
//    }
    if ([self.delegate respondsToSelector:@selector(hungUpDelegateActionWithType:)]) {
        [_trtcCloud stopLocalPreview];
        [_trtcCloud exitRoom];
        [TRTCCloud destroySharedIntance];
//        [self removeSimpleMsgListener];
        [self.delegate hungUpDelegateActionWithType:@"2"];
    }
    
}
//医生挂断
- (void)hungUpDoctorAction
{
//    sender.selected = !sender.selected;
//    if ([sender isSelected]) {
//        [_trtcCloud stopLocalPreview];
//    } else {
//        [_trtcCloud startLocalPreview:_isFrontCamera view:self.view];
//    }
    if ([self.delegate respondsToSelector:@selector(hungUpDelegateActionWithType:)]) {
        [_trtcCloud stopLocalPreview];
        [_trtcCloud exitRoom];
        [TRTCCloud destroySharedIntance];
//        [self removeSimpleMsgListener];
        [self.delegate hungUpDelegateActionWithType:@"1"];
    }
    
}
- (void)muteAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if ([sender isSelected]) {
        [_trtcCloud muteLocalAudio:true];
    } else {
        [_trtcCloud muteLocalAudio:false];
    }
}
- (void)speakerAction:(UIButton*)sender
{
    sender.selected = !sender.selected;
    [self.trtcCloud stopLocalPreview];
    if ([sender isSelected]) {
//        [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteEarpiece];
        _isFrontCamera = NO;
        [self.trtcCloud startLocalPreview:_isFrontCamera view:self.collectionView];
    } else {
        _isFrontCamera = YES;
        [self.trtcCloud startLocalPreview:_isFrontCamera view:self.collectionView];
//        [[_trtcCloud getDeviceManager] setAudioRoute:TXAudioRouteSpeakerphone];
    }
    [_collectionView reloadData];
}
- (void)minimizAction:(UIButton*)sender
{
    sender.selected = YES;
    if ([self.delegate respondsToSelector:@selector(minizeDelegateAction:)]) {
        [self.delegate minizeDelegateAction:YES];
    }
}

#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _remoteUidSet.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KyVideoRenderCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"KyVideoRenderCollectionViewCell" forIndexPath:indexPath];
//    item.delegate = self;
//    item.row = indexPath.row;
//    item.itemModel = _dataSource[indexPath.row];
    item.trtcCloud = _trtcCloud;
    [item setCellWithUserId:_remoteUidSet[indexPath.row] orderUserId:_orderRecordModel.USER_ID];
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_remoteUidSet.count<=1) {
        float collectionCellH = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 80 - 30 - 10);
//        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
//            make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width);
//            make.right.equalTo(self.view);
//            make.height.mas_equalTo(([AppDelegate sharedAppDelegate].window.bounds.size.height - 30 - 80 - 30 - StatuBarHeight - 10 - 10));
//        }];
        return  CGSizeMake([UIApplication sharedApplication].delegate.window.bounds.size.width, collectionCellH);
    }
    else if (_remoteUidSet.count==2) {
        float collectionCellH = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 80 - 30 - 10)/2;
//        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
//            make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width);
//            make.right.equalTo(self.view);
//            make.height.mas_equalTo(([AppDelegate sharedAppDelegate].window.bounds.size.height - 30 - 80 - 30 - StatuBarHeight - 10 - 10));
//        }];
        return  CGSizeMake([UIApplication sharedApplication].delegate.window.bounds.size.width, collectionCellH);
    }
    else{
        float collectionCellH = ([UIApplication sharedApplication].delegate.window.bounds.size.height - 80 - 30 - 10)/2;
//        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
//            make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width);
//            make.right.equalTo(self.view);
//            make.height.mas_equalTo(([AppDelegate sharedAppDelegate].window.bounds.size.height - 30 - 80 - 30 - StatuBarHeight - 10 - 10));
//        }];
        return  CGSizeMake([UIApplication sharedApplication].delegate.window.bounds.size.width/2 , collectionCellH);
    }
}

#pragma mark - TRTCCloud Delegate

- (void)onRemoteUserLeaveRoom:(NSString *)userID reason:(NSInteger)reason
{
//    NSInteger index = [self.remoteUidSet indexOfObject:uid];
    if ([self.remoteUidSet containsObject:userID]) {
        [_trtcCloud stopRemoteView:userID streamType:TRTCVideoStreamTypeSmall];
        [self.remoteUidSet removeObject:userID];
        
    }
    NSLog(@"=========onRemoteUserLeaveRoom remoteUidSet:%@",_remoteUidSet);
    //医生退出房间
    if ([userID isEqualToString:self.orderRecordModel.STAFF_USER_ID]) {
//        [SVProgressHUD showInfoWithStatus:@"医生已经退出视频，此次视频问诊结束"];
//        [SVProgressHUD dismissWithDelay:2.0f];
        [LeafNotification showHint:@"医生已经退出视频，此次视频问诊结束" yOffset:100];
        [self performSelector:@selector(hungUpDoctorAction) withObject:nil afterDelay:2.0f];
    }
    [_collectionView reloadData];
//    [self refreshRemoteVideoViews];
}
- (void)onRemoteUserEnterRoom:(NSString *)userID
{
//    NSInteger index = [self.remoteUidSet indexOfObject:uid];
    if (![self.remoteUidSet containsObject:userID]) {
        if ([userID isEqualToString:_userId]) {
            [self.remoteUidSet insertObject:userID atIndex:0];
        }else{
            [self.remoteUidSet addObject:userID];
        }
        
    }
//    [self.view layoutIfNeeded];
    NSLog(@"=========onRemoteUserEnterRoom remoteUidSet:%@",_remoteUidSet);
    
    if ([userID isEqualToString:self.orderRecordModel.STAFF_USER_ID]) {
//        [SVProgressHUD showInfoWithStatus:@"医生已经进入视频"];
//        [SVProgressHUD dismissWithDelay:2.0f];
        [LeafNotification showHint:@"医生已经进入视频" yOffset:100];
        [_timer invalidate];
        _timer = nil;
        
        [self.callTimeTimer fire];
        
        if (self.remoteUidSet.count>1) {
            _callWaitingView.hidden = YES;
        }
    }
   
    [_collectionView reloadData];
}
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    NSLog(@"=========onUserVideoAvailable:%@",userId);
//    NSInteger index = [self.remoteUidSet indexOfObject:userId];
    if (available) {
        if (![self.remoteUidSet containsObject:userId]) {
            [self.remoteUidSet addObject:userId];
        }

    } else {
        [_trtcCloud stopRemoteView:userId streamType:TRTCVideoStreamTypeSmall];
        [self.remoteUidSet removeObject:userId];
    }
//    for(int i=0;i<_remoteUidSet.count;i++){
//        NSString *idString = _remoteUidSet[i];
//        [_trtcCloud stopRemoteView:idString streamType:TRTCVideoStreamTypeSmall];
//    }
//    [self.view layoutIfNeeded];
//    NSLog(@"remoteUidSet:%@",_remoteUidSet);
    [_collectionView reloadData];
//    [self refreshRemoteVideoViews];
}

- (void)onError:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg
        extInfo:(nullable NSDictionary*)extInfo {
//    self.curLastModel.code = errCode;
    if ([self.delegate respondsToSelector:@selector(hungUpDelegateActionWithType:)]) {
        [_trtcCloud stopLocalPreview];
        [_trtcCloud exitRoom];
        [TRTCCloud destroySharedIntance];
        [self.delegate hungUpDelegateActionWithType:@"2"];
    }
//    [self hangup];
}
- (void)refreshRemoteVideoViews {
//    NSInteger index = 0;
//    for (NSString* userId in _remoteUidSet) {
//        if (index >= maxRemoteUserNum) { return; }
//        [_remoteViewArr[index] setHidden:false];
//        [_trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeSmall
//                               view:_remoteViewArr[index++]];
//    }
//    float collectionCellH = 0;
//    if (_remoteUidSet.count>0) {
//        _collectionView.hidden = NO;
        
//        collectionCellH = ([AppDelegate sharedAppDelegate].window.bounds.size.height - 30 - 80)/2;
//        if (_remoteUidSet.count == 1) {
//
//            [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
//                make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width/2);
//        //        make.left.equalTo(self.view);
//                make.right.equalTo(self.view);
//        //        make.bottom.equalTo(self.hungUpButton.mas_top).mas_offset(-10);
//                make.height.mas_equalTo(collectionCellH);
//            }];
//        }
//        else{
//            [_remoteUidSet addObject:_userId];
//            [self.trtcCloud stopLocalPreview];
//            [self.trtcCloud startLocalPreview:_isFrontCamera view:self.view];
//            NSInteger cellCount = _remoteUidSet.count/2+1;
//            [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.minimizeButton.mas_bottom).mas_offset(10);
//                make.width.mas_equalTo([AppDelegate sharedAppDelegate].window.bounds.size.width);
//        //        make.left.equalTo(self.view);
//                make.right.equalTo(self.view);
//        //        make.bottom.equalTo(self.hungUpButton.mas_top).mas_offset(-10);
//                make.height.mas_equalTo(collectionCellH*cellCount);
//            }];
//        }
        
//        [_collectionView reloadData];
//    }
    
}
- (void)timerFired:(NSTimer *)timer
{
    if (_timeCount !=0)
    {

        if ((300-_timeCount)<60 && (300-_timeCount)>0) {
            _waiteTimeLabel.text = [NSString stringWithFormat:@"已等待%d秒钟",(int)((300-_timeCount))];
        }
        else if ((300-_timeCount)%60 == 0) {
            _waiteTimeLabel.text = [NSString stringWithFormat:@"已等待%d分钟",(int)((300-_timeCount)/60)];
        }
        else {
            int minte =  (int)((300-_timeCount)/60);
            int second = (int)((300-_timeCount)%60);
            _waiteTimeLabel.text = [NSString stringWithFormat:@"已等待%d分%d秒",minte,second];
        }
        
        _timeCount--;
    }
    else
    {
//        [SVProgressHUD showInfoWithStatus:@"医生忙碌中，请稍后再发起视频！"];
//        [SVProgressHUD dismissWithDelay:2.f];
        [LeafNotification showHint:@"医生忙碌中，请稍后再发起视频！" yOffset:100];
        [self performSelector:@selector(timeEnd) withObject:nil afterDelay:1.5f];
       
       
    }
}

- (void)callTimeTimerFired:(NSTimer *)timer
{
    _callTimeCount++;
    if (_callTimeCount<60 && _callTimeCount>0) {
        _callingTimeLabel.text = [NSString stringWithFormat:@"00:%02d",(int)(_callTimeCount)];
    }
    else{
        _callingTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)(_callTimeCount/60),(int)(_callTimeCount%60)];
    }
   
}

- (void)timeEnd{
    [self hungUpAction];
    [_timer invalidate];
    _timer = nil;
    
}
#pragma mark - lazy load
- (NSTimer *)timer
{
    if (!_timer)
    {
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        _timeCount = 299;
    }
    return _timer;
}
- (NSTimer *)callTimeTimer
{
    if (!_callTimeTimer) {
        _callTimeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(callTimeTimerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_callTimeTimer forMode:NSRunLoopCommonModes];
        _callTimeCount = 1;
    }
    
    return _callTimeTimer;
}

- (void)stopAndQuit
{
    [self.trtcCloud stopLocalPreview];
    [self.trtcCloud exitRoom];
    [TRTCCloud destroySharedIntance];
//    [self removeSimpleMsgListener];
}

//#pragma mark - V2TIMSimpleMsgListener
///// 收到 C2C 文本消息
//- (void)onRecvC2CTextMessage:(NSString *)msgID sender:(V2TIMUserInfo *)info text:(NSString *)text{
//
//    [LeafNotification showInController:[UIApplication sharedApplication].delegate.window.rootViewController withText:@"收到 C2C 文本消息"];
//
//}
//
///// 收到 C2C 自定义（信令）消息
//- (void)onRecvC2CCustomMessage:(NSString *)msgID sender:(V2TIMUserInfo *)info customData:(NSData *)data{
//
//
//}

#pragma mark - TRTCCallingDelegate

- (void)onRecvC2CTextMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId text:(NSString *)text
{
    [LeafNotification showHint:@"医生忙碌中，请重新发起视频" yOffset:100];
    if ([text isEqualToString:@"医生忙碌中，请重新发起视频"]) {
        [self hungUpAction];
    }
}
- (void)onRecvC2CCustomMessage:(NSString *)msgID sendUserId:(NSString *)sendUserId customData:(NSData *)data
{
    
}

- (void)setCountString:(NSString *)countString
{
    _countString = countString;
    self.waiteCountLabel.text = [NSString stringWithFormat:@"前面排队还有%@人",_countString];
    self.waiteCountLabel.hidden = NO;
    [self.waiteTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waitTitleLabel.mas_bottom).mas_offset(15);
        make.right.equalTo(self.centerTempView.mas_left).mas_offset(-20);
        
    }];
    [_waiteCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.waitTitleLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.centerTempView.mas_right).mas_offset(-15);
//        make.right.equalTo(self.callWaitingView).mas_offset(-15);
    }];
    
    
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
