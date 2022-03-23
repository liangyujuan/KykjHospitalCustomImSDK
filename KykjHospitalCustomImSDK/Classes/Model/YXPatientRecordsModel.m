//
//  YXPatientRecordsModel.m
//  YSTDoctor
//
//  Created by 施文松 on 2019/3/29.
//  Copyright © 2019 施文松. All rights reserved.
//

#import "YXPatientRecordsModel.h"
#import "NSDate+Extension.h"
#import "MJExtension.h"
#import "StringUtils.h"

@implementation YXPatientRecordsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)mj_keyValuesDidFinishConvertingToObject{
    NSArray * jsonObject = [self.DIAGNOSE mj_JSONObject];
    if (!jsonObject) {
        self.diseaseStr = self.DIAGNOSE;
        return;
    }
    __block NSMutableString * diseaseStr = [[NSMutableString alloc] init];
    [jsonObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (diseaseStr.length > 0) {
            [diseaseStr appendString:@","];
        }
        [diseaseStr appendString:getSafeString(obj[@"illName"])];
    }];
    self.diseaseStr = diseaseStr;
    
    NSDictionary *kzColDic = [self.KZ_COL mj_JSONObject];
    if (kzColDic) {
        self.emrTempTitle = [kzColDic objectForKey:@"title"];
        self.emrTempRemark = [kzColDic objectForKey:@"des"];
    }
    
}

@end
