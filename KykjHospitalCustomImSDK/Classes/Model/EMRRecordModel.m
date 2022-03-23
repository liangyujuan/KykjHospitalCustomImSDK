//
//  EMRRecordModel.m
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/26.
//  Copyright © 2020 cc. All rights reserved.
//

#import "EMRRecordModel.h"
#import "Factory.h"
#import "MJExtension.h"

@implementation EMRRecordModel
- (void)mj_keyValuesDidFinishConvertingToObject{
   
    
    NSDictionary *kzColDic = [self.KZ_COL mj_JSONObject];
    if (kzColDic) {
        self.emrTempTitle = [kzColDic objectForKey:@"title"];
        self.emrTempRemark = [kzColDic objectForKey:@"des"];
    }
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.COMPLAINT forKey:@"COMPLAINT"];
    [aCoder encodeObject:self.NOW_MEDICAL_HISTORY forKey:@"NOW_MEDICAL_HISTORY"];
    [aCoder encodeObject:self.PAST_MEDICAL_HISTORY forKey:@"PAST_MEDICAL_HISTORY"];
    [aCoder encodeObject:self.ALLERGIC_HISTORY forKey:@"ALLERGIC_HISTORY"];
    [aCoder encodeObject:self.PHYSICAL_EXAMINATION forKey:@"PHYSICAL_EXAMINATION"];
    [aCoder encodeObject:self.DIAGNOSE forKey:@"DIAGNOSE"];
    [aCoder encodeObject:self.AUXILIARY_EXAMINATION forKey:@"AUXILIARY_EXAMINATION"];
    [aCoder encodeObject:self.PROPOSAL forKey:@"PROPOSAL"];
    [aCoder encodeObject:self.PERSONAL_HISTORY forKey:@"PERSONAL_HISTORY"];
    [aCoder encodeObject:self.MARRIAGE_CHILDBIRTH_HISTORY forKey:@"MARRIAGE_CHILDBIRTH_HISTORY"];
    [aCoder encodeObject:self.MENSTRUAL_HISTORY forKey:@"MENSTRUAL_HISTORY"];
    [aCoder encodeObject:self.OP_TIME forKey:@"OP_TIME_STR"];
    [aCoder encodeObject:self.RECORD_ID forKey:@"RECORD_ID"];
    [aCoder encodeObject:self.handleSuggestionTemp forKey:@"handleSuggestionTemp"];
    [aCoder encodeObject:self.KZ_COL forKey:@"KZ_COL"];
    [aCoder encodeObject:self.emrTempTitle forKey:@"emrTempTitle"];
    [aCoder encodeObject:self.emrTempRemark forKey:@"emrTempRemark"];
    [aCoder encodeObject:self.STAFF_NAME forKey:@"STAFF_NAME"];
    [aCoder encodeObject:self.DEP_NAME forKey:@"DEP_NAME"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        
        self.COMPLAINT=[aDecoder decodeObjectForKey:@"COMPLAINT"];
        self.NOW_MEDICAL_HISTORY=[aDecoder decodeObjectForKey:@"NOW_MEDICAL_HISTORY"];
        self.PAST_MEDICAL_HISTORY=[aDecoder decodeObjectForKey:@"PAST_MEDICAL_HISTORY"];
        self.ALLERGIC_HISTORY=[aDecoder decodeObjectForKey:@"ALLERGIC_HISTORY"];
        self.PHYSICAL_EXAMINATION=[aDecoder decodeObjectForKey:@"PHYSICAL_EXAMINATION"];
        
        self.DIAGNOSE=[aDecoder decodeObjectForKey:@"DIAGNOSE"];
//        self.DOCTOR_ADVICE=[aDecoder decodeObjectForKey:@"DOCTOR_ADVICE"];
        self.AUXILIARY_EXAMINATION=[aDecoder decodeObjectForKey:@"AUXILIARY_EXAMINATION"];
        self.PROPOSAL=[aDecoder decodeObjectForKey:@"PROPOSAL"];
        self.PERSONAL_HISTORY=[aDecoder decodeObjectForKey:@"PERSONAL_HISTORY"];
        self.MARRIAGE_CHILDBIRTH_HISTORY=[aDecoder decodeObjectForKey:@"MARRIAGE_CHILDBIRTH_HISTORY"];
        self.MENSTRUAL_HISTORY=[aDecoder decodeObjectForKey:@"MENSTRUAL_HISTORY"];
        self.OP_TIME = [aDecoder decodeObjectForKey:@"OP_TIME_STR"];
        self.RECORD_ID = [aDecoder decodeObjectForKey:@"RECORD_ID"];
        self.handleSuggestionTemp = [aDecoder decodeObjectForKey:@"handleSuggestionTemp"];
        self.KZ_COL = [aDecoder decodeObjectForKey:@"KZ_COL"];
        self.emrTempTitle = [aDecoder decodeObjectForKey:@"emrTempTitle"];
        self.emrTempRemark = [aDecoder decodeObjectForKey:@"emrTempRemark"];
        self.STAFF_NAME = [aDecoder decodeObjectForKey:@"STAFF_NAME"];
        self.DEP_NAME = [aDecoder decodeObjectForKey:@"DEP_NAME"];
    }
    return self;
}


@end
