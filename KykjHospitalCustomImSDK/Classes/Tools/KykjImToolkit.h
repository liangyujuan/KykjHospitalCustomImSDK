//
//  KykjImToolkit.h
//  KykjHospitalCustomImSDK
//
//  Created by 梁玉娟 on 2022/2/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AuthorizationStatusCallBack)(void);

@interface KykjImToolkit : NSObject

//根据身份证号获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr;
//根据身份证号获取生日
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr;

/**
 验证是否为空

 @param string 文本内容
 @return YES/NO
 */
+ (BOOL)isStringBlank:(NSString *)string;

/**
 obj转json
 */
+(NSString *)jsonFromObject:(NSObject*)obj;
/**
json转字典
*/
+ (NSDictionary *)dictionaryWithJson:(NSString *)jsonString;

/**
json转数组
*/
+ (NSArray *)arrayWithJson:(NSString *)jsonString;

/*
 获取当前控制器
 */
+ (UIViewController *)getCurrentVC;

/**
 验证手机号 1开头 11位数字

 @param telephone 手机号码
 @return YES/NO
 */
+ (BOOL)checkTelephone:(NSString *)telephone;

/**
 检测相册权限
 
 @param callback 允许授权callback
 */
+ (void)checkMustLibraryAuthorityWithCallBack:(AuthorizationStatusCallBack)callback;

+ (void)checkLibraryAuthorityWithCallBack:(AuthorizationStatusCallBack)callback;
/**
 检测相机权限

 @param callback 允许授权callback
 */
+ (void)checkVideoAuthorityWithCallBack:(AuthorizationStatusCallBack)callback;


/**
  检测麦克风权限

 @param callback 允许授权callback
 */
+ (void)checkMicroAuthorityWithCallBack:(AuthorizationStatusCallBack)callback;

/**
  检测麦克风权限

 */


+ (NSString *)getUniqueStrByUUID;


+ (UIImage *)getImageResourceForName:(NSString *)name;

//根据内容和font获取字符串像素长度
+ (float) getStringSize:(NSString*)str withFont:(UIFont*)font;
//根据内容和font获取字符串像素高度
+ (float) getStringSizeHeight:(NSString*)str withFont:(UIFont*)font Andwidht:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
