//
//  TYHistoryReportListViewController.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/13.
//  Copyright © 2022 cc. All rights reserved.
//

#import "TYHistoryReportListViewController.h"
#import "EMRRecordModel.h"
#import "TYHistoryReportListCell.h"
#import "TYReportDetailViewController.h"
#import "Factory.h"
#import "MJExtension.h"
#import "LYEmptyViewHeader.h"

@interface TYHistoryReportListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerBgView;

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userSexLabel;
@property (nonatomic, strong) UILabel *userAgeLabel;
@property (nonatomic, strong) UILabel *isMyLabel;

@property (weak, nonatomic) UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * arrayPatientRecords;
@end

@implementation TYHistoryReportListViewController

- (void)loadView{
    [super loadView];
    [self setupHeaderView];
    UITableView *table = [[UITableView alloc] init];
    
    [self.view addSubview:table];
    
    self.tableView = table;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = colorBackground;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerBgView.mas_bottom);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//

    self.title = @"历史报告";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = colorBackground;
    
    [self setupNav];
    
    self.arrayPatientRecords = [NSMutableArray array];
//    [self requetGetCaseRecords];
    [self setupTableView];
    
    if(self.model.userId!=nil){
        [self.tableView.mj_header beginRefreshing];
    }
    
    
    
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noMoreData_caseRecord" titleStr:@"暂无记录" detailStr:nil];
}

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

- (void)setupNav{
    
    UIButton * left = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
//    [left setImage:[KykjImToolkit getImageResourceForName:@"arrow_left"] forState:UIControlStateNormal];
    [left addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left];
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-160, 44)];
    titleLabel.text = @"历史报告";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    
    
}
- (void)leftBarButtonItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeaderView
{
    _headerBgView = [[UIView alloc] init];
    _headerBgView.layer.cornerRadius = 10.f;
    _headerBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerBgView];
    
    _headerBgView.layer.cornerRadius = 10.f;
    [_headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).mas_offset(15);
        make.right.equalTo(self.view).mas_offset(-15);
    }];
    
    _userNameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self.headerBgView);
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerBgView).mas_offset(15);
        make.top.equalTo(self.headerBgView).mas_offset(15);
    }];
    
    _userSexLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:15]).addToSuperView(self.headerBgView);
    }];
    [_userSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right).mas_offset(10);
        make.top.equalTo(self.headerBgView).mas_offset(15);
    }];
    
    _userAgeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:15]).addToSuperView(self.headerBgView);
    }];
    [_userAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userSexLabel.mas_right).mas_offset(10);
        make.top.equalTo(self.headerBgView).mas_offset(15);
    }];
    
    _isMyLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"[本人]").textColor(RGB(1, 111, 255)).font([UIFont boldSystemFontOfSize:15]).addToSuperView(self.headerBgView);
    }];
    [_isMyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userAgeLabel.mas_right).mas_offset(10);
        make.top.equalTo(self.headerBgView).mas_offset(15);
        make.bottom.equalTo(self.headerBgView).mas_offset(-15);
    }];
    
    _userNameLabel.text = _model.nameCn.length>0 ? _model.nameCn : @"";
    _userSexLabel.text = [_model.gender isEqualToString:@"1"] ? @"男" : @"女";
    NSString *age = [KykjImToolkit getIdentityCardAge:_model.idCard].length>0 ? [NSString stringWithFormat:@"%@岁",[KykjImToolkit getIdentityCardAge:_model.idCard]] : @"";
    _userAgeLabel.text = age;
    
}

- (void)setupTableView {
    
    WS(ws)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![ws.tableView.mj_footer isRefreshing]) {
            [ws setupNewData];
        }else{
            [ws.tableView.mj_header endRefreshing];
            [ws.tableView.mj_footer endRefreshing];
        }
    }];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![ws.tableView.mj_header isRefreshing]) {
            [ws loadMoreData];
        }else{
            [ws.tableView.mj_header endRefreshing];
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}


- (void)loadMoreData
{
    self.page = (self.arrayPatientRecords.count+10-1)/10;
    [self requetGetCaseRecords];
}

- (void)setupNewData
{
    self.page = 0;
    [self requetGetCaseRecords];
    
}

#pragma mark -- UITableViewDatasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayPatientRecords.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString * identifier = @"TYHistoryReportListCell";

    TYHistoryReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TYHistoryReportListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.emrNetModel = self.arrayPatientRecords[indexPath.row];

        return cell;
}

#pragma mark -- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    TYReportDetailViewController * vc = [[TYReportDetailViewController alloc] init];
    EMRRecordModel *recordModel = self.arrayPatientRecords[indexPath.row];
    
    YXOrderRecordModel *orderModel = [[YXOrderRecordModel alloc] init];
    
    orderModel.STAFF_NAME = recordModel.STAFF_NAME;
    orderModel.DEP_NAME = recordModel.DEP_NAME;
    orderModel.START_TIME = recordModel.INQUIRY_TIME;
    orderModel.USER_SEX = recordModel.PATIENT_SEX;
    orderModel.USER_AGE = recordModel.PATIENT_AGE;
    orderModel.USER_ID = recordModel.USER_ID;
    orderModel.PATIENT_ID = recordModel.PATIENT_ID;
    orderModel.ID_CARD = recordModel.PATIENT_IDCARD;
    vc.orderRecordModel = orderModel;

    vc.emrModel = recordModel;
   
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- net
- (void)requetGetCaseRecords{
  
    NSDictionary * params = @{@"service" : @"clinicService",
                              @"method" : @"getCaseRecords",
//                              @"staffUserId" : system.loginInfo.USER_ID,
                              @"orgId" : @"503350",
                              @"MIN_ROWS" : @(self.page*10),
                              @"MAX_ROWS" : @(self.page*10+10),
                              @"userId" : self.model.userId,
                              @"patientName" : self.model.nameCn,
//                              @"isJc":@"Y",
//                              @"isJy":@"Y"
    };
    
    WS(weakself)
//    MBProgressHUDShowInThisView;
    [HttpOperationManager HTTP_POSTWithParameters:params showAlert:NO success:^(id responseObject) {
        MBProgressHUDHideAllInThisView(weakself);
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
        NSString * result = responseObject[@"result"];
        if([result isEqualToString:@"success"]){
            NSArray *patientGroups = [responseObject objectForKey:@"list"];
            if (self.page == 0) {
                weakself.arrayPatientRecords = [EMRRecordModel mj_objectArrayWithKeyValuesArray:patientGroups];
            }else{
                [weakself.arrayPatientRecords addObjectsFromArray:[EMRRecordModel mj_objectArrayWithKeyValuesArray:patientGroups]];
            }
            [weakself.tableView reloadData];
        }else{
            [weakself.tableView.mj_footer endRefreshing];
            [weakself.tableView.mj_header endRefreshing];
            NSString *msgString = getSafeString(responseObject[@"info"]);
            if (msgString.length > 0) {
                [LeafNotification showHint:msgString yOffset:100];
//                [LeafNotification showInController:weakself withText:msgString];
            }else
                [LeafNotification showHint:@"系统错误，请稍后再试！" yOffset:100];
//                [LeafNotification showInController:weakself withText:@"系统错误，请稍后再试！"];
        }
    } failure:^(NSError *error) {
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.tableView.mj_header endRefreshing];
        MBProgressHUDHideAllInThisView(weakself);
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
