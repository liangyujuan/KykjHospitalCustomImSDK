//
//  StringUtils.m
//  dd
//
//  Created by Xia on 14-7-24.
//  Copyright (c) 2014年 letide. All rights reserved.
//

#import "StringUtils.h"
#import "sys/utsname.h"
#import "NSData+GZIP.h"
#import "CWComAndEncry.h"
#import "NSString+md5.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "NSDate+Extension.h"
#import "Factory.h"

static NSString *const  serverImageBase_URL = @"https://hospital.tianyucare.com";


#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
//static NSString* key = @"OM5w9LWSRUk=";
static NSString* key = @"N0quzVeks0k=";

//static NSString* key = @"N1quzVeks1k=";


#define IsOSVersionAtLeastiOS7() (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)//版本号

@implementation StringUtils

NSString * getSafeString(id object)
{
    NSString *string = nil;
    if ([object isKindOfClass:[NSNull class]]||object==nil||[[NSString stringWithFormat:@"%@",object] isEqualToString:@"(null)"]) {
        string = @"";
    }else
    {
        string = [NSString stringWithFormat:@"%@",object];
    }
    
    return string;
}

/**
 *  getImageAddress
 *
 *  @param NSString urlStr
 *
 *  @return NSURL
 */
NSURL * getImageAddress(NSString * urlStr)
{
    if ([urlStr hasPrefix:@"http"]) {
        return [NSURL URLWithString:urlStr];
    }else if (urlStr.length == 0){
        return nil;
    } else{
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",serverImageBase_URL,urlStr]];
    }
}

+ (CGRect) getAttributedStringSize:(NSAttributedString*)str Andwidht:(CGSize)size
{
    CGRect rect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics context:nil];
    return rect;
}


+ (NSDictionary *)md5ParamsWith:(NSDictionary *)params needEncryption:(BOOL)isNeed{
    NSMutableDictionary *tempParams = [[NSMutableDictionary alloc] initWithDictionary:params];
    [tempParams setObject:RegWayCode forKey:@"SC"];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//    [tempParams setObject:[StringUtils deviceString] forKey:@"DEV"];
    [tempParams setObject:VersionNumber forKey:@"VER"];
    [tempParams setObject:phoneVersion forKey:@"OS"];
 
    //token暂时写死
    [tempParams setValue:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJhdXRoMCIsImV4cCI6MTc0MjI3ODc4OCwidXNlcm5hbWUiOiIxNzc4NDg4NCJ9.Sskv8ZP_4i1AqUt0ghrOiMb8rAeAafYYmYM9gqV3uSA" forKey:@"TOKEN"];
    
//    if (system.loginInfo.USER_ID.length > 0)
//        [tempParams setObject:system.loginInfo.USER_ID forKey:@"USERID"];
//    if ([UserCache sharedInstance].location.x > 0) {
//        NSString * loc = [NSString stringWithFormat:@"%f,%f",[UserCache sharedInstance].location.x,[UserCache sharedInstance].location.y];
//        [tempParams setObject:loc forKey:@"LOC"];
//    }

    if (!isNeed) {
        NSArray * allkey = tempParams.allKeys;
        [allkey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = tempParams[obj];
            if ([value isKindOfClass:[NSNumber class]]) {
                [tempParams setObject:getSafeString(value)  forKey:obj];
            }
        }];
        NSLog(@"tempParams---%@",[KykjImToolkit jsonFromObject:tempParams]);
        return tempParams;
    }
    NSArray * allkey = tempParams.allKeys;
    [allkey enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = tempParams[obj];
        if ([value isKindOfClass:[NSNumber class]]) {
            [tempParams setObject:getSafeString(value)  forKey:obj];
        }
    }];
    params = tempParams;
    
    /************************此处进行md5加密********************************/
    NSArray *array=[params allKeys];
    

    
    array=[array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result=[obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    NSString *strSecret=@"";
    NSString *strParam=@"";
    
    BOOL addRecordPIC = NO;
    if ([[tempParams objectForKey:@"method"] isEqualToString:@"addHlRecord"]) {//
        NSDictionary *tempDic;
        if([[tempParams objectForKey:@"body"] isKindOfClass:[NSString class]]){
            tempDic = [KykjImToolkit dictionaryWithJson:[tempParams objectForKey:@"body"]];
        }else{
            tempDic = [tempParams objectForKey:@"body"];
        }
        
        if ([[tempDic objectForKey:@"rcType"] isEqualToString:@"37"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"38"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"40"]) {
            addRecordPIC = YES;
        }
    }
    
    if([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[tempParams objectForKey:@"method"] isEqualToString:@"getDoctorList"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"]){
        for (int j=0; j<array.count; j++) {

            id str = tempParams[array[j]];
            NSString *firstKey = array[j];
            
            if (![str isKindOfClass:[NSString class]] && ![str isKindOfClass:[NSNumber class]]) {

                NSMutableString *secretStr = [NSMutableString new];
                NSMutableString *paraStr = [NSMutableString new];

                if([str isKindOfClass:[NSArray class]]){
                    
                    
                    
                    [secretStr appendString:@"["];
                    [paraStr appendString:@"["];
                    NSArray * arrayStr = str;

                    if (arrayStr.count > 0) {

    //                    NSDictionary *stringDic = [self arrayToJson:arrayStr keyString:array[j]];
    //
    //                    strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                    strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];

                        id arrSubStr = arrayStr.firstObject;
                        if ([arrSubStr isKindOfClass:[NSDictionary class]]) {
                            for (int tempi = 0;tempi<arrayStr.count;tempi++) {
                                NSDictionary *dict = arrayStr[tempi];
                                [secretStr appendString:@"{"];
                                [paraStr appendString:@"{"];


                                NSArray *tempArray = dict.allKeys;
                                tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                                        return[obj1 compare:obj2 options:NSNumericSearch];//正序
                                }];

                                for (int k=0;k<tempArray.count;k++) {
                                    NSString *keyS = tempArray[k];
                                    if([dict[keyS] isKindOfClass:[NSDictionary class]]){
                                        NSDictionary *dict1 = dict[keyS];

                                        [paraStr appendString:[NSString stringWithFormat:@"%@:",keyS]];
                                        if([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[tempParams objectForKey:@"method"]  isEqualToString:@"addStaffCollect"]){
                                            [secretStr appendString:[NSString stringWithFormat:@"%@=",keyS]];
                                            [paraStr appendString:@"{"];
                                            [secretStr appendString:@"{"];
                                        }else{
                                            [secretStr appendString:[NSString stringWithFormat:@"\"%@\":",keyS]];
                                            [paraStr appendString:@"{"];
                                            [secretStr appendString:@"\"{"];
                                        }



                                        NSArray *tempArray1 = dict1.allKeys;
                                        tempArray1 = [tempArray1 sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                                                return[obj1 compare:obj2 options:NSNumericSearch];//正序
                                        }];

                                        for (int j=0;j<tempArray1.count;j++) {
                                            NSString *keyS1 = tempArray1[j];
                                            NSString *tempStr1 = dict1[keyS1];
                                            if (j<tempArray1.count-1) {
                                                [secretStr appendFormat:@"\"%@\":\"%@\",",keyS1,getSafeString(dict1[keyS1])];
                                            }else{
                                                [secretStr appendFormat:@"\"%@\":\"%@\"",keyS1,getSafeString(dict1[keyS1])];
                                            }

                                            [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS1,tempStr1!=nil ? tempStr1 :@""];
                                        }
                                        if (paraStr.length > 0) {
                                            [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                                        }

                                        if([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"])){
                                            [secretStr appendString:@"}, "];
                                        }
                                        else{
                                            if (secretStr.length > 0) {
                                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                                            }
                                            [secretStr appendString:@"}\","];
                                        }

                                        [paraStr appendString:@"},"];



    //                                    [paraStr appendString:[NSString stringWithFormat:@",\"%@\":\"%@\"",keyS,paraStr]];
    //                                    [secretStr appendString:[NSString stringWithFormat:@"&%@=%@",[NSString stringWithFormat:@",\"%@\":\"%@\"",keyS,paraStr],secretStr]];
                                    }
                                    else if([dict[keyS] isKindOfClass:[NSArray class]]){
                                        NSDictionary *tempJsonDic = [self paramSecretJsonWithArray:dict[keyS] tempParams:tempParams firstKey:firstKey key:keyS];
                                        if([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"]){
                                            [secretStr appendFormat:@"%@=%@, ",keyS,[tempJsonDic objectForKey:@"secretStr"]];
                                            [paraStr appendString:[tempJsonDic objectForKey:@"paraStr"]];
                                        }else{
                                            [secretStr appendString:[tempJsonDic objectForKey:@"secretStr"]];
                                            [paraStr appendString:[tempJsonDic objectForKey:@"paraStr"]];
                                            [secretStr appendString:@","];
                                        }
                                        
                                        
                                        [paraStr appendString:@","];
                                    }
                                    else{

                                        NSString *string = dict[keyS];
                                        if((([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"]))&& ![keyS isEqualToString:@"icdCode"]&& ![keyS isEqualToString:@"illName"] && ![keyS isEqualToString:@"icStaus"]) || ([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"])){
                                            if (k==tempArray.count-1) {
                                                [secretStr appendFormat:@"%@=%@",keyS,string!=nil ? string : @""];
                                            }else{
                                                [secretStr appendFormat:@"%@=%@, ",keyS,string!=nil ? string : @""];
                                            }

                                        }
                                        else if(([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"]))&& [keyS isEqualToString:@"illName"]){
                                            [secretStr appendFormat:@"\"%@\":\"%@\"",keyS,string!=nil ? string : @""];

                                        }
                                        else{
                                            [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,string!=nil
                                             ? string : @""];
                                        }


                                        [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS,dict[keyS]];
                                    }


                                }
                                if(!([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"])){
                                    if (secretStr.length > 0) {
                                        [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                                    }
                                }

                                if (paraStr.length > 0) {
                                    [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                                }
    //
    //                            if (secretStr.length > 0) {
    //                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
    //                            }
                                if(([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"])) && ![firstKey isEqualToString:@"icdVal"]){

                                    [secretStr appendString:@"}, "];
                                }
                                else if([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"]){
                                    [secretStr appendString:@"}, "];
                                }
                                else{
                                    [secretStr appendString:@"},"];
                                }

                                [paraStr appendString:@"},"];

                            }

    //                        if (secretStr.length > 0) {
    //                            [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
    //                        }

                            if (secretStr.length > 0) {
                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                            }
                            if (paraStr.length > 0) {
                                [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                            }

                            if((([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"])) && ![firstKey isEqualToString:@"icdVal"]) || ([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"])){

                                if (secretStr.length > 0) {
                                    [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                                }
                            }

                            [secretStr appendString:@"]"];
                            [paraStr appendString:@"]"];

                            str = [KykjImToolkit jsonFromObject:str];

    //                        NSDictionary *stringDic = [self dicToJson:arrSubStr keyString:array[j]];
    //                        strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                        strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
                            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],paraStr]];
                            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],secretStr.length>0 ? secretStr : @""]];

                        }else{
                            NSMutableString *mstr = [[NSMutableString alloc] init];
                            NSMutableString *sstr = [[NSMutableString alloc] init];
                            [mstr appendString:@"["];
                            for (id obj in str) {
                                if (mstr.length > 1) {
                                    [mstr appendString:@", "];
                                }
                                [mstr appendFormat:@"\"%@\"",obj];
                            }
                            [mstr appendString:@"]"];
                            [sstr appendString:@"["];
                            for (id obj in str) {
                                if (sstr.length > 1) {
                                    [sstr appendString:@", "];
                                }
                                [sstr appendFormat:@"%@",obj];
                            }
                            [sstr appendString:@"]"];
                            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%@",array[j],mstr]];
                            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],sstr.length>0 ? sstr : @""]];
                        }
                    }
                }
                else if ([str isKindOfClass:[NSDictionary class]]){

                    NSDictionary * dict = str;
                    [paraStr appendString:@"{"];
                    [secretStr appendString:@"{"];
            
                    NSArray *tempArray = dict.allKeys;
                    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                            return[obj1 compare:obj2 options:NSNumericSearch];//正序
                    }];
                    for (int tempkeyi = 0; tempkeyi<tempArray.count;tempkeyi++) {
                        NSString *keyS = tempArray[tempkeyi];
    //                    id obj = [tempArray objectAtIndex:tempkeyi];
                        if ([dict[keyS] isKindOfClass:[NSArray class]]) {
                            NSDictionary *tempJsonDic = [self paramSecretJsonWithArray:dict[keyS] tempParams:tempParams firstKey:firstKey key:keyS];
                            
                            [secretStr appendFormat:@"%@=%@, ",keyS,[tempJsonDic objectForKey:@"secretStr"]];
                            [paraStr appendString:[tempJsonDic objectForKey:@"paraStr"]];
                            
                            
                        }else{
                            if (([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"])&&[firstKey isEqualToString:@"kzCol"]) {
                                if(tempkeyi==tempArray.count-1){
                                    [secretStr appendFormat:@"\"%@\":\"%@\"",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
                                }else{
                                    [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
                                }

                            }
//                            else if([[tempParams objectForKey:@"method"] isEqualToString:@"addHlRecord"]){
//                                if(tempkeyi==tempArray.count-1){
//                                    [secretStr appendFormat:@"\"%@\":\"%@\"",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
//                                }else{
//                                    [secretStr appendFormat:@"\"%@\":\"%@\", ",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
//                                }
//                            }
                            else{
                                if(tempkeyi==tempArray.count-1){
                                    [secretStr appendFormat:@"%@=%@",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
                                }else{
                                    [secretStr appendFormat:@"%@=%@, ",keyS,dict[keyS]!=nil ? dict[keyS] : @""];
                                }
                                
                            }
                            
                            
                            [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS,dict[keyS]];
                        }
                        
                    }


    //                if (secretStr.length > 0) {
    //                    [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
    //                }
                    if (paraStr.length > 0) {
                        [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                    }
                    [secretStr appendString:@"}"];

                    [paraStr appendString:@"}"];

                    str = [KykjImToolkit jsonFromObject:str];

                    strParam = [strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],paraStr]];
                    strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],secretStr!=nil ? secretStr : @""]];
                    
    //                NSDictionary *stringDic = [self dicToJson:dict keyString:array[j]];
    //                strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
                }
            }else{
                
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],str]];
                strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],str!=nil ? str : @""]];
            }
        }
        strSecret= [NSString stringWithFormat:@"%@%@",key,[strSecret substringFromIndex:1]];//加密字符串
        strParam =[NSString stringWithFormat:@"{%@}",[strParam substringFromIndex:1]];//未加密
    }
    else if([[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"]){
        for (int j=0; j<array.count; j++) {
           
            NSString *keyString = array[j];
            id str = params[array[j]];
          
            if([keyString isEqualToString:@"hidTaskItemDatas"]){
                NSString *jsonString = str;
                NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
                NSRange range = {0,jsonString.length};
                //去掉字符串中的空格
                [mutStr replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:range];
                NSRange range2 = {0,mutStr.length};
        //        //去掉字符串中的换行符
                [mutStr replaceOccurrencesOfString:@"\\n" withString:@"\\\\n" options:NSLiteralSearch range:range2];
                
                [mutStr replaceOccurrencesOfString:@"\\r" withString:@"\\\\r" options:NSLiteralSearch range:range2];
                [mutStr replaceOccurrencesOfString:@"\\t" withString:@"\\\\t" options:NSLiteralSearch range:range2];
            NSString *json = [NSString stringWithFormat:@"%@",mutStr];
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],json]];
            }else{
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],str]];
            }
            
            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],str]];
        }
        strSecret= [NSString stringWithFormat:@"%@%@",key,[strSecret substringFromIndex:1]];//加密字符串
        strParam =[NSString stringWithFormat:@"{%@}",[strParam substringFromIndex:1]];//未加密
    }
    else if([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"MRECORD"]){
        for (int j=0; j<array.count; j++) {
           
            NSString *keyString = array[j];
            id str = params[array[j]];
          
            if([keyString isEqualToString:@"mRecord"] || [keyString isEqualToString:@"kzCol"]){
                NSString *jsonString = str;
                NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
                NSRange range = {0,jsonString.length};
                //去掉字符串中的空格
                [mutStr replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:range];
                NSRange range2 = {0,mutStr.length};
        //        //去掉字符串中的换行符
                [mutStr replaceOccurrencesOfString:@"\\n" withString:@"\\\\n" options:NSLiteralSearch range:range2];
                [mutStr replaceOccurrencesOfString:@"\\r" withString:@"\\\\r" options:NSLiteralSearch range:range2];
                [mutStr replaceOccurrencesOfString:@"\\t" withString:@"\\\\t" options:NSLiteralSearch range:range2];
                
            NSString *json = [NSString stringWithFormat:@"%@",mutStr];
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],json]];
            }else{
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],str]];
            }
            
            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],str]];
        }
        strSecret= [NSString stringWithFormat:@"%@%@",key,[strSecret substringFromIndex:1]];//加密字符串
        strParam =[NSString stringWithFormat:@"{%@}",[strParam substringFromIndex:1]];//未加密
    }
    else if(addRecordPIC || [[tempParams objectForKey:@"method"] isEqualToString:@"createHlOrder"]){
        for (int j=0; j<array.count; j++) {
           
            NSString *keyString = array[j];
            id str = params[array[j]];
          
            if([keyString isEqualToString:@"body"]){
                NSString *jsonString = str;
                NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
                NSRange range = {0,jsonString.length};
                //去掉字符串中的空格
                [mutStr replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSLiteralSearch range:range];
                NSRange range2 = {0,mutStr.length};
                [mutStr replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSLiteralSearch range:range2];
                
                
//        //        //去掉字符串中的换行符
//                [mutStr replaceOccurrencesOfString:@"\\n" withString:@"\\\\n" options:NSLiteralSearch range:range2];
//                [mutStr replaceOccurrencesOfString:@"\\r" withString:@"\\\\r" options:NSLiteralSearch range:range2];
//                [mutStr replaceOccurrencesOfString:@"\\t" withString:@"\\\\t" options:NSLiteralSearch range:range2];

            NSString *json = [NSString stringWithFormat:@"%@",mutStr];
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],json]];
            }else{
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],str]];
            }
            
            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],str]];
        }
        strSecret= [NSString stringWithFormat:@"%@%@",key,[strSecret substringFromIndex:1]];//加密字符串
        strParam =[NSString stringWithFormat:@"{%@}",[strParam substringFromIndex:1]];//未加密
    }
    else{
        for (int j=0; j<array.count; j++) {

            id str = params[array[j]];
            if (![str isKindOfClass:[NSString class]] && ![str isKindOfClass:[NSNumber class]]) {

                NSMutableString *secretStr = [NSMutableString new];
                NSMutableString *paraStr = [NSMutableString new];

                if([str isKindOfClass:[NSArray class]]){
                    [secretStr appendString:@"["];
                    [paraStr appendString:@"["];
                    NSArray * arrayStr = str;
                    
                    if (arrayStr.count > 0) {
                        
    //                    NSDictionary *stringDic = [self arrayToJson:arrayStr keyString:array[j]];
    //
    //                    strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                    strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
                        
                        id arrSubStr = arrayStr[0];
                        if ([arrSubStr isKindOfClass:[NSDictionary class]]) {
                            for (NSDictionary *dict in str) {
                                [secretStr appendString:@"{"];
                                [paraStr appendString:@"{"];
                                for (NSString *keyS in dict.allKeys) {
                                    
                                    if([dict[keyS] isKindOfClass:[NSDictionary class]]){
                                        NSDictionary *dict1 = dict[keyS];
                                        [paraStr appendString:[NSString stringWithFormat:@"%@:",keyS]];
                                        [secretStr appendString:[NSString stringWithFormat:@"%@:",keyS]];
                                        [paraStr appendString:@"{"];
                                        [secretStr appendString:@"{"];
                                        for (NSString *keyS1 in dict1) {
                                            
                                            [secretStr appendFormat:@"\"%@\":\"%@\",",keyS1,dict1[keyS1]];
                                            [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS1,dict1[keyS1]];
                                        }
                                        if (paraStr.length > 0) {
                                            [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                                        }
                                        if (secretStr.length > 0) {
                                            [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                                        }
                                        
                                        [secretStr appendString:@"},"];
                                        [paraStr appendString:@"},"];
                                        
                                       
                                        
    //                                    [paraStr appendString:[NSString stringWithFormat:@",\"%@\":\"%@\"",keyS,paraStr]];
    //                                    [secretStr appendString:[NSString stringWithFormat:@"&%@=%@",[NSString stringWithFormat:@",\"%@\":\"%@\"",keyS,paraStr],secretStr]];
                                    }else{
                                        [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,dict[keyS]];
                                        [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS,dict[keyS]];
                                    }
                                    
                                    
                                }
                                if (secretStr.length > 0) {
                                    [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                                }
                                if (paraStr.length > 0) {
                                    [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                                }
    //
    //                            if (secretStr.length > 0) {
    //                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
    //                            }
                                [secretStr appendString:@"},"];
                                [paraStr appendString:@"},"];

                            }

    //                        if (secretStr.length > 0) {
    //                            [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
    //                        }

                            if (secretStr.length > 0) {
                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                            }
                            if (paraStr.length > 0) {
                                [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                            }

                            [secretStr appendString:@"]"];
                            [paraStr appendString:@"]"];

                            str = [KykjImToolkit jsonFromObject:str];

    //                        NSDictionary *stringDic = [self dicToJson:arrSubStr keyString:array[j]];
    //                        strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                        strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
                            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],paraStr]];
                            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],secretStr]];

                        }else{
                            NSMutableString *mstr = [[NSMutableString alloc] init];
                            NSMutableString *sstr = [[NSMutableString alloc] init];
                            [mstr appendString:@"["];
                            for (id obj in str) {
                                if (mstr.length > 1) {
                                    [mstr appendString:@","];
                                }
                                [mstr appendFormat:@"\"%@\"",obj];
                            }
                            [mstr appendString:@"]"];
                            [sstr appendString:@"["];
                            for (id obj in str) {
                                if (sstr.length > 1) {
                                    [sstr appendString:@","];
                                }
                                [sstr appendFormat:@"%@",obj];
                            }
                            [sstr appendString:@"]"];
                            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],mstr]];
                            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],sstr]];
                        }
                    }
                }else if ([str isKindOfClass:[NSDictionary class]]){

                    NSDictionary * dict = str;
                    [paraStr appendString:@"{"];
                    [secretStr appendString:@"{"];
            
                    for (NSString *keyS in dict.allKeys) {
                        [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,dict[keyS]];
                        [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS,dict[keyS]];
                    }


                    if (secretStr.length > 0) {
                        [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                    }
                    if (paraStr.length > 0) {
                        [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                    }
                    [secretStr appendString:@"}"];

                    [paraStr appendString:@"}"];

//                    str = [KYToolKit jsonFromObject:str];

                    strParam = [strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],paraStr]];
                    strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],secretStr]];
                    
    //                NSDictionary *stringDic = [self dicToJson:dict keyString:array[j]];
    //                strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
    //                strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
                }
            }else{
                strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",array[j],str]];
                strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",array[j],str]];
            }
        }
        strSecret= [NSString stringWithFormat:@"%@%@",key,[strSecret substringFromIndex:1]];//加密字符串
        strParam =[NSString stringWithFormat:@"{%@}",[strParam substringFromIndex:1]];//未加密
    }
    

//    NSString *dicJson = [self stringWithDict:tempParams];
    NSString *dicJson;
 
    if([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[tempParams objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"]){
        dicJson = [self stringWithDict:tempParams];
    }else{
        dicJson = strParam;
    }
    NSLog(@"dicJson-----%@",dicJson);
    
//    NSDictionary *tempDic = [StringUtils jsonDataWith:dicJson];
//
//    NSLog(@"tempDic-----%@",dicJson);
    
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    
    [dict setObject:[strSecret MD5Base64String] forKey:@"secret"];
//    [dict setObject:[CWComAndEncry encodeBase64Data:[[strParam dataUsingEncoding:NSUTF8StringEncoding] gzippedData]] forKey:@"param"];
    [dict setObject:[CWComAndEncry encodeBase64Data:[[dicJson dataUsingEncoding:NSUTF8StringEncoding] gzippedData]] forKey:@"param"];
    
    [dict setObject:@"ios" forKey:@"keyId"];
//            CXTLog(@"dict---%@",dict);

    return dict;
}

+ (NSDictionary*)paramSecretJsonWithArray:(NSArray*)paraArray  tempParams:(NSDictionary*)tempParams firstKey:(NSString*)firstKey key:(NSString*)key
{
    id str = paraArray;
    NSString *strParam = @"";
    NSString *strSecret = @"";
    NSMutableString * secretStr = [[NSMutableString alloc] init];
    NSMutableString * paraStr = [[NSMutableString alloc] init];
    [secretStr appendString:@"["];
    [paraStr appendString:@"["];
    NSArray * arrayStr = paraArray;
    
    if (arrayStr.count > 0) {
        
//                    NSDictionary *stringDic = [self arrayToJson:arrayStr keyString:array[j]];
//
//                    strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
//                    strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
        
        id arrSubStr = arrayStr.firstObject;
        if ([arrSubStr isKindOfClass:[NSDictionary class]]) {
            for (int tempi = 0;tempi<arrayStr.count;tempi++) {
                NSDictionary *dict = arrayStr[tempi];
                [secretStr appendString:@"{"];
                [paraStr appendString:@"{"];
                
                
                NSArray *tempArray = dict.allKeys;
                tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                        return[obj1 compare:obj2 options:NSNumericSearch];//正序
                }];
                
                for (int k=0;k<tempArray.count;k++) {
                    NSString *keyS = tempArray[k];
                    if([dict[keyS] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dict1 = dict[keyS];
                        
                        [paraStr appendString:[NSString stringWithFormat:@"%@:",keyS]];
                        
                        [secretStr appendString:[NSString stringWithFormat:@"%@=",keyS]];
                        [paraStr appendString:@"{"];
                        [secretStr appendString:@"{"];
                        
                        
                        NSArray *tempArray1 = dict1.allKeys;
                        tempArray1 = [tempArray1 sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
                                return[obj1 compare:obj2 options:NSNumericSearch];//正序
                        }];
                        
                        for (int j=0;j<tempArray1.count;j++) {
                            NSString *keyS1 = tempArray1[j];
                            NSString *tempStr1 = dict1[keyS1];
                            if (j<tempArray1.count-1) {
                                [secretStr appendFormat:@"\"%@\":\"%@\",",keyS1,getSafeString(dict1[keyS1])];
                            }else{
                                [secretStr appendFormat:@"\"%@\":\"%@\"",keyS1,getSafeString(dict1[keyS1])];
                            }
                            
                            [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS1,tempStr1!=nil ? tempStr1 :@""];
                        }
                        if (paraStr.length > 0) {
                            [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                        }
                        
//                        if([[tempParams objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"])|| [[tempParams objectForKey:@"method"]  isEqualToString:@"addStaffCollect"]){
//                            [secretStr appendString:@"}, "];
//                        }else{
//                            if (secretStr.length > 0) {
//                                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
//                            }
//                            [secretStr appendString:@"}\","];
//                        }
                        [secretStr appendString:@"}, "];
                        [paraStr appendString:@"},"];
                        

                    }
                    else if ([dict[keyS] isKindOfClass:[NSArray class]]){
                        NSDictionary *tempJsonDic = [self paramSecretJsonWithArray:dict[keyS] tempParams:tempParams firstKey:firstKey key:keyS];
                        if([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"]){
                            [secretStr appendFormat:@"%@=%@, ",keyS,[tempJsonDic objectForKey:@"secretStr"]];
                            [paraStr appendString:[tempJsonDic objectForKey:@"paraStr"]];
                        }else{
                            [secretStr appendString:[tempJsonDic objectForKey:@"secretStr"]];
                            [paraStr appendString:[tempJsonDic objectForKey:@"paraStr"]];
                        }
                        
                        
//                        [secretStr appendString:@","];
//                        [paraStr appendString:@","];
                    }
                    else{
                        
                        NSString *string = dict[keyS];
                        
                        if (([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) && ([keyS isEqualToString:@"icStaus"] || [keyS isEqualToString:@"icdCode"] || [keyS isEqualToString:@"illName"])) {
                            if (k==tempArray.count-1) {
                                [secretStr appendFormat:@"\"%@\":\"%@\"",keyS,string!=nil ? string : @""];
                            }else{
                                [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,string!=nil ? string : @""];
                            }
                        }
                        else if([[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"]){
                            if (k==tempArray.count-1) {
                                [secretStr appendFormat:@"\"%@\":\"%@\"",keyS,string!=nil ? string : @""];
                            }else{
                                [secretStr appendFormat:@"\"%@\":\"%@\",",keyS,string!=nil ? string : @""];
                            }
                        }
                        else{
                            if (k==tempArray.count-1) {
                                [secretStr appendFormat:@"%@=%@",keyS,string!=nil ? string : @""];
                            }else{
                                [secretStr appendFormat:@"%@=%@, ",keyS,string!=nil ? string : @""];
                            }
                        }
                        
                        
                        
                        [paraStr appendFormat:@"\\\"%@\\\":\\\"%@\\\",",keyS,dict[keyS]];
                    }
                    
                    
                }
                if(!(([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[tempParams objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"addSpPlan"] || [[tempParams objectForKey:@"method"] isEqualToString:@"updateSpPlan"])){
                    
                    if (secretStr.length > 0) {
                        [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                    }
                }
                
                
                if (paraStr.length > 0) {
                    [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
                }

                if(([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) && ![key isEqualToString:@"icdVal"]){

                    [secretStr appendString:@"}, "];
                }
                else if([[tempParams objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"]){
                    [secretStr appendString:@"}, "];
                }
                else{
                    [secretStr appendString:@"},"];
                }
//                [secretStr appendString:@"},"];
                [paraStr appendString:@"},"];

            }

//                        if (secretStr.length > 0) {
//                            [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
//                        }

            if (secretStr.length > 0) {
                [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
            }
            if (paraStr.length > 0) {
                [paraStr deleteCharactersInRange:NSMakeRange(paraStr.length-1,1)];
            }
            
            if(([[tempParams objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[tempParams objectForKey:@"dType"] isEqualToString:@"PRES"]) && ![key isEqualToString:@"icdVal"]){
                
                if (secretStr.length > 0) {
                    [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                }
            }
            if([[tempParams objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[tempParams objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"]){
                if (secretStr.length > 0) {
                    [secretStr deleteCharactersInRange:NSMakeRange(secretStr.length-1,1)];
                }
            }
            
            
            [secretStr appendString:@"]"];
            [paraStr appendString:@"]"];

            str = [KykjImToolkit jsonFromObject:str];

//                        NSDictionary *stringDic = [self dicToJson:arrSubStr keyString:array[j]];
//                        strParam = [strParam stringByAppendingString:[stringDic objectForKey:@"paraStr"]];
//                        strSecret=[strSecret stringByAppendingString:[stringDic objectForKey:@"secretStr"]];
            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":\"%@\"",key,paraStr]];
            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,secretStr.length>0 ? secretStr : @""]];

        }else{
            NSMutableString *mstr = [[NSMutableString alloc] init];
            NSMutableString *sstr = [[NSMutableString alloc] init];
            [mstr appendString:@"["];
            for (id obj in str) {
                if (mstr.length > 1) {
                    [mstr appendString:@","];
                }
                [mstr appendFormat:@"\"%@\"",obj];
            }
            [mstr appendString:@"]"];
            [sstr appendString:@"["];
            for (id obj in str) {
                if (sstr.length > 1) {
                    [sstr appendString:@","];
                }
                if ([[tempParams objectForKey:@"method"] isEqualToString:@"addHlRecord"]) {
                    [sstr appendFormat:@"\"%@\"",obj];
                }else{
                    [sstr appendFormat:@"%@",obj];
                }
//                [sstr appendFormat:@"%@",obj];
//                [sstr appendString:obj];
            }
            [sstr appendString:@"]"];
            strParam=[strParam stringByAppendingString:[NSString stringWithFormat:@",\"%@\":%@",key,mstr]];
            strSecret=[strSecret stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,sstr.length>0 ? sstr : @""]];
            
            paraStr = mstr;
            secretStr = sstr;
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:secretStr,@"secretStr",paraStr,@"paraStr", nil];
    return dic;
}

+ (NSString*)stringWithDict:(NSDictionary*)dict
{
    NSString*str =@"";

    BOOL addRecordPIC = NO;
    if ([[dict objectForKey:@"method"] isEqualToString:@"addHlRecord"]) {
        NSDictionary *tempDic = [dict objectForKey:@"body"];
        if ([[tempDic objectForKey:@"rcType"] isEqualToString:@"37"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"38"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"40"]) {
            addRecordPIC = YES;
        }
    }
    
    if ([[dict objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[dict objectForKey:@"method"] isEqualToString:@"updatePresInfo"] || ([[dict objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[dict objectForKey:@"dType"] isEqualToString:@"PRES"]) || [[dict objectForKey:@"method"] isEqualToString:@"addSpPlan"] || [[dict objectForKey:@"method"] isEqualToString:@"updateSpPlan"] || addRecordPIC || [[dict objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[dict objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"]) {

        str = [self jsonStringWithDict:dict ascend:@"YES" firstDict:dict isFirst:YES];

    }else{
        NSArray *array = [self getJSONStringFromObj:dict isFirst:YES];
        str = [array componentsJoinedByString:@","];
    }
    
    NSLog(@"str:%@",str);
    return str;
}
/// 按照字典的key排序，返回json的数据格式
/// @param dict 要转换成
/// @param asc @"YES" 代表升序，@"NO" 降序
+(NSString*)jsonStringWithDict:(NSDictionary*)dict ascend:(NSString *)asc firstDict:(NSDictionary*)firstDict isFirst:(BOOL)isFirst{
    NSArray*keys = [dict allKeys];
    if (keys.count==0) {
        return nil;
    }
    
    int flag=0;// 在拼接json的时候判断是不是字典来判断是不要双引号
    NSArray*sortedArray;
    NSString*str =@"{";// 拼接json的转换的结果
    
    // 自定义比较器来比较key的ASCII码
    sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];//升序排序
    }];
    
    // 逐个取出key和value，然后拼接json
    for (int i=0; i<sortedArray.count; i++) {
        
        NSString *categoryId;
        
        if ([asc isEqualToString:@"YES"]) {// 升序排序
            categoryId = sortedArray[i];
        }else{ // 降序排序
            categoryId = sortedArray[sortedArray.count-1-i];
        }
        id value = [dict objectForKey:categoryId];
        
        if([value isKindOfClass:[NSDictionary class]]) {
            flag=1;
            value = [self jsonStringWithDict:value ascend:asc firstDict:firstDict isFirst:NO];
        }
        
       //  拼接json串的分割符
        if([str length] !=2 && i>0) {
            str = [str stringByAppendingString:@","];
        }
        // 对数组类型展开处理
        if([value isKindOfClass:[NSArray class]]){
            if([categoryId isEqualToString:@"icdVal"] || [categoryId isEqualToString:@"evalUrl"] || [categoryId isEqualToString:@"poisonousImgs"]){
                str = [str stringByAppendingFormat:@"\"%@\":\"[",categoryId];
                str = [self sortInner:value jsonString:str categoryId:categoryId firstDict:firstDict];
                NSLog(@"===value icdVal:%@",str);
            }
            //处方
            else if([categoryId isEqualToString:@"drugList"]){
                str = [str stringByAppendingFormat:@"\"%@\":[",categoryId];
                str = [self sortInner:value jsonString:str categoryId:categoryId firstDict:firstDict];
            }
            //随访计划
            else if([categoryId isEqualToString:@"taskItemDatas"]){
                str = [str stringByAppendingFormat:@"\"%@\":\"[",categoryId];
                str = [self sortInner:value jsonString:str categoryId:categoryId firstDict:firstDict];
            }
            //
            else if(([[firstDict objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"])&&([categoryId isEqualToString:@"diagnose"])){
                str = [str stringByAppendingFormat:@"\"%@\":[",categoryId];
                str = [self sortInner:value jsonString:str categoryId:categoryId firstDict:firstDict];
            }
            else{
                str = [str stringByAppendingFormat:@"\"%@\":[",categoryId];
                str = [self sortInner:value jsonString:str categoryId:@"" firstDict:firstDict];
            }
            
            
            // 因为在 处理完数组类型后，json已经拼接好，直接拼接下一个串
            continue;
        }
        
        if (flag==1) {
            BOOL addRecordPIC = NO;
            if ([[firstDict objectForKey:@"method"] isEqualToString:@"addHlRecord"]) {
                NSDictionary *tempDic = [firstDict objectForKey:@"body"];
                if ([[tempDic objectForKey:@"rcType"] isEqualToString:@"37"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"38"] || [[tempDic objectForKey:@"rcType"] isEqualToString:@"40"]) {
                    addRecordPIC = YES;
                }
            }
            
            if((([[firstDict objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[firstDict objectForKey:@"dType"] isEqualToString:@"PRES"]) && [categoryId isEqualToString:@"pres"])){
                str = [str stringByAppendingFormat:@"\"%@\":%@",categoryId,value];
            }
            else if(addRecordPIC && [categoryId isEqualToString:@"body"]){
                str = [str stringByAppendingFormat:@"\"%@\":%@",categoryId,value];
            }
            else if(([[firstDict objectForKey:@"method"] isEqualToString:@"getPrescriptionYwqUniqueId"] || [[firstDict objectForKey:@"method"] isEqualToString:@"getGdTjIdYwqUniqueId"])&&([categoryId isEqualToString:@"body"])){
                str = [str stringByAppendingFormat:@"\"%@\":%@",categoryId,value];
            }
            else{
                str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",categoryId,value];
            }
            
            flag=0;
        }else{
            if(![value isKindOfClass:[NSString class]]){// 如果是number类型，value不需要加双引号
                // 如果是BOOl类型则转化为false和true
                Class c = [value class];
                NSString * s = [NSString stringWithFormat:@"%@", c];
                if([s isEqualToString:@"__NSCFBoolean"]){
                    
                    if ([value isEqualToNumber:@YES]) {
                        str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",categoryId,@"true"];
                        
                    }else{
                        str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",categoryId,@"false"];
                    }
                }else{
                    //处方
                    if (([[firstDict objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[firstDict objectForKey:@"method"] isEqualToString:@"updatePresInfo"]) && (([categoryId isEqualToString:@"icdCode"] || [categoryId isEqualToString:@"illName"] || [categoryId isEqualToString:@"icStaus"] || [categoryId isEqualToString:@"desc"] || [categoryId isEqualToString:@"rate"] || [categoryId isEqualToString:@"unit"]))) {
                        str = [str stringByAppendingFormat:@"\\\"%@\\\":\\\"%@\\\"",categoryId,value];
                    }
                    //处方模版
                    else if(([[firstDict objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[firstDict objectForKey:@"dType"] isEqualToString:@"PRES"]) && (([categoryId isEqualToString:@"icdCode"] || [categoryId isEqualToString:@"illName"] || [categoryId isEqualToString:@"icStaus"] || [categoryId isEqualToString:@"desc"] || [categoryId isEqualToString:@"rate"] || [categoryId isEqualToString:@"unit"] || [categoryId isEqualToString:@"title"] || [categoryId isEqualToString:@"des"]))){
                        str = [str stringByAppendingFormat:@"\\\"%@\\\":\\\"%@\\\"",categoryId,value];
                    }
                    else{
                        str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",categoryId,value];
                    }
                    
                }
            }else{
                if (([[firstDict objectForKey:@"method"] isEqualToString:@"addPresInfo"] || [[firstDict objectForKey:@"method"] isEqualToString:@"updatePresInfo"]) && (([categoryId isEqualToString:@"icdCode"] || [categoryId isEqualToString:@"illName"] || [categoryId isEqualToString:@"icStaus"] || [categoryId isEqualToString:@"desc"] || [categoryId isEqualToString:@"rate"] || [categoryId isEqualToString:@"unit"]))) {
                    str = [str stringByAppendingFormat:@"\\\"%@\\\":\\\"%@\\\"",categoryId,value];
                }
                else if(([[firstDict objectForKey:@"method"] isEqualToString:@"addSpPlan"] || [[firstDict objectForKey:@"method"] isEqualToString:@"updateSpPlan"]) && !isFirst && ![categoryId isEqualToString:@"taskTimeLen"]){
                    str = [str stringByAppendingFormat:@"\\\"%@\\\":\\\"%@\\\"",categoryId,value];
                }
                else if(([[firstDict objectForKey:@"method"] isEqualToString:@"addOftenUse"] && [[firstDict objectForKey:@"dType"] isEqualToString:@"PRES"]) && (([categoryId isEqualToString:@"icdCode"] || [categoryId isEqualToString:@"illName"] || [categoryId isEqualToString:@"icStaus"] || [categoryId isEqualToString:@"desc"] || [categoryId isEqualToString:@"rate"] || [categoryId isEqualToString:@"unit"] || [categoryId isEqualToString:@"title"] || [categoryId isEqualToString:@"des"]))){
                    str = [str stringByAppendingFormat:@"\\\"%@\\\":\\\"%@\\\"",categoryId,value];
                }
                else{
                    str = [str stringByAppendingFormat:@"\"%@\":\"%@\"",categoryId,value];
                }
            }
        }
    }
    str = [str stringByAppendingString:@"}"];
    NSLog(@"result json = %@", str);
    return str;
}

+(NSArray *)getJSONStringFromObj:(id)obj isFirst:(BOOL)isFirst {
    NSLog(@"%@",[[obj class] description]);
    
    NSMutableArray *array = [NSMutableArray array];
         
//        NSString *jsonString=nil;
//        jsonString=[writer stringWithObject:jsonDictionary];
    
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *mt_array = [NSMutableArray array];
        NSArray *t_array = (NSArray *)obj;
        for (id t_obj in t_array) {
            if ([t_obj isKindOfClass:[NSString class]]) {
                [mt_array addObject:(NSString *)t_obj];
//                [array addObject:(NSString *)t_obj];
            } else {
                NSArray *jsonArray = [self getJSONStringFromObj:t_obj isFirst:NO];
                NSString *jsonStr = [jsonArray componentsJoinedByString:@","];
                [mt_array addObject:jsonStr];
//                [array addObject:jsonStr];
            }
        }
//        return [json stringWithObject:mt_array];
        [array addObject:[NSString stringWithFormat:@"[%@]",[mt_array componentsJoinedByString:@","]]];
        return array;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *t_dict = (NSDictionary *)obj;
        NSMutableDictionary *mt_dict = [NSMutableDictionary dictionary];
        NSArray *keys = [t_dict allKeys];
        keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result=[obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
      
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i=0;i<keys.count;i++) {
            NSString *key = keys[i];
            id t_obj = [t_dict objectForKey:key];
            if ([t_obj isKindOfClass:[NSString class]] || [t_obj isKindOfClass:[NSNumber class]]) {
                [mt_dict setObject:t_obj forKey:key];
                if (isFirst) {
                    [tempArray addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",key,t_obj]];
                }else{
                    [tempArray addObject:[NSString stringWithFormat:@"\\\"%@\\\":\\\"%@\\\"",key,t_obj]];
                }
                
            } else {
                NSArray *jsonArray = [self getJSONStringFromObj:t_obj isFirst:NO];
                NSString *jsonStr = [jsonArray componentsJoinedByString:@","];
                
                [mt_dict setObject:jsonStr forKey:key];
                if (isFirst){
                    [tempArray addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",key,jsonStr]];
                }else{
                    [tempArray addObject:[NSString stringWithFormat:@"\\\"%@\\\":\\\"%@\\\"",key,jsonStr]];
                }
                
            }
            if (i == keys.count-1) {
                [array addObject:[NSString stringWithFormat:@"{%@}",[tempArray componentsJoinedByString:@","]]];
            }
        }
       
        return array;
//        return [json stringWithObject:mt_dict];
    } else if ([obj isKindOfClass:[NSString class]]) {
        [array addObject:obj];
        return array;
//        return obj;
    } else {
        return nil;
//        return [[obj class] description];
    }
}
+(NSString *) sortInner:(NSArray *) array jsonString:(NSString *)json categoryId:(NSString*)categoryId firstDict:(NSDictionary*)firstDict{
    NSString *string =@"";
    NSInteger location = 0;
    for (int i=0; i< array.count; i++) {
        
        if(i!=0&&i< array.count) {
            if([categoryId isEqualToString:@"icdVal"]){
                json = [json stringByAppendingString:@","];
            }else{
//                json = [json stringByAppendingString:@",\""];
                json = [json stringByAppendingString:@","];
            }
//
            
        }
        
        id arr = [array objectAtIndex:i];
        if([arr isKindOfClass:[NSDictionary class]]){// 如果数组里包含字典，则对该字典递归排序
            location = i;
            string=[self jsonStringWithDict:arr ascend:@"YES" firstDict:firstDict isFirst:NO];
            json = [json stringByAppendingFormat:@"%@",string];
        }else{
            if([arr isKindOfClass:[NSString class]]){
//                if([[firstDict objectForKey:@"method"] isEqualToString:@"addHlRecord"]){
//                    json = [json stringByAppendingFormat:@"\"%@\"",arr];
//                }else{
                    json = [json stringByAppendingFormat:@"\\\"%@\\\"",arr];
//                }
                
            }else{
                // 如果是BOOl类型则转化为false和true
                Class c = [arr class];
                NSString * s = [NSString stringWithFormat:@"%@", c];
                if([s isEqualToString:@"__NSCFBoolean"]){
                    
                    if ([arr isEqualToNumber:@YES]) {
                        json = [json stringByAppendingFormat:@"%@",@"true"];
                        
                    }else{
                        json = [json stringByAppendingFormat:@"%@",@"false"];
                    }
                }else{
                    json = [json stringByAppendingFormat:@"%@",arr];
                }
                
            }
        }
    }
    if([categoryId isEqualToString:@"icdVal"] || [categoryId isEqualToString:@"evalUrl"] || [categoryId isEqualToString:@"poisonousImgs"] || [categoryId isEqualToString:@"taskItemDatas"]){
        json = [json stringByAppendingString:@"]\""];
    }else{
        json = [json stringByAppendingString:@"]"];
    }
    
    return json;
}

+ (NSDictionary *)md5ParamsWith:(NSDictionary *)params{
    return [StringUtils md5ParamsWith:params needEncryption:YES];
}

+ (NSDictionary *)JsonDataWithmd5BaseData:(NSDictionary *)data{
    NSString *strTemp=  [NSString stringWithFormat:@"%@",[data objectForKey:@"data"]];
    
    NSData *gData=[CWComAndEncry dataWithBase64EncodedString:strTemp];//base64解译
    
    NSString *strData=[[NSString alloc] initWithData:[gData gunzippedData] encoding:NSUTF8StringEncoding];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[strData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    return dic;
}


@end
