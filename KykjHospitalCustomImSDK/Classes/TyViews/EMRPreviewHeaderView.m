//
//  EMRPreviewHeaderView.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/8.
//  Copyright © 2022 cc. All rights reserved.
//

#import "EMRPreviewHeaderView.h"
#import "Factory.h"

@interface EMRPreviewHeaderView ()

@property (nonatomic, strong) UIImageView *topBgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *telImg;

@property (nonatomic, strong) UILabel *telLabel;

@property (nonatomic, strong) UIView *whiteBgView;

@property (nonatomic, strong) UILabel *doctorLabel;

@property (nonatomic, strong) UILabel *depLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *line;

@end

@implementation EMRPreviewHeaderView

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setSubViews];
//    }
//    return self;
//}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_whiteBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _whiteBgView.bounds;
    maskLayer.path = maskPath.CGPath;
    _whiteBgView.layer.mask = maskLayer;
    
}
- (void)setSubViews{
    _topBgView = [[UIImageView alloc] init];
    _topBgView.image = [KykjImToolkit getImageResourceForName:@"emr_preview_headerBgView_img"];
    [self addSubview:_topBgView];
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(15);
        make.left.equalTo(self).mas_offset(15);
        make.right.equalTo(self).mas_offset(-15);
        make.bottom.equalTo(self).mas_offset(5);
//        make.height.mas_equalTo(101);
    }];
    _topBgView.layer.cornerRadius = 10.f;
    _topBgView.clipsToBounds = YES;

    _nameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"测试名字").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:23]).numberOfLines(0).addToSuperView(self);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    
    _detailLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"男").textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    

    _telImg = [[UIImageView alloc] init];
    _telImg.image = [KykjImToolkit getImageResourceForName:@"emr_headerTel_img"];
    [self addSubview:_telImg];
    [_telImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(15);
        make.top.equalTo(self.detailLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
//        make.bottom.equalTo(self.topBgView.mas_bottom).mas_offset(-15);
    }];
    
 
    _telLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).textAlignment(NSTextAlignmentLeft).addToSuperView(self);
    }];
//    _telLabel.adjustsFontSizeToFitWidth = YES;
//    [_telLabel sizeThatFits:CGSizeMake(ScreenWidth-277, 18)];
//    _telLabel.numberOfLines = 0;
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.telImg);
        make.left.equalTo(self.telImg.mas_right).mas_offset(9);
    }];
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor whiteColor];
    [self addSubview:_line];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
        make.top.equalTo(self.telImg.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(.5f);
    }];
    
    _doctorLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"就诊医生：").textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    
    _depLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"科室：").textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_depLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.doctorLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    
    _timeLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"就诊时间：").textColor([UIColor whiteColor]).numberOfLines(0).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
        make.bottom.equalTo(self.topBgView.mas_bottom).mas_offset(-15);
    }];
}

- (void)setOrderRecordModel:(YXOrderRecordModel *)orderRecordModel
{
    _orderRecordModel = orderRecordModel;
    _nameLabel.text = _orderRecordModel.USER_NAME.length>0 ? _orderRecordModel.USER_NAME : @"";
    
    NSString *sex = @"";
    NSString *age = @"";
    NSString *marriage = @"未婚";
    NSString *nation = @"";
    
    if ([_orderRecordModel.USER_SEX isEqualToString:@"1"]) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    age = _orderRecordModel.USER_AGE.length>0 ? [NSString stringWithFormat:@"%@岁",_orderRecordModel.USER_AGE] : @"";
    NSLog(@"NATION==%@",_orderRecordModel.NATION);
    
    nation = _orderRecordModel.NATION.length>0 ? _orderRecordModel.NATION : @"";
    _telLabel.text = [NSString stringWithFormat:@"+%@",_orderRecordModel.CALL_PHONE.length>0 ? _orderRecordModel.CALL_PHONE : @""];
    NSString * string = [NSString stringWithFormat:@"%@/%@/%@%@",sex,age,marriage,[NSString stringWithFormat:@"/%@",nation]];
    _detailLabel.text = string;
    
    _timeLabel.text = [NSString stringWithFormat:@"就诊时间：%@",_orderRecordModel.START_TIME.length>0 ? _orderRecordModel.START_TIME : @""];
    _doctorLabel.text = [NSString stringWithFormat:@"就诊医生：%@",_orderRecordModel.STAFF_NAME.length>0 ? _orderRecordModel.STAFF_NAME : @""];
    _depLabel.text = [NSString stringWithFormat:@"科室：%@",_orderRecordModel.DEP_NAME.length>0 ? _orderRecordModel.DEP_NAME : @""];
    
}

- (void)setEmrModel:(EMRRecordModel *)emrModel
{
    _emrModel = emrModel;
    _timeLabel.text = [NSString stringWithFormat:@"就诊时间：%@",_emrModel.INQUIRY_TIME.length>0 ? _emrModel.INQUIRY_TIME : @""];
    _doctorLabel.text = [NSString stringWithFormat:@"就诊医生：%@",_emrModel.STAFF_NAME.length>0 ? _emrModel.STAFF_NAME : @""];
    _depLabel.text = [NSString stringWithFormat:@"科室：%@",_emrModel.DEP_NAME.length>0 ? _emrModel.DEP_NAME : @""];
}
@end
