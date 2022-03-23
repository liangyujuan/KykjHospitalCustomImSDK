//
//  DiagnosisPreviewHeader.m
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import "DiagnosisPreviewHeader.h"


@interface DiagnosisPreviewHeader ()

@property (nonatomic, strong) UIView *topBgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *sexLabel;

@property (nonatomic, strong) UILabel *ageLabel;

@property (nonatomic, strong) UILabel *telLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *handleTitleLabel;

@property (nonatomic, strong) UILabel *weightLabel;

@property (nonatomic, strong) UILabel *nationLabel;

@property (nonatomic, strong) UILabel *marriageLabel;

//@property (nonatomic, strong) UIView *whiteView;

@property (nonatomic, strong) UILabel *weightTitleLabel;

@property (nonatomic, strong) UILabel *telTitleLabel;

@property (nonatomic, strong) UILabel *addTitleLabel;

@property (nonatomic, strong) UILabel *marriageTitleLabel;

@property (nonatomic, strong) UILabel *nationTitleLabel;

@property (nonatomic, strong) UILabel *timeTitleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *doctorTitleLabel;

@property (nonatomic, strong) UILabel *doctorLabel;

@property (nonatomic, strong) UILabel *depTitleLabel;

@property (nonatomic, strong) UILabel *depLabel;

@end

@implementation DiagnosisPreviewHeader

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
    
}
- (void)setSubViews{
    _topBgView = [[UIView alloc] init];
    _topBgView.backgroundColor = RGB(1, 111, 255);
    [self addSubview:_topBgView];
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(15);
        make.left.equalTo(self).mas_offset(15);
        make.right.equalTo(self).mas_offset(-15);
//        make.height.mas_equalTo(101);
        make.bottom.equalTo(self);
    }];
    _topBgView.layer.cornerRadius = 10.f;
    _topBgView.clipsToBounds = YES;
//    _whiteView = [[UIView alloc] init];
//    _whiteView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:_whiteView];
//    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBgView.mas_bottom);
//        make.left.equalTo(self).mas_offset(15).priorityHigh();
//        make.right.equalTo(self).mas_offset(-15).priorityHigh();
//        make.height.mas_equalTo(20);
//    }];
    
    UILabel *nameTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"姓名：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [nameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.left.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _nameLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"测试名字").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.left.equalTo(nameTitleLabel.mas_right);
    }];
    
    UILabel *sexTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"性别：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [sexTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topBgView);
        make.top.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _sexLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"男").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.left.equalTo(sexTitleLabel.mas_right);
    }];
    
    _ageLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    
    UILabel *ageTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"年龄：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [ageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(15);
        make.right.equalTo(self.ageLabel.mas_left);
    }];
    
    _weightTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"体重：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    
    [_weightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topBgView).mas_offset(40);
        make.left.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _weightLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"未知").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(40);
        make.left.equalTo(self.weightTitleLabel.mas_right);
//        make.width.mas_lessThanOrEqualTo(46);
    }];
    
    
    _nationTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"民族：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_nationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topBgView);
        make.top.equalTo(self.topBgView).mas_offset(40);
    }];
    
    _nationLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"汉族").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_nationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(40);
        make.left.equalTo(self.nationTitleLabel.mas_right);
//        make.width.mas_lessThanOrEqualTo(46);
    }];
    
    _marriageLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"未知").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_marriageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(40);
        make.right.equalTo(self.topBgView).mas_offset(-15);
//        make.width.mas_lessThanOrEqualTo(46);
    }];
    
    _marriageTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"婚姻：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    
    [_marriageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.marriageLabel.mas_left);
        make.top.equalTo(self.topBgView).mas_offset(40);
    }];
    _telTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"电话：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_telTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBgView).mas_offset(40+30);
        make.left.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _telLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).textAlignment(NSTextAlignmentLeft).addToSuperView(self);
    }];
//    _telLabel.adjustsFontSizeToFitWidth = YES;
//    [_telLabel sizeThatFits:CGSizeMake(ScreenWidth-277, 18)];
//    _telLabel.numberOfLines = 0;
    [_telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.telTitleLabel);
        make.left.equalTo(self.telTitleLabel.mas_right);
        make.height.mas_greaterThanOrEqualTo(15);
//        make.right.equalTo(self.topBgView).mas_offset(-15);
//        make.width.mas_lessThanOrEqualTo(ScreenWidth-265);
    }];
    
    _depTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"科室：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_depTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topBgView).mas_offset(15);
        make.top.equalTo(self.telLabel.mas_bottom).mas_offset(10);
    }];
    
    _depLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_depLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.telLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.depTitleLabel.mas_right);
        make.height.mas_greaterThanOrEqualTo(15);
    }];
    
    _doctorTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"医生：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depTitleLabel);
        make.left.equalTo(self.depLabel.mas_right).mas_offset(15);
    }];
    
    _doctorLabel= [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_doctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.doctorTitleLabel);
        make.left.equalTo(self.doctorTitleLabel.mas_right);
        make.height.mas_greaterThanOrEqualTo(15);
//        make.right.equalTo(self.topBgView).mas_offset(-15);
    }];
    
    _addTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"地址：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_addTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.depTitleLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _addressLabel= [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    _addressLabel.numberOfLines = 0;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addTitleLabel);
        make.left.equalTo(self.topBgView).mas_offset(15+43);
        make.right.equalTo(self.topBgView).mas_offset(-15);
        make.height.mas_greaterThanOrEqualTo(15);
//        make.height.mas_greaterThanOrEqualTo(15);
//        make.bottom.equalTo(self.topBgView.mas_bottom).mas_offset(-15);
    }];
    
    _timeTitleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"就诊时间：").textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self);
    }];
    [_timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addTitleLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(self.topBgView).mas_offset(15);
    }];
    
    _timeLabel= [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.text(@"").textColor([UIColor whiteColor]).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTitleLabel);
        make.left.equalTo(self.timeTitleLabel.mas_right);
//        make.right.equalTo(self.topBgView).mas_offset(-15);
        make.height.mas_greaterThanOrEqualTo(15);
        make.bottom.equalTo(self.topBgView).mas_offset(-15);
    }];
    
}

- (void)setOrderRecordModel:(YXOrderRecordModel *)orderRecordModel
{
    _orderRecordModel = orderRecordModel;
    _nameLabel.text = _orderRecordModel.USER_NAME.length>0 ? _orderRecordModel.USER_NAME : @"";
    if ([_orderRecordModel.USER_SEX isEqualToString:@"1"]) {
        _sexLabel.text = @"男";
    }else{
        _sexLabel.text = @"女";
    }
    _ageLabel.text = _orderRecordModel.USER_AGE.length>0 ? [NSString stringWithFormat:@"%@岁",_orderRecordModel.USER_AGE] : @"";
    NSLog(@"NATION==%@",_orderRecordModel.NATION);
    
    if ([_orderRecordModel.USER_AGE integerValue]>14) {
       _weightLabel.text = _orderRecordModel.WEIGHT.length>0 ? [_orderRecordModel.WEIGHT stringByAppendingString:@"kg"] : @"未知";
       
        _nationLabel.text = _orderRecordModel.NATION.length>0 ? _orderRecordModel.NATION : @"";
        _marriageTitleLabel.text = @"婚姻：";
        
        _marriageTitleLabel.hidden = NO;
        _marriageLabel.hidden = NO;
       
    }else{
        _weightLabel.text = _orderRecordModel.WEIGHT.length>0 ? [_orderRecordModel.WEIGHT stringByAppendingString:@"kg"] : @"未知";
   
        _nationLabel.text = _orderRecordModel.NATION.length>0 ? _orderRecordModel.NATION : @"";
        _marriageTitleLabel.hidden = YES;
        _marriageLabel.hidden = YES;
    }
    
    _telLabel.text = _orderRecordModel.CALL_PHONE.length>0 ? _orderRecordModel.CALL_PHONE : @"";
//    NSString * string = [NSString stringWithFormat:@"%@%@%@%@",_nationTitleLabel.text,_nationLabel.text,_marriageTitleLabel.text,_marriageLabel.text];
//    
//    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin |
//    //
//            NSStringDrawingTruncatesLastVisibleLine |
//    
//            NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size;
//    CGFloat tW = contentSize.width;
//    NSLog(@"ScreenWidth-60-15*2-tW:%f",ScreenWidth-60-15*2-tW);
//    CGSize size1 = [@"电话：15528223997" boundingRectWithSize:CGSizeMake(MAXFLOAT, 18) options:NSStringDrawingUsesLineFragmentOrigin |
//    //
//            NSStringDrawingTruncatesLastVisibleLine |
//    
//     NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size;
//    
//    NSLog(@"size1:%f",size1.width);
//    if (ScreenWidth-60-15*2-tW<160) {
//        [_telTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topBgView).mas_offset(65);
//            make.left.equalTo(self.topBgView).mas_offset(15);
//        }];
////        [_addTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(self.topBgView).mas_offset(90);
////            make.left.equalTo(self.topBgView).mas_offset(15);
////        }];
////        [_telLabel mas_updateConstraints:^(MASConstraintMaker *make) {
////            make.top.equalTo(self.telTitleLabel);
////            make.left.equalTo(self.telTitleLabel.mas_right);
//////            make.right.equalTo(self.topBgView).mas_offset(-15);
////    //        make.width.mas_lessThanOrEqualTo(ScreenWidth-265);
////        }];
////        [self layoutIfNeeded];
//    }
    
    _timeLabel.text = _orderRecordModel.CREATE_TIME.length>0 ? _orderRecordModel.CREATE_TIME : @"";
    _doctorLabel.text = _orderRecordModel.STAFF_NAME.length>0 ? _orderRecordModel.STAFF_NAME : @"";
    _depLabel.text = _orderRecordModel.DEP_NAME.length>0 ? _orderRecordModel.DEP_NAME : @"";
}

- (void)setEmrModel:(EMRRecordModel *)emrModel
{
    _emrModel = emrModel;
    _timeLabel.text = _emrModel.INQUIRY_TIME.length>0 ? _emrModel.INQUIRY_TIME : @"";
    _doctorLabel.text = _emrModel.STAFF_NAME.length>0 ? _emrModel.STAFF_NAME : @"";
    _depLabel.text = _emrModel.DEP_NAME.length>0 ? _emrModel.DEP_NAME : @"";
}

@end
