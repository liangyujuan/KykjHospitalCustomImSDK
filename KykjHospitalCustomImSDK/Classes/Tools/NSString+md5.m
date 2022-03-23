//
//  NSString+md5.m
//  YstPatientEdition
//
//  Created by adtech on 16/3/9.
//  Copyright © 2016年 adtech. All rights reserved.
//

#import "NSString+md5.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)
- (NSString *)MD5Base64String
{
  
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}
@end
