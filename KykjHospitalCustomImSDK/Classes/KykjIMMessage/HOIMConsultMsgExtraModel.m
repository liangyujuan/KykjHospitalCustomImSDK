//
//  HOIMConsultMsgExaModel.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/21.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HOIMConsultMsgExtraModel.h"
#import "Factory.h"


@implementation HOIMConsultMsgExtraModel

- (void)mj_keyValuesDidFinishConvertingToObject{
    if (self.img.length > 0)
    self.arrayImage = [self.img componentsSeparatedByString:@","];
    if (self.txt.length == 0) {
        self.txt = @"无";
    }
    self.status = @"C";
    NSMutableAttributedString * firstConsultationInfoAttStr = [[NSMutableAttributedString alloc] init];
    NSMutableString * firstConsultationInfoStr = [[NSMutableString alloc] init];
    
    NSRange hosRange = NSMakeRange(0, 0);
    NSRange timeRange = NSMakeRange(0, 0);;
    NSRange illnessRange = NSMakeRange(0, 0);;
    
    if (self.firstHospitalName.length > 0) {
        [firstConsultationInfoStr appendFormat:@"医院：%@",self.firstHospitalName];
        hosRange = NSMakeRange(0, 3);
    }
    if (self.firstTime.length > 0) {
        if (firstConsultationInfoStr.length > 0) {
            [firstConsultationInfoStr appendString:@"\n"];
        }
        timeRange = NSMakeRange(firstConsultationInfoStr.length, 3);
        [firstConsultationInfoStr appendFormat:@"时间：%@",self.firstTime];
        
    }
    
    if (self.firstIllness.length > 0) {
        if (firstConsultationInfoStr.length > 0) {
            [firstConsultationInfoStr appendString:@"\n"];
        }
        illnessRange = NSMakeRange(firstConsultationInfoStr.length, 3);
        [firstConsultationInfoStr appendFormat:@"诊断：%@",self.firstIllness];
    }
    [firstConsultationInfoAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:firstConsultationInfoStr]];
    if (hosRange.length > 0) {
        [firstConsultationInfoAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 green:102 blue:102 alpha:1] range:hosRange];
    }
    if (timeRange.length > 0) {
        [firstConsultationInfoAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 green:102 blue:102 alpha:1] range:timeRange];
    }
    if (illnessRange.length > 0) {
        [firstConsultationInfoAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 green:102 blue:102 alpha:1] range:illnessRange];
    }
    [firstConsultationInfoAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, firstConsultationInfoStr.length)];
    self.firstConsultationInfo = firstConsultationInfoAttStr;
    
}


@end

@implementation HOIMMsgExtraModel

- (instancetype)initWithOrderRecord:(YXOrderRecordModel *)orderRecordModel{
    self = [super init];
    if (self) {
//        self.age = orderRecordModel.USER_AGE;
//        self.dzId = orderRecordModel.DZ_ID;
//        self.idCard = orderRecordModel.ID_CARD;
//        self.name = orderRecordModel.USER_NAME;
//        self.sex = orderRecordModel.SEX;
//        self.status = orderRecordModel.STATUS;
//        self.avatar = orderRecordModel.ICON_URL;
//        self.srcId = orderRecordModel.DZ_ID;
//        self.regWayCode = RegWayCode;
//        self.staffId = system.loginUser.STAFF_ID;
//        self.staffName = system.loginUser.STAFF_NAME;
//
        //定制类型(DZ_TS_TX号源提醒 DZ_ZX_TXT图文咨询,DZ_ZX_CALL电话咨询,DZ_FZ复诊)
//        if ([orderRecordModel.DZ_TYPE isEqualToString:@"DZ_ZX_TXT"]) {
//            self.srcType = @"txt";
//        }else if ([orderRecordModel.DZ_TYPE isEqualToString:@"DZ_FZ"]){
//            self.srcType = @"fz";
//        }
    }
    return self;
}

@end


@implementation HOIMPreMsgExtraModel

- (instancetype)initWithPatientRecordModel:(YXPatientRecordsModel *)patientRecordModel{
    self = [super init];
        if (self) {
            self.age = patientRecordModel.PATIENT_AGE;
            self.name = patientRecordModel.PATIENT_NAME;
            self.sex = patientRecordModel.PATIENT_SEX;
    //        self.avatar = recipeModel.ICON_URL;
            self.presID = patientRecordModel.RECIPE_ID;
            self.recordId = patientRecordModel.RECORD_ID;
            self.regWayCode = RegWayCode;
     
            self.srcType = @"txt";
            self.srcId = patientRecordModel.BIZ_ID;
            
            NSString *sendName = patientRecordModel.PATIENT_NAME.length>0 ? patientRecordModel.PATIENT_NAME : @"";
            self.sendRoleName = sendName;
           
//            NSString *icon = patientRecordModel.icon.length>0 ? patientRecordModel.STAFF_ICON : @"";
//            self.sendRoleIcon=  icon;
            
           
            /*NSArray <DiagnosisItemModel *>* diagList =[DiagnosisItemModel mj_objectArrayWithKeyValuesArray:[patientRecordModel.DIAGNOSE mj_JSONObject]];
            NSMutableString * diagnose = [[NSMutableString alloc] init];
            [diagList enumerateObjectsUsingBlock:^(DiagnosisItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (diagnose.length > 0) {
                    [diagnose appendString:@","];
                }
                [diagnose appendString:obj.illName];
            }];*/
            self.diagnose = patientRecordModel.DIAGNOSE;
        }
        return self;
}

@end
