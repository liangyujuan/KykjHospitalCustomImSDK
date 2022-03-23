//
//  NSString+Extension.h
//  
//
//  Created by apple on 14-10-18.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW maxH:(CGFloat)maxH;
- (CGSize)sizeWithFontMaxWidthAndHeight:(UIFont *)font;
//获取ip
+ (NSString *)getIPAddress;
//GTM 转码
//+(NSString *)GTMEncode:(NSString *)originStr;
////GTM 解码
//+(NSString *)GTMDecode:(NSString *)encodeStr;
//



//+ (NSString *)RSAEncode:(NSString *)originStr;
/**
 *  获取html代码内部的纯文本
 */
+ (NSString *)getHtmlText:(NSString *)content;
/**
 *  获取html代码内部的纯文本数组
 */
+ (NSMutableArray *)getHtmlTextArray:(NSString *)content;

/**
 *  千分化一个数字
 *
 */
+ (NSString *)transferStringFromFloat:(double)aFloatNum;


/**
 *  根据时间设置文件名
 *
 */
+ (NSString *)setFileNameFromTime;


+ (NSString *)getNameFromTime;

/**
 *  判断中文姓名
 */
- (BOOL)isChineseCharacter;


//计算时间,把秒数转为  天 时 分 秒 格式,比如1天23时3分5秒,数字和 天的颜色一致
+ (NSString *)calculateTimeWithEndtime:(long long)endtime;

//- (BOOL)isQQ;
//- (BOOL)isPhoneNumber;
//- (BOOL)isIPAddress;
////汉字
//- (BOOL)isChineseCharacter;

+(BOOL)isUrl:(NSString *)soureStr;

- (BOOL)isPhoneNumber;

+ (BOOL)isAllNum:(NSString *)string;

/**
 *@brief 随机数生成
 *@param index 随机数位数
 */
+(NSString *)createRandom:(NSInteger)index;

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;
/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;
@end
