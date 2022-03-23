//
//  HOIMConsultMsgExaModel.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/21.
//  Copyright © 2020 cc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPatientRecordsModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YXOrderRecordModel;

@interface HOIMMsgExtraModel : NSObject

@property (copy, nonatomic) NSString * regWayCode;
@property (copy, nonatomic) NSString * age;
@property (copy, nonatomic) NSString * avatar;
@property (copy, nonatomic) NSString * dzId;
@property (copy, nonatomic) NSString * idCard;
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * sex;
@property (copy, nonatomic) NSString * status;
@property (copy, nonatomic) NSString * srcId;

//txt 健康咨询,fz 复诊,mt 门特
@property (copy, nonatomic) NSString * srcType;
@property (copy, nonatomic) NSString * staffId;
@property (copy, nonatomic) NSString * staffName;
@property (copy, nonatomic) NSString * txt;

@property (copy, nonatomic) NSString *sendRoleName;
@property (copy, nonatomic) NSString *sendRoleType;
@property (copy, nonatomic) NSString *sendRoleIcon;

- (instancetype)initWithOrderRecord:(YXOrderRecordModel *)orderRecordModel;
@end

@interface HOIMConsultMsgExtraModel : HOIMMsgExtraModel
//_extra    __NSCFString *    @"{\"firstTime\":\"2019-4-21 11:46:13\",\"txt\":\"复诊免费测试\",\"firstHospitalName\":\"医事通认证医生\",\"srcId\":\"158479\",\"sex\":\"2\",\"firstIllness\":\"伤寒,\",\"name\":\"李昌联\",\"firstHospitalId\":1711,\"type\":\"fz\",\"srcType\":\"txt\",\"age\":\"64\"}"    0x00007ffe758af840

@property (copy, nonatomic) NSString * firstTime;
@property (copy, nonatomic) NSString * txt;
@property (copy, nonatomic) NSString * firstHospitalName;
@property (copy, nonatomic) NSString * firstIllness;
@property (copy, nonatomic) NSString * firstHospitalId;
@property (copy, nonatomic) NSString * img;

@property (strong, nonatomic) NSArray <NSString *> * arrayImage;
@property (copy, nonatomic) NSAttributedString * firstConsultationInfo;

@property (assign, nonatomic)  CGFloat diagnoseViewHeight;
@property (assign, nonatomic)  CGFloat illnessDesHeight;
@property (assign, nonatomic)  CGFloat imageListViewHeight;
@end

@interface HOIMPreMsgExtraModel : HOIMMsgExtraModel

///处方id
@property (copy, nonatomic) NSString * presID;
///病情描述
@property (copy, nonatomic) NSString * diagnose;
///电子病历id
@property (copy, nonatomic) NSString * recordId;


- (instancetype)initWithPatientRecordModel:(YXPatientRecordsModel *)patientRecordModel;
@end



NS_ASSUME_NONNULL_END
