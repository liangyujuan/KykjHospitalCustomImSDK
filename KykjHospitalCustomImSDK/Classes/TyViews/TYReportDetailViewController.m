//
//  TYReportDetailViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/13.
//  Copyright © 2022 cc. All rights reserved.
//

#import "TYReportDetailViewController.h"
#import "DiagnosisPreviewCell.h"
#import "EMRPreviewHeaderView.h"
#import "DiagnosisPreviewFooter.h"
#import "Factory.h"
#import "MJExtension.h"

@interface TYReportDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) EMRPreviewHeaderView *header;

@property (nonatomic, strong) DiagnosisPreviewFooter *footer;

//@property (nonatomic, strong) EMRRecordModel *emrModel;

@property (nonatomic, strong) NSMutableArray *diagnosisSelectArray;

@property (nonatomic, assign) EMREditViewType type;

@property (nonatomic, strong) NSMutableDictionary * proposalDict;

@property (nonatomic, strong) NSMutableDictionary * pregnancyDic;
@property (nonatomic, strong) NSMutableDictionary * monthliesDic;

@end

@implementation TYReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"报告详情";
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
  
    [self setupNav];
    
    [self setsubviews];
    
    [self bindViewModel];

    // Do any additional setup after loading the view.
}
- (void)setupNav{
    
    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
//    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
    titleLabel.text = @"报告详情";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    
    
}
- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setsubviews
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
    _header = [[EMRPreviewHeaderView alloc] init];

    _footer = [[DiagnosisPreviewFooter alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 142) isRecipe:NO];
    
    _footer.adviceStr = [self.sourceArray lastObject];
    _footer.orderRecordModel = self.orderRecordModel;
        

    _tableView = [UITableView MakeTableView:^(TableViewMaker * _Nonnull make) {
        make.style(UITableViewStyleGrouped).backgroundColor(colorBackground).estimatedRowHeight(70).delegate(self).dataSource(self).separatorStyle(UITableViewCellSeparatorStyleNone).registerCell([DiagnosisPreviewCell class],@"DiagnosisPreviewCell").addToSuperView(self.view);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view).priorityHigh();
        make.bottom.equalTo(self.view).mas_offset(-20);
    }];
}
- (void)mainViewType
{
    EMREditViewType type = EMREditViewAdultManType;
    if ([self.orderRecordModel.USER_SEX isEqualToString:@"1"]) {
        if ([self.orderRecordModel.USER_AGE integerValue]>14){
            type = EMREditViewAdultManType;
        }else{
            type = EMREditViewChildrenManType;
        }
    }else{
//        if (self.isObAndGy) {
            if ([self.orderRecordModel.USER_AGE integerValue]>14) {
                type = EMREditViewAdultWomanMonthliesType;
            }else{
                type = EMREditViewChildrenWomanMonthliesType;

            }
//        }else{
//            if ([self.orderRecordModel.USER_AGE integerValue]>14) {
//                type = EMREditViewAdultWomanNormalType;
//            }else{
//                type = EMREditViewChildrenWomanNormalType;
//            }
//        }
    }
    self.type = type;
//    _mainView.type = EMREditViewChildrenManType;
//    _mainView.type = EMREditViewAdultWomanNormalType;
//    _mainView.type = EMREditViewChildrenWomanMonthliesType;
//    _mainView.type = EMREditViewChildrenWomanNormalType;
//    _mainView.type = EMREditViewAdultWomanMonthliesType;
    
}
- (void)bindViewModel
{
//    _viewModel = [[DiagnosisViewModel alloc] init];
//    @weakify(self)
//    [_viewModel.getEMRCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if ([x isKindOfClass:[EMRRecordModel class]]) {
//            
//            self.emrModel = x;
//            if (![KykjImToolkit isStringBlank:self.emrModel.DIAGNOSE]) {
//                NSArray *icdArray = [KykjImToolkit arrayWithJson:self.emrModel.DIAGNOSE];
//                self.diagnosisSelectArray = [NSMutableArray arrayWithArray:icdArray];
//            }
//            [self preview];
//        }
//    }];
//
//      
//    
//    [_viewModel.patientIdCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if ([x isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *dic = x;
////            self.patientId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PATIENT_ID"]];
//            if ([dic objectForKey:@"NATION"]) {
//                self.orderRecordModel.NATION = [dic objectForKey:@"NATION"];
//            }
////            if ([self.orderRecordModel.USER_AGE intValue]<=14) {
//                NSDictionary *extDic = [getSafeString(dic[@"EXT"]) mj_JSONObject];
//                self.orderRecordModel.WEIGHT = getSafeString(extDic[@"weight"]);
////            }
//            if ([dic objectForKey:@"MOBILE"]) {
//                self.orderRecordModel.CALL_PHONE = [dic objectForKey:@"MOBILE"];
//            }
//            self.header.orderRecordModel = self.orderRecordModel;
//            
//                //                NSString *dz_type = self.orderRecordModel.DZ_TYPE.length>0 ? self.orderRecordModel.DZ_TYPE : @"DZ_FZ";
//            
//        }
//        
//    }];
    
    [self mainViewType];
    
    [self requestPatientId];
    
    [self preview];
    
}

- (void)preview
{
    self.pregnancyDic = [NSMutableDictionary dictionary];
    self.monthliesDic = [NSMutableDictionary dictionary];
    NSString *describeText = self.emrModel.COMPLAINT.length>0 ? self.emrModel.COMPLAINT : @"";//主诉
    
    NSString *presentSickText = self.emrModel.NOW_MEDICAL_HISTORY.length>0 ? self.emrModel.NOW_MEDICAL_HISTORY : @"";//现病史
    
    NSString *personalText = self.emrModel.PERSONAL_HISTORY.length>0 ? self.emrModel.PERSONAL_HISTORY : @"";//个人史
    
    NSString *allergyHistoryText = self.emrModel.ALLERGIC_HISTORY.length>0 ? self.emrModel.ALLERGIC_HISTORY : @"";//过敏史
    
    NSString *pastSickText = self.emrModel.PAST_MEDICAL_HISTORY.length>0 ? self.emrModel.PAST_MEDICAL_HISTORY : @"";//既往史
    
    NSString *physicalCheckText = self.emrModel.PHYSICAL_EXAMINATION.length>0 ? self.emrModel.PHYSICAL_EXAMINATION : @"";//体格检查
    
    NSString *auxiliaryCheckText = self.emrModel.AUXILIARY_EXAMINATION.length>0 ? self.emrModel.AUXILIARY_EXAMINATION : @"";//辅助检查
    
    NSString *diagnosisHistoryText = @"";//诊断
    for (int i=0;i<self.diagnosisSelectArray.count;i++) {
        NSDictionary *dic = self.diagnosisSelectArray[i];
        if (i<self.diagnosisSelectArray.count-1) {
            diagnosisHistoryText = [diagnosisHistoryText stringByAppendingFormat:@"%@,",[dic objectForKey:@"illName"]];
        }else{
            diagnosisHistoryText = [diagnosisHistoryText stringByAppendingFormat:@"%@",[dic objectForKey:@"illName"]];
        }
        
    }
  
    if (![KykjImToolkit isStringBlank:self.emrModel.PROPOSAL]) {
        self.proposalDict = [NSMutableDictionary dictionaryWithDictionary:[KykjImToolkit dictionaryWithJson:self.emrModel.PROPOSAL]];
        
    }
    if (![KykjImToolkit isStringBlank:self.emrModel.MARRIAGE_CHILDBIRTH_HISTORY]){
        NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[KykjImToolkit dictionaryWithJson:self.emrModel.MARRIAGE_CHILDBIRTH_HISTORY]];

        if ([self.orderRecordModel.USER_SEX isEqualToString:@"1"]) {
            [self.pregnancyDic setObject:[dic objectForKey:@"giveBirthCount"]!=nil ? [dic objectForKey:@"giveBirthCount"] : @"" forKey:@"giveBirthCount"];
            [self.pregnancyDic setObject:[dic objectForKey:@"other"]!=nil ? [dic objectForKey:@"other"] : @"" forKey:@"other"];
        }else{
            [self.pregnancyDic setObject:[dic objectForKey:@"yieldCount"]!=nil ? [dic objectForKey:@"yieldCount"] : @"" forKey:@"yieldCount"];
            [self.pregnancyDic setObject:[dic objectForKey:@"pregnancyCount"]!=nil ? [dic objectForKey:@"pregnancyCount"] : @"" forKey:@"pregnancyCount"];
            [self.pregnancyDic setObject:[dic objectForKey:@"other"]!=nil ? [dic objectForKey:@"other"] : @"" forKey:@"other"];
        }
    }
    if (![KykjImToolkit isStringBlank:self.emrModel.MENSTRUAL_HISTORY]){
        NSDictionary *dic = [KykjImToolkit dictionaryWithJson:self.emrModel.MENSTRUAL_HISTORY];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesDate"]!=nil ? [dic objectForKey:@"monthliesDate"] : @"" forKey:@"monthliesDate"];
        [self.monthliesDic setObject:[dic objectForKey:@"menopauseDate"]!=nil ? [dic objectForKey:@"menopauseDate"] : @"" forKey:@"menopauseDate"];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesCycle"]!=nil ? [dic objectForKey:@"monthliesCycle"] : @"" forKey:@"monthliesCycle"];
        
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesDay"]!=nil ? [dic objectForKey:@"monthliesDay"] : @"" forKey:@"monthliesDay"];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesAmount"]!=nil ? [dic objectForKey:@"monthliesAmount"] : @"" forKey:@"monthliesAmount"];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesColor"]!=nil ? [dic objectForKey:@"monthliesColor"] : @"" forKey:@"monthliesColor"];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesClot"]!=nil ? [dic objectForKey:@"monthliesClot"] : @"" forKey:@"monthliesClot"];
        [self.monthliesDic setObject:[dic objectForKey:@"monthliesMenalgia"]!=nil ? [dic objectForKey:@"monthliesMenalgia"] : @"" forKey:@"monthliesMenalgia"];
            //                        [self.monthliesDic setObject:[dic objectForKey:@"monthliesAmount"]!=nil ? [dic objectForKey:@"monthliesAmount"] : @"少" forKey:@"monthliesAmount"];
            //                        [self.monthliesDic setObject:[dic objectForKey:@"monthliesColor"]!=nil ? [dic objectForKey:@"monthliesColor"] : @"鲜红" forKey:@"monthliesColor"];
            //                        [self.monthliesDic setObject:[dic objectForKey:@"monthliesClot"]!=nil ? [dic objectForKey:@"monthliesClot"] : @"无" forKey:@"monthliesClot"];
            //                        [self.monthliesDic setObject:[dic objectForKey:@"monthliesMenalgia"]!=nil ? [dic objectForKey:@"monthliesMenalgia"] : @"从不" forKey:@"monthliesMenalgia"];
        [self.monthliesDic setObject:[dic objectForKey:@"other"]!=nil ? [dic objectForKey:@"other"] : @"" forKey:@"other"];
        
        NSString *isMenopause = [NSString stringWithFormat:@"%@",[dic objectForKey:@"isMenopause"]];
        [self.monthliesDic setObject:isMenopause.length>0 ? isMenopause : @"" forKey:@"isMenopause"];
//        [self.monthliesDic setObject:[dic objectForKey:@"isMenopause"]!=nil ? [dic objectForKey:@"isMenopause"] : @"" forKey:@"isMenopause"];

    }

    NSString *doctorAdviceText = @"";
    if (self.proposalDict){
        NSMutableString * proposalStr = [[NSMutableString alloc] init];
        if (getSafeString(self.proposalDict[@"proposal_content"]).length > 0) {
            [proposalStr appendString:getSafeString(self.proposalDict[@"proposal_content"])];
            [proposalStr appendString:@"，"];
        }
        if (getSafeString(self.proposalDict[@"next_fz_date"]).length > 0 && ![getSafeString(self.proposalDict[@"next_fz_date"]) isEqualToString:@"无"]) {
            [proposalStr appendString:getSafeString(self.proposalDict[@"next_fz_date"])];
            [proposalStr appendString:@"复诊"];
        }
        doctorAdviceText = proposalStr;
    }
    
    
//        //小孩
//    NSString *personalText = @"";
//    if (self.mainView.type == EMREditViewChildrenManType || self.mainView.type == EMREditViewChildrenWomanNormalType || self.mainView.type == EMREditViewChildrenWomanMonthliesType) {
//        personalText = getSafeString(self.mainView.tempEmrModel.PERSONAL_HISTORY);
//    }
    NSString *pregnancyText = @"";
        //婚育史男性
    if (self.type == EMREditViewAdultManType) {
        pregnancyText = getSafeString(self.pregnancyDic[@"giveBirthCount"]);
        NSMutableArray *tempArray = [NSMutableArray array];
        if (pregnancyText.length > 0) {
            pregnancyText = [NSString stringWithFormat:@"育%d次",pregnancyText.intValue];
            [tempArray addObject:pregnancyText];
        }
            //            pregnancyText = [NSString stringWithFormat:@"育%@次",[self.mainView.pregnancyDic objectForKey:@"giveBirthCount"]!=nil ? [self.mainView.pregnancyDic objectForKey:@"giveBirthCount"] : @""];
        if (getSafeString([self.pregnancyDic objectForKey:@"other"]).length > 0) {
            [tempArray addObject:[self.pregnancyDic objectForKey:@"other"]];
        }
        pregnancyText = [tempArray componentsJoinedByString:@","];
    }
        //婚育史女性
    if (self.type == EMREditViewAdultWomanNormalType || self.type == EMREditViewAdultWomanMonthliesType) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        if (getSafeString(self.pregnancyDic[@"pregnancyCount"]).length > 0)
            [tempArray addObject:[NSString stringWithFormat:@"孕%i次",getSafeString(self.pregnancyDic[@"pregnancyCount"]).intValue]];
        if (getSafeString(self.pregnancyDic[@"yieldCount"]).length > 0)
            [tempArray addObject:[NSString stringWithFormat:@"产%i次",getSafeString(self.pregnancyDic[@"yieldCount"]).intValue]];
        if (getSafeString(self.pregnancyDic[@"other"]).length > 0)
            [tempArray addObject:[NSString stringWithFormat:@"%@",getSafeString(self.pregnancyDic[@"other"])]];
        pregnancyText = [tempArray componentsJoinedByString:@","];
        
            //            pregnancyText = [NSString stringWithFormat:@"孕%@次，产%@次",[self.mainView.pregnancyDic objectForKey:@"pregnancyCount"]!=nil ? [self.mainView.pregnancyDic objectForKey:@"pregnancyCount"] : @"",[self.mainView.pregnancyDic objectForKey:@"yieldCount"]!=nil ? [self.mainView.pregnancyDic objectForKey:@"yieldCount"] : @""];
            //            if ([self.mainView.pregnancyDic objectForKey:@"other"]!=nil) {
            //                pregnancyText = [pregnancyText stringByAppendingFormat:@",%@",[self.mainView.pregnancyDic objectForKey:@"other"]];
            //            }
    }
    NSString *monthliesText = @"";
    NSMutableArray *monthliesArr = [NSMutableArray array];
    if (self.type == EMREditViewAdultWomanNormalType || self.type == EMREditViewChildrenWomanNormalType) {
        monthliesText = [self.monthliesDic objectForKey:@"other"]!=nil ? [self.monthliesDic objectForKey:@"other"] : @"" ;
    }
    if (self.type == EMREditViewAdultWomanMonthliesType || self.type == EMREditViewChildrenWomanMonthliesType) {
        NSString * isMenopause = [NSString stringWithFormat:@"%@",[self.monthliesDic objectForKey:@"isMenopause"]];//是否绝经 1：是 2：否
        
        NSString * menopauseDate = [self.monthliesDic objectForKey:@"menopauseDate"];//绝经时间
        NSString * monthliesDate = [self.monthliesDic objectForKey:@"monthliesDate"];//末次月经时间
        NSString * monthliesCycle = [self.monthliesDic objectForKey:@"monthliesCycle"];//月经周期
        NSString * monthliesDay = [self.monthliesDic objectForKey:@"monthliesDay"];//月经天数
        NSString * monthliesAmount = [self.monthliesDic objectForKey:@"monthliesAmount"]!=nil ? [self.monthliesDic objectForKey:@"monthliesAmount"] : @"";//月经量
        NSString * monthliesColor = [self.monthliesDic objectForKey:@"monthliesColor"]!=nil ? [self.monthliesDic objectForKey:@"monthliesColor"] : @"";//月经颜色
        NSString * monthliesClot = [self.monthliesDic objectForKey:@"monthliesClot"]!=nil ? [self.monthliesDic objectForKey:@"monthliesClot"] : @"";//月经血块
        NSString *  monthliesMenalgia = [self.monthliesDic objectForKey:@"monthliesMenalgia"]!=nil ? [self.monthliesDic objectForKey:@"monthliesMenalgia"] : @"";//痛经
        if ([isMenopause isEqualToString:@"1"]) {
            if (![KykjImToolkit isStringBlank:menopauseDate]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"绝经时间%@",menopauseDate]];
            }else{
                [monthliesArr addObject:@"已绝经"];
            }
            
        }else{
            if (![KykjImToolkit isStringBlank:monthliesDate]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"末次月经%@",monthliesDate]];
            }
            if (![KykjImToolkit isStringBlank:monthliesCycle]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"月经周期%@",monthliesCycle]];
            }
            if (![KykjImToolkit isStringBlank:monthliesDay]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"月经天数%@",monthliesDay]];
            }
            if (![KykjImToolkit isStringBlank:monthliesAmount]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"月经量%@",monthliesAmount]];
            }
            if (![KykjImToolkit isStringBlank:monthliesColor]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"月经颜色%@",monthliesColor]];
            }
            if (![KykjImToolkit isStringBlank:monthliesClot]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"月经血块%@",monthliesClot]];
            }
            if (![KykjImToolkit isStringBlank:monthliesMenalgia]) {
                [monthliesArr addObject:[NSString stringWithFormat:@"%@痛经",monthliesMenalgia]];
            }
            
            if (isMenopause.intValue == 2 && monthliesArr.count == 0) {
                [monthliesArr addObject:@"未绝经"];
            }
        }
        
        
        monthliesText = [monthliesArr componentsJoinedByString:@"，"];
        
        
    }
    
    if (self.type == EMREditViewAdultWomanMonthliesType || self.type == EMREditViewAdultWomanNormalType) {
    
        self.titleArray = @[@"主诉",@"现病史",@"既往史",@"个人史",@"过敏史",@"婚育史",@"月经史",@"体格检查",@"辅助检查",@"诊断",@"处理意见"];
        self.sourceArray = @[describeText,presentSickText,pastSickText,personalText,allergyHistoryText,pregnancyText,monthliesText,physicalCheckText,auxiliaryCheckText,diagnosisHistoryText,doctorAdviceText];
        
    }
    else if (self.type == EMREditViewAdultManType) {
        
        self.titleArray = @[@"主诉",@"现病史",@"既往史",@"个人史",@"过敏史",@"婚育史",@"体格检查",@"辅助检查",@"诊断",@"处理意见"];
        self.sourceArray = @[describeText,presentSickText,pastSickText,personalText,allergyHistoryText,pregnancyText,physicalCheckText,auxiliaryCheckText,diagnosisHistoryText,doctorAdviceText];
        
    }
    else if (self.type == EMREditViewChildrenWomanMonthliesType || self.type == EMREditViewChildrenWomanNormalType){
        
        self.titleArray = @[@"主诉",@"现病史",@"既往史",@"个人史",@"过敏史",@"月经史",@"体格检查",@"辅助检查",@"诊断",@"处理意见"];
        self.sourceArray = @[describeText,presentSickText,pastSickText,personalText,allergyHistoryText,monthliesText,physicalCheckText,auxiliaryCheckText,diagnosisHistoryText,doctorAdviceText];
        
    }
    else if (self.type == EMREditViewChildrenManType){
        
        self.titleArray = @[@"主诉",@"现病史",@"既往史",@"个人史",@"过敏史",@"体格检查",@"辅助检查",@"诊断",@"处理意见"];
        self.sourceArray = @[describeText,presentSickText,pastSickText,personalText,allergyHistoryText,physicalCheckText,auxiliaryCheckText,diagnosisHistoryText,doctorAdviceText];
        
    }
    
   
    [self.tableView reloadData];
    
}
#pragma mark- tableView delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
    
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiagnosisPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiagnosisPreviewCell"];
    [cell setCellTitle:self.titleArray[indexPath.row] content:self.sourceArray[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _header.orderRecordModel = self.orderRecordModel;
    
    return _header;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = colorBackground;
    UIView *view1 = [[UIView alloc] init];
    view1.layer.cornerRadius = 10.f;
    view1.backgroundColor = [UIColor whiteColor];
    [view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view);
        make.left.equalTo(view).mas_offset(15);
        make.right.equalTo(view).mas_offset(-15);
        make.bottom.equalTo(view);
        make.height.mas_equalTo(30);
    }];
    return view;
}

#pragma mark - net
- (void)requestPatientId
{
    MBProgressHUDShowInThisView;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"getUserPatient" forKey:@"method"];
    [param setObject:@"userService" forKey:@"service"];
    if (self.emrModel.PATIENT_ID.length>0) {
        [param setObject:self.emrModel.PATIENT_ID.length>0 ? self.emrModel.PATIENT_ID : @"" forKey:@"patientId"];
    }else{
        if (self.emrModel.PATIENT_IDCARD.length>0 &&self.emrModel.USER_ID.length>0 ) {
            [param setObject:self.emrModel.PATIENT_IDCARD.length>0 ? self.emrModel.PATIENT_IDCARD : @"" forKey:@"idCard"];
            [param setObject:self.emrModel.USER_ID.length>0 ? self.emrModel.USER_ID : @"" forKey:@"userId"];
        }
    }
    
    @weakify(self)
    
    [HttpOperationManager HTTP_POSTWithParameters:param showAlert:YES success:^(id responseObject) {
      @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            
            if ([responseObject objectForKey:@"list"]!=nil) {
                NSArray *arr = [responseObject objectForKey:@"list"];
                NSDictionary *dic = [arr firstObject];
                if (dic!=nil) {
                    if ([dic objectForKey:@"NATION"]) {
                        self.orderRecordModel.NATION = [dic objectForKey:@"NATION"];
                    }
        //            if ([self.orderRecordModel.USER_AGE intValue]<=14) {
                        NSDictionary *extDic = [getSafeString(dic[@"EXT"]) mj_JSONObject];
                        self.orderRecordModel.WEIGHT = getSafeString(extDic[@"weight"]);
        //            }
                    if ([dic objectForKey:@"MOBILE"]) {
                        self.orderRecordModel.CALL_PHONE = [dic objectForKey:@"MOBILE"];
                    }
                    self.header.orderRecordModel = self.orderRecordModel;
                }
            }
           
        }else{
            NSString *msgString = getSafeString(responseObject[@"info"]);

            if (msgString.length > 0) {
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:msgString];
                
            }else{
                            [LeafNotification showInController:[KykjImToolkit getCurrentVC] withText:@"系统错误，请稍后再试！"];
               
            }
      
        }
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.userInfo);
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
    
- (void)requetEmr
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
