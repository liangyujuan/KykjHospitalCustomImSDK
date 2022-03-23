//
//  YXOrderRecordModel.m
//  GZHealthDoctor
//
//  Created by 施文松 on 2018/1/16.
//  Copyright © 2018年 施文松. All rights reserved.
//

#import "YXOrderRecordModel.h"
#import "MJExtension.h"
#import "StringUtils.h"

@implementation YXOrderRecordModel

- (void)mj_keyValuesDidFinishConvertingToObject{
   
}

- (NSString *)statusStr{
    if (_statusStr) {
        return _statusStr;
    }
    _statusStr = @"已接诊";
//    状态:C 有效 R 过期 E无效，U未支付，J拒诊，D待接诊(J,D互联网医院使用)
    if ([self.STATUS isEqualToString:@"C"]) {
        _statusStr = @"已接诊";
    }else if ([self.STATUS isEqualToString:@"R"]){
        if ([self.TRANS_STATUS isEqualToString:@"T"]) {
            _statusStr = @"已关闭";
        }else
        _statusStr = @"已完成";
    }else if ([self.STATUS isEqualToString:@"E"]){
        _statusStr = @"无效";
    }else if ([self.STATUS isEqualToString:@"U"]){
        _statusStr = @"未支付";
    }else if ([self.STATUS isEqualToString:@"J"]){
        _statusStr = @"已关闭";
    }else if ([self.STATUS isEqualToString:@"D"]){
        _statusStr = @"待接诊";
    }
    return _statusStr;
}

- (NSString *)dzTypeStr{
    if (_dzTypeStr) {
        return _dzTypeStr;
    }
    
    if ([self.DZ_TYPE isEqualToString:@"DZ_ZX_TXT"]) {
        _dzTypeStr = @"健康咨询";
    }else if ([self.DZ_TYPE isEqualToString:@"DZ_FZ"]){
        _dzTypeStr = @"互联网复诊";
    }else if ([self.DZ_TYPE isEqualToString:@"DZ_ZX_MT"]){
        _dzTypeStr = @"门特续方";
    }else{
        _dzTypeStr = @"未知";
    }
    
    return _dzTypeStr;
}

- (NSString *)ICON_URL{
    if (_ICON_URL.length == 0) {
        return @"";
    }
    return _ICON_URL;
}

- (BOOL)isEqualWithOrderRecord:(YXOrderRecordModel *)orderRecordModel{
    NSDictionary * dictSelf = [self mj_JSONObject];
    NSDictionary * dictTarget = [orderRecordModel mj_JSONObject];
    for (NSString * key in dictSelf.allKeys) {
        if (![getSafeString(dictSelf[key]) isEqualToString:dictTarget[key]]) {
            return NO;
        }
    }
    return YES;
}
@end
