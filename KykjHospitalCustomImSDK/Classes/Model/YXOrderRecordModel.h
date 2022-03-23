//
//  YXOrderRecordModel.h
//  GZHealthDoctor
//
//  Created by 施文松 on 2018/1/16.
//  Copyright © 2018年 施文松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXOrderRecordModel :NSObject

/** 就诊人姓名 */
@property (copy , nonatomic) NSString * USER_NAME;
/** 就诊人电话 */
@property (copy , nonatomic) NSString * CALL_PHONE;
/** 就诊人性别1男，2女 */
@property (copy , nonatomic) NSString * USER_SEX;
/** 就诊人身份证号 */
@property (copy , nonatomic) NSString * USER_ID_CARD;
/** 就诊人年龄 */
@property (copy , nonatomic) NSString * USER_AGE;
/** 就诊人民族 */
@property (copy , nonatomic) NSString * NATION;
/** 就诊人体重 */
@property (copy , nonatomic) NSString * WEIGHT;


//定制编号
@property (nonatomic , copy) NSString * DZ_ID;
/** 操作用户账号 */
@property (nonatomic , copy) NSString * LOGON_ACCT;
@property (nonatomic , copy) NSString * STAFF_ID;
@property (nonatomic , copy) NSString * REG_WAY_ID;
@property (nonatomic , copy) NSString * STAFF_ICON;
@property (nonatomic , copy) NSString * OP_TIME;
@property (nonatomic , copy) NSString * PAY_REC_NUM;
@property (nonatomic , copy) NSString * RN;
@property (nonatomic , copy) NSString * STAFF_NAME;
@property (nonatomic , copy) NSString * TIMES;
@property (nonatomic , copy) NSString * DEL_STATUS;
@property (nonatomic , copy) NSString * PRODUCT_ID;
@property (nonatomic , copy) NSString * DEP_NAME;
@property (nonatomic , copy) NSString * NAME_CN;
@property (nonatomic , copy) NSString * PRODUCT_NAME;
@property (nonatomic , copy) NSString * PRICE;
@property (nonatomic , copy) NSString * PAY_WAY_CODE;
@property (nonatomic , copy) NSString * SRC_ID;
@property (nonatomic , copy) NSString * STAFF_USER_ID;
@property (nonatomic , copy) NSString * END_TIME;
@property (nonatomic , copy) NSString * STAFF_MOBILE;
@property (nonatomic , copy) NSString * OP_USER_ID;
@property (nonatomic , copy) NSString * EV_NUM;
@property (nonatomic , copy) NSString * ORG_NAME;
@property (nonatomic , copy) NSString * PAY_PHONE;
@property (nonatomic , copy) NSString * ID_CARD;
//状态:C 有效 R 过期 E无效，U未支付，J拒诊，D待接诊(J,D互联网医院使用)
@property (nonatomic , copy) NSString * STATUS;
//定制类型(DZ_TS_TX号源提醒 DZ_ZX_TXT图文咨询,DZ_ZX_CALL电话咨询,DZ_FZ复诊,DZ_ZX_MT门特)
@property (nonatomic , copy) NSString * DZ_TYPE;
@property (nonatomic , copy) NSString * TIMES_REMAIN;
@property (nonatomic , copy) NSString * USER_ID;

@property (nonatomic , copy) NSString * PATIENT_FIRST_ID;//就诊人id

@property (nonatomic , copy) NSString * UUID;
@property (nonatomic , copy) NSString * CREATE_TIME;
@property (nonatomic , copy) NSString * ICON_URL;
@property (nonatomic , copy) NSString * START_TIME;
@property (nonatomic , copy) NSString * SEX;
@property (nonatomic , copy) NSString * BIRTH;
@property (nonatomic , copy) NSString * PAY_WAY_ID;
@property (nonatomic , copy) NSString * TRANS_STATUS;
@property (nonatomic , copy) NSString * PAY_NUM;
@property (nonatomic , copy) NSString * USER_NUM;
@property (nonatomic , copy) NSString * CANCEL_REASON;
@property (nonatomic , copy) NSString * CANCEL_TYPE;
/** productCode为DZ_ZX_TXT(图文咨询)、DZ_FZ(复诊)的时候有值。该值为Y，表示可进行图文咨询 */
@property (nonatomic , copy) NSString * IS_CONSULT;
/** productCode为DZ_ZX_TXT(图文咨询)、DZ_FZ(复诊)的时候有值。该值为订购过期时间。单位为s */
@property (nonatomic , copy) NSString * TIME_DIFF;

/** 医患关系id。传入staffid或者userid查询条件进行该值查询。有该值则表示存在对应的医患关系 */
@property (nonatomic , copy) NSString * STAFF_PATIENT_REL_ID;

@property (nonatomic, copy) NSString *EXT;

@property (nonatomic, copy) NSString *handleSuggestion;

@property (nonatomic, strong) NSNumber *isDoctorConfirmFurther;

@property (nonatomic, strong) NSNumber *isPatientConfirmFurther;

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSInteger type;

/// 文字： 已过期
@property (copy, nonatomic) NSString *overDateString;
/// 过期时间yyyy-MM-dd HH:mm:ss
@property (copy, nonatomic) NSString *overDateDetailString;
@property (copy, nonatomic) NSString *procesType;
@property (copy, nonatomic) NSString *titleString;

///状态 描述
@property (copy, nonatomic) NSString * statusStr;
///类型 描述
@property (copy, nonatomic) NSString * dzTypeStr;

///更新时的messageId,可能会以此判断是否需要更新订单状态
@property (assign, nonatomic) long messageId;

@property (nonatomic, assign) BOOL searchBottomLineShow;

@property (nonatomic, copy) NSString *CONSULT_CON;

@property (nonatomic, copy) NSString *PATIENT_ID;

//比较两个问诊订单是否相同
- (BOOL)isEqualWithOrderRecord:(YXOrderRecordModel *)orderRecordModel;
@end

