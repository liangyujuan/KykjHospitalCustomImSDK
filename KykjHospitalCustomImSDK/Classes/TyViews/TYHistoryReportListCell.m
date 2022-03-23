//
//  TYHistoryReportListCell.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/13.
//  Copyright © 2022 cc. All rights reserved.
//

#import "TYHistoryReportListCell.h"
#import "Factory.h"

@interface TYHistoryReportListCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *depLabel;

@property (nonatomic, strong) UILabel *diagnosisLabel;

@property (nonatomic, strong) UILabel *patientNameLabel;

@end

@implementation TYHistoryReportListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = colorBackground;
//        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setSubviews];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
   
}
- (void)setSubviews
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(15);
        make.right.equalTo(self.contentView).mas_offset(-15);
        make.bottom.equalTo(self.contentView).mas_offset(-10);
    }];
    
    _timeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(102, 102, 102)).font([UIFont systemFontOfSize:13]).addToSuperView(self.contentView);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).mas_offset(15);
        make.right.equalTo(self.bgView).mas_offset(-15);
    }];
    
    _patientNameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self.contentView);
    }];
    _patientNameLabel.hidden = YES;
    [_patientNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel);
        make.left.equalTo(self.bgView).mas_offset(15);
        make.right.equalTo(self.timeLabel.mas_left).mas_offset(-15);
//        make.width.mas_equalTo(ScreenWidth-160);
    }];
    
    _depLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self.contentView);
    }];
    [_depLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.patientNameLabel.mas_bottom).mas_offset(14);
        make.left.equalTo(self.bgView).mas_offset(15);
//        make.right.equalTo(self.bgView).mas_offset(-15);
        make.width.mas_equalTo(ScreenWidth-60);
    }];
    
    
    
    _diagnosisLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(102 , 102, 102)).font([UIFont systemFontOfSize:14]).addToSuperView(self.contentView);
    }];
    [_diagnosisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depLabel.mas_bottom).mas_offset(14);
        make.left.equalTo(self.bgView).mas_offset(15);
        make.width.mas_equalTo(ScreenWidth-60);
//        make.right.equalTo(self.bgView).mas_offset(-15).priorityHigh();
        make.bottom.equalTo(self.bgView).mas_offset(-15);
    }];
    
}

//网络病历
- (void)setEmrNetModel:(EMRRecordModel *)emrNetModel
{
    _emrNetModel = emrNetModel;
    _timeLabel.text = _emrNetModel.INQUIRY_TIME;
    
    NSArray *diagnosisArr = [KykjImToolkit arrayWithJson:_emrNetModel.DIAGNOSE];
    NSString *diagnosisHistoryText = @"";
    for (int i=0;i<diagnosisArr.count;i++) {
        NSDictionary *dic = diagnosisArr[i];
        if (i<diagnosisArr.count-1) {
            diagnosisHistoryText = [diagnosisHistoryText stringByAppendingFormat:@"%@,",[dic objectForKey:@"illName"]];
        }else{
            diagnosisHistoryText = [diagnosisHistoryText stringByAppendingFormat:@"%@",[dic objectForKey:@"illName"]];
        }
        
    }
    _patientNameLabel.hidden = NO;
    _diagnosisLabel.text = [NSString stringWithFormat:@"诊断：%@",diagnosisHistoryText];
    _patientNameLabel.text = _emrNetModel.PATIENT_NAME;
    _depLabel.text = [NSString stringWithFormat:@"科室： %@",_emrNetModel.DEP_NAME];

    _diagnosisLabel.textColor = RGB(102, 102, 102);
    _diagnosisLabel.font = [UIFont systemFontOfSize:14];
    [self layoutIfNeeded];
}
@end
