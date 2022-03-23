//
//  DiagnosisPreviewFooter.m
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import "DiagnosisPreviewFooter.h"
#import "Factory.h"

@interface DiagnosisPreviewFooter ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *departLabel;

@property (nonatomic, strong) UILabel *doctorLabel;

@property (nonatomic, strong) UILabel *adviceLabel;

@property (nonatomic, assign) BOOL isRecipe;

@end

@implementation DiagnosisPreviewFooter

- (instancetype)initWithFrame:(CGRect)frame isRecipe:(BOOL)isRecipe
{
    self = [super initWithFrame:frame];
    if (self) {
        _isRecipe = isRecipe;
        [self setSubviewsIsRecipe:isRecipe];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bgView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = _bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    _bgView.layer.mask = maskLayer;
    
}
- (void)setSubviewsIsRecipe:(BOOL)isRecipe
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).mas_offset(15).priorityHigh();
        make.right.equalTo(self).mas_offset(-15).priorityHigh();
        make.height.mas_equalTo(142);
        
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(230,230,230);
    [self.bgView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).mas_offset(20);
        make.left.equalTo(self.bgView).mas_offset(35);
        make.right.equalTo(self.bgView).mas_offset(-35);
        make.height.mas_equalTo(.5f);
    }];
    
    UILabel *timeTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"就诊时间：").textColor(RGB(102, 102, 102)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).mas_offset(20);
        make.left.equalTo(self.bgView).mas_offset(15);
    }];
    
    _timeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"00000").textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeTitleLabel);
        make.left.equalTo(timeTitleLabel.mas_right);
    }];
    UILabel *departTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"科室：").textColor(RGB(102, 102, 102)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [departTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeTitleLabel.mas_bottom).mas_offset(20);
        make.left.equalTo(self.bgView).mas_offset(15);
    }];
    
    _departLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"00000").textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [_departLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(departTitleLabel);
        make.left.equalTo(departTitleLabel.mas_right);
    }];
    UILabel *doctorTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"医生：").textColor(RGB(102, 102, 102)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(departTitleLabel.mas_bottom).mas_offset(20);
        make.left.equalTo(self.bgView).mas_offset(15);
    }];
    
    _doctorLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"00000").textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:14]).addToSuperView(self.bgView);
    }];
    [_doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(doctorTitleLabel);
        make.left.equalTo(doctorTitleLabel.mas_right);
    }];
}
- (void)setOrderRecordModel:(YXOrderRecordModel *)orderRecordModel
{
    if (![KykjImToolkit isStringBlank:orderRecordModel.CREATE_TIME]) {
        self.timeLabel.text = orderRecordModel.CREATE_TIME;
    }else{
        self.timeLabel.text = @"";
    }
    if (![KykjImToolkit isStringBlank:orderRecordModel.DEP_NAME]) {
        self.departLabel.text = orderRecordModel.DEP_NAME;
    }else{
        self.departLabel.text = @"";
    }
    if (![KykjImToolkit isStringBlank:orderRecordModel.STAFF_NAME]) {
        self.doctorLabel.text = orderRecordModel.STAFF_NAME;
    }else{
        self.doctorLabel.text = @"";
    }
}


@end
