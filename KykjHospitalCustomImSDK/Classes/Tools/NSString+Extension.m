//
//  NSString+Extension.m
//
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "NSString+Extension.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
//#import "RSA.h"

//加密 公钥
#define publicKeyStr @"-----BEGIN PUBLIC KEY-----\nMIIBnTANBgkqhkiG9w0BAQEFAAOCAYoAMIIBhQKCAXwJv1sKUw/hnUHxgNhoiJTMHGLge7dC7SdA+oEyccPenIexAyyEStiohKK/TWTSzp65DQjV2kiiSd538D+wNK93LsP0lYzaiLI8s2/XRfyoFc4wZPs0FtnaH4kH3BABjhxtoGX1VOgAv91cYZSoH6RWUaLHEJrvK1DiD9G/BxK+3jKDszjAqaksS023QLCIgh15pmXG5zg/Nlsm8W/IMLGyaXGBbt5cmnvLkcjbG7dEhxCgakkpfgIchm0JbUfU0ILLvS59IbjFCKjjeXNg99fXKV9JYS+4tAnIrGxT55rBHIg6GdvBB78iIPLHSiZ9o/Hf+6AN/DQtQIdt7Ixh4TcD5Rz9Jt8JPD/j1yAwMwtSQr+zwgLA5ut+XHVuP0QOV7bRUeF9jJj8iZDVvq2sKw0LuqV03UdUSPsNKKqMVQGv1RKQtTZ+zmdfWrHGA31nsPJXvbXrsP77lX6koEWOeWHkEieVCsCfNKHSNrWqmPXFoqr1jsf1Uh7ZEYMNEQIDAQAB\n-----END PUBLIC KEY-----"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW maxH:(CGFloat)maxH
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, maxH);
    CGSize rectSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
    return CGSizeMake(rectSize.width, ceil(rectSize.height));
    
}

- (CGSize)sizeWithFontMaxWidthAndHeight:(UIFont *)font
{
//    return [self sizeWithFont:font maxW:MAXFLOAT];
    return [self sizeWithFont:font maxW:MAXFLOAT maxH:MAXFLOAT];
}

// Get IP Address
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}



///**
// 
// *GTM 转码
// 
// */
//
//+(NSString *)GTMEncode:(NSString *)originStr
//{
//    NSString* encodeResult = nil;
//    NSData* originData = [originStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* encodeData = [GTMBase64 encodeData:originData];
//    encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
////    CXTLog(@"%@",encodeResult);
//    return encodeResult;
//    
//}
//
//
///**
// 
// * GTM 解码
// 
// */
//
//+(NSString *)GTMDecode:(NSString *)encodeStr
//{
//    NSString* decodeResult = nil;
//    NSData* encodeData = [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSData* decodeData = [GTMBase64 decodeData:encodeData];
//    decodeResult = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
////    CXTLog(@"%@",decodeResult);
//    return decodeResult;
//    
//}
//
///**
// *  RAS加密
// */
//+ (NSString *)RSAEncode:(NSString *)originStr
//{
//    NSString *tempStr=[RSA encryptString:originStr publicKey:publicKeyStr];
//    NSString *dataStr=[NSString stringWithFormat:@"data=robot_ios%@",tempStr];
//    return dataStr;
//    
//}

/**
 *  获取html代码内部的纯文本
 */
+ (NSString *)getHtmlText:(NSString *)content
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@""];//替换所有html和换行匹配元素为""
    NSLog(@"--content--开始:%@", content);
    return content;
}

/**
 *  获取html代码内部的纯文本数组
 */
+ (NSMutableArray *)getHtmlTextArray:(NSString *)content
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
        regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
        content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    content=[NSString stringWithString:content];
    arr =  [content componentsSeparatedByString:@"-"];
    
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    return  marr;
}

/*
 *测试字符串
 */
- (BOOL)matchWithGoalStr:(NSString *)goalStr pattern:(NSString *)pattern
{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results=[regularExpretion matchesInString:goalStr options:NSMatchingAnchored range:NSMakeRange(0, goalStr.length)];
    return (results.count>0);
}

//MARK:判断中文姓名
- (BOOL)isChineseCharacter
{
    return [self matchWithGoalStr:self pattern:@"^[\u4e00-\u9fa5]{2,4}$"];
}


+ (NSString *)transferStringFromFloat:(double)aFloatNum
{
    NSString *desStr=nil;
    if (aFloatNum>0.0)
    {
        CGFloat fenshuFloat=aFloatNum-(long)aFloatNum;
        NSInteger fenshuInt=(int)(fenshuFloat*100);
        NSString *fenshuStr = fenshuInt>0 ? [NSString stringWithFormat:@"%ld",(long)fenshuInt] : @"00";
        
        if (aFloatNum>1000000) {
            long baiwanNum=(long)aFloatNum/1000000;
            long qianNum=((long)aFloatNum-baiwanNum*1000000)/1000;
            long geNum=(long)aFloatNum%1000;
            
            desStr=[NSString stringWithFormat:@"%ld,%ld,%ld.%@",(long)baiwanNum,(long)qianNum,geNum,fenshuStr];
        }else if (aFloatNum>1000)
        {
            long qianNum=(long)aFloatNum/1000;
            long geNum=(long)aFloatNum%1000;
            desStr=[NSString stringWithFormat:@"%ld,%ld.%@",(long)qianNum,geNum,fenshuStr];
        }else
        {
            long geNum=(long)aFloatNum%1000;
            desStr=[NSString stringWithFormat:@"%ld.%@",geNum,fenshuStr];
            
        }
        return desStr;
    }
    else
    {
        return @"0.00";
    }
}


/**
 *  根据时间设置文件名
 *
 */
+ (NSString *)setFileNameFromTime
{
    // 设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    return fileName;
}


+ (NSString *)getNameFromTime
{
    // 设置时间格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = str;
    return fileName;
}


//计算时间,把秒数转为  天 时 分 秒 格式,比如1天23时3分5秒,数字和 天的颜色一致
+ (NSString *)calculateTimeWithEndtime:(long long)endtime
{
    
    NSInteger dayCount=(int)endtime/86400;
    NSInteger hourCount=(int)(endtime-86400*dayCount)/3600;
    NSInteger minuteCount=(int)(endtime-86400*dayCount-hourCount*3600)/60;
    NSInteger secondCount=(int)(endtime-86400*dayCount-hourCount*3600-minuteCount*60);
    
    //    CXTLog(@"-%ld天-%ld时-%ld分-%ld秒-", (long)dayCount,(long)hourCount,(long)minuteCount,(long)secondCount);
    NSString *timeStr=[NSString stringWithFormat:@"%ld天%ld时%ld分%ld秒",(long)dayCount,(long)hourCount,(long)minuteCount,(long)secondCount];
    if (dayCount==0) {
        timeStr=[NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hourCount,(long)minuteCount,(long)secondCount];
        
        if (hourCount==0) {
            timeStr=[NSString stringWithFormat:@"%ld分%ld秒",(long)minuteCount,(long)secondCount];
            if (secondCount==0) {
                timeStr=[NSString stringWithFormat:@"%ld秒",(long)secondCount];
                
            }
        }
        
    }
    return timeStr;
}


+(BOOL)isUrl:(NSString *)soureStr
{
    BOOL result = ([soureStr containsString:@"http://"] || [soureStr containsString:@"https://"]);
    return result;
}

+ (BOOL)isAllNum:(NSString *)string{
    if (string == nil || string.length == 0) {
        return NO;
    }
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isPhoneNumber
{
        // 1.全部是数字
        // 2.11位
        // 3.以13\15\18\17开头
    return [self match:@"^1[123456789]\\d{9}$"];
        // JavaScript的正则表达式:\^1[3578]\\d{9}$\
    
}


- (BOOL)match:(NSString *)pattern
{
    // 1.创建正则表达式
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 2.测试字符串
    NSArray *results = [regex matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

//- (BOOL)isQQ
//{
//    // 1.不能以0开头
//    // 2.全部是数字
//    // 3.5-11位
//    return [self match:@"^[1-9]\\d{4,10}$"];
//}
//
//- (BOOL)isPhoneNumber
//{
//    // 1.全部是数字
//    // 2.11位
//    // 3.以13\15\18\17开头
//    return [self match:@"^1[3578]\\d{9}$"];
//    // JavaScript的正则表达式:\^1[3578]\\d{9}$\
//    
//}
//
//- (BOOL)isIPAddress
//{
//    // 1-3个数字: 0-255
//    // 1-3个数字.1-3个数字.1-3个数字.1-3个数字
//    return [self match:@"^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$"];
//}

//- (BOOL)isChineseCharacter
//{
//    return [self match:@"^[\u4e00-\u9fa5]\\d{2,4}$"];
//}

//- (BOOL)isPhoneNumber
//{
////    NSString *email ＝ @“nijino_saki@163.com”；
//    NSString *regex = @"^1[3578]\\d{9}$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isValid = [predicate evaluateWithObject:self];
//    return isValid;
//    
//}

/**
 *@brief 随机数生成
 *@param index 随机数位数
 */
+(NSString *)createRandom:(NSInteger)index{
    NSString *strRandom=@"";
    for (int i=0; i<index; i++) {
        strRandom= [strRandom stringByAppendingString:[NSString stringWithFormat:@"%u",arc4random()%10]];
    }
    NSLog(@"---^%@",strRandom);
    return strRandom;
}

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString
{
        // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
        // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString
{
        //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = self;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

@end
