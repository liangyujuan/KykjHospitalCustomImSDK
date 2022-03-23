//
//  CWComAndEncry.h
//  test
//
//  Created by Chenwei on 15/12/15.
//  Copyright © 2015年 com.cw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "NSData+GZIP.h"
#import "GTMBase64.h"
#import <Foundation/NSData.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static Byte iv[8]={1,2,3,4,5,6,7,8};
@interface CWComAndEncry : NSObject


/******************************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 ******************************************************************************/
+(NSData *)dataWithBase64EncodedString:(NSString *)string;




/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
 
+(NSString *) encryptUseDES:(NSData *)clearData key:(NSString *)key;


//编码
+(NSString*)encodeBase64String:(NSString * )input ;
//解码
+ (NSString*)decodeBase64String:(NSString * )input ;
+ (NSString*)encodeBase64Data:(NSData *)data ;
+ (NSString*)decodeBase64Data:(NSData *)data ;

@end
