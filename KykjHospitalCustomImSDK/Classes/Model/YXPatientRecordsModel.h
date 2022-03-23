//
//  YXPatientRecordsModel.h
//  YSTDoctor
//
//  Created by 施文松 on 2019/3/29.
//  Copyright © 2019 施文松. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPatientRecordsModel : NSObject

/** 记录ID */
@property (copy , nonatomic) NSString * RECORD_ID;
/** 医生用户ID */
@property (copy , nonatomic) NSString * STAFF_USER_ID;
/** 患者ID */
@property (copy , nonatomic) NSString * USER_ID;
/** 患者姓名 */
@property (copy , nonatomic) NSString * PATIENT_NAME;
/** 患者性别 */
@property (copy , nonatomic) NSString * PATIENT_SEX;

@property (copy , nonatomic) NSString * PATIENT_ID;

/** 患者身份证 */
@property (copy , nonatomic) NSString * PATIENT_IDCARD;
/** 服务时间YYYY-MM-DDhh24:mi:ss */
@property (copy , nonatomic) NSString * INQUIRY_TIME;
/** 服务时间YYYY-MM-DD */
@property (copy , nonatomic) NSString * INQUIRY_TIME_FORMAT;
/** 患者病情 */
@property (copy , nonatomic) NSString * DISEASE;
/** 患者病情图片 */
@property (copy , nonatomic) NSString * DISEASE_IMG;
/** 医生诊断信息 */
@property (copy , nonatomic) NSString * DIAGNOSE;
/** 医嘱 */
//@property (copy , nonatomic) NSString * DOCTOR_ADVICE;
/** 检验检查报告图片 */
@property (copy , nonatomic) NSString * REPORT_IMG;
/** 用药及处方ID */
@property (copy , nonatomic) NSString * RECIPE_ID;
/** 用药及处方说明 */
@property (copy , nonatomic) NSString * RECIPE_DESC;
/** 用药及处方图片 */
@property (copy , nonatomic) NSString * RECIPE_IMG;
/** 业务类型ID */
@property (copy , nonatomic) NSString * BIZ_ID;
/** 业务类型 */
@property (copy , nonatomic) NSString * BIZ_TYPE;
/** 业务类型名称 */
@property (copy , nonatomic) NSString * BIZ_TYPE_NAME;

/** 主诉 */
@property (copy , nonatomic) NSString * COMPLAINT        ;
/** 现病史 */
@property (copy , nonatomic) NSString * NOW_MEDICAL_HISTORY     ;
/** 既往史 */
@property (copy , nonatomic) NSString * PAST_MEDICAL_HISTORY     ;
/** 过敏史 */
@property (copy , nonatomic) NSString * ALLERGIC_HISTORY     ;
/** 体格检查 */
@property (copy , nonatomic) NSString * PHYSICAL_EXAMINATION     ;
/** 辅助检查 */
@property (copy , nonatomic) NSString * AUXILIARY_EXAMINATION     ;
/** 体重 */
@property (copy , nonatomic) NSString * WEIGHT     ;

/** 个人史 */
@property (copy , nonatomic) NSString * PERSONAL_HISTORY;
/** 建议 */
@property (copy , nonatomic) NSString * PROPOSAL     ;
/** 民族 */
@property (copy , nonatomic) NSString * NATION        ;
/** 婚姻 */
@property (copy , nonatomic) NSString * MARRIAGE        ;

/** 月经史 */
@property (copy , nonatomic) NSString * MENSTRUAL_HISTORY;
/** 婚育史 */
@property (copy , nonatomic) NSString * MARRIAGE_CHILDBIRTH_HISTORY;
/** 操作人的userID */
@property (copy , nonatomic) NSString * op_user_id;

/** 医生诊断 */
@property (copy, nonatomic) NSString * diseaseStr;
/** 医院 */
@property (copy, nonatomic) NSString * ORG_ID;

@property (copy, nonatomic) NSString * DEP_NAME;

@property (copy, nonatomic) NSString * DEP_ID;

@property (copy, nonatomic) NSString * STAFF_NAME;

//检查申请表
@property (copy, nonatomic) NSString * JC_IDS;
//检验申请表
@property (copy, nonatomic) NSString * JY_IDS;

//用于病历列表显示
@property (assign, nonatomic) BOOL topLineHidden;
@property (assign, nonatomic) BOOL bottomLineHidden;

//用于显示年龄的时候显示月份
@property (assign, nonatomic) NSInteger monthNum;
/** 患者年龄 */
@property (copy , nonatomic) NSString * PATIENT_AGE;

@property (nonatomic, copy) NSString *srcId;

@property (nonatomic, copy) NSString *KZ_COL;

@property (nonatomic, copy) NSString *emrTempTitle;

@property (nonatomic, copy) NSString *emrTempRemark;

@property (nonatomic, copy) NSString *STAFF_TYPE_NAME;

/**
 php接口*/
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *diagnosis;
@property (nonatomic, copy) NSString *doctor;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *pathogeny;
@property (nonatomic, copy) NSString *patientAge;
@property (nonatomic, copy) NSString *patientGender;
@property (nonatomic, copy) NSString *patientName;
@property (nonatomic, copy) NSString *prescriptionDate;
@property (nonatomic, copy) NSString *prescriptionDiagnosis;
@property (nonatomic, copy) NSString *recordId;

@property (nonatomic, copy) NSString *AuxiliaryExamination;//辅助检查结果
@property (nonatomic, copy) NSString *advice;//建议
@property (nonatomic, copy) NSString *allergyHistory;//过敏史
@property (nonatomic, copy) NSString *complaint;//主诉
@property (nonatomic, copy) NSString *deal;//处理方式
@property (nonatomic, copy) NSString *marriage;
@property (nonatomic, copy) NSString *marriageHistory;//婚育史
@property (nonatomic, copy) NSString *menstrualHistory;//月经史
@property (nonatomic, copy) NSString *nation;
@property (nonatomic, copy) NSString *pMHistory;//既往史
@property (nonatomic, copy) NSString *personalHistory;//个人史
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *physicalExamination;//体格检查
@property (nonatomic, copy) NSString *presentIllness;//现病史
@property (nonatomic, copy) NSString *regDate;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
