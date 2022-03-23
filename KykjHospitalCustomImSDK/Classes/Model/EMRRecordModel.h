//
//  EMRRecordModel.h
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/26.
//  Copyright © 2020 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EMRRecordModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *RECORD_ID;
@property (nonatomic, copy) NSString *STAFF_USER_ID;
@property (nonatomic, copy) NSString *USER_ID;
@property (nonatomic, copy) NSString *PATIENT_NAME;
@property (nonatomic, copy) NSString *PATIENT_SEX;
@property (nonatomic, copy) NSString *PATIENT_IDCARD;
@property (nonatomic, copy) NSString *PATIENT_AGE;
@property (nonatomic, copy) NSString *INQUIRY_TIME;
@property (nonatomic, copy) NSString *INQUIRY_TIME_FORMAT;
@property (nonatomic, copy) NSString *DISEASE;
@property (nonatomic, copy) NSString *DISEASE_IMG;
@property (nonatomic, copy) NSString *DIAGNOSE;
//@property (nonatomic, copy) NSString *DOCTOR_ADVICE;
@property (nonatomic, copy) NSString *REPORT_IMG;
@property (nonatomic, copy) NSString *RECIPE_ID;
@property (nonatomic, copy) NSString *RECIPE_DESC;
@property (nonatomic, copy) NSString *RECIPE_IMG;
@property (nonatomic, copy) NSString *COMPLAINT;
@property (nonatomic, copy) NSString *NOW_MEDICAL_HISTORY;
@property (nonatomic, copy) NSString *PAST_MEDICAL_HISTORY;
@property (nonatomic, copy) NSString *ALLERGIC_HISTORY;
@property (nonatomic, copy) NSString *PHYSICAL_EXAMINATION;
@property (nonatomic, copy) NSString *AUXILIARY_EXAMINATION;
@property (nonatomic, copy) NSString *PROPOSAL;
@property (nonatomic, copy) NSString *HANDLE;
@property (nonatomic, copy) NSString *NATION;
@property (nonatomic, copy) NSString *MARRIAGE;
@property (nonatomic, copy) NSString *PROFESSION;
@property (nonatomic, copy) NSString *BIZ_ID;
@property (nonatomic, copy) NSString *BIZ_TYPE;
@property (nonatomic, copy) NSString *BIZ_TYPE_NAME;
@property (nonatomic, copy) NSString *MENSTRUAL_HISTORY;//月经史
@property (nonatomic, copy) NSString * MARRIAGE_CHILDBIRTH_HISTORY;//婚育史
@property (nonatomic, copy) NSString * PERSONAL_HISTORY;//个人史

@property (nonatomic, copy) NSString *OP_TIME;//修改时间
@property (nonatomic, copy) NSString *OP_TIME_STR;

@property (nonatomic, copy) NSString *handleSuggestionTemp;//草稿存储，处理意见

@property (nonatomic, copy) NSString *KZ_COL;

@property (nonatomic, copy) NSString *emrTempTitle;

@property (nonatomic, copy) NSString *emrTempRemark;

@property (nonatomic, copy) NSString *STAFF_NAME;

@property (nonatomic, copy) NSString *DEP_NAME;

@property (nonatomic, copy) NSString *DEP_ID;

@property (nonatomic, copy) NSString *STAFF_TYPE_NAME;

@property (nonatomic, copy) NSString *CREATE_TIME;

@property (nonatomic, copy) NSString *PATIENT_ID;

@end

NS_ASSUME_NONNULL_END
