//
//  KykjImToolkit.m
//  KykjHospitalCustomImSDK
//
//  Created by 梁玉娟 on 2022/2/23.
//

#import "KykjImToolkit.h"
#import "NSDate+Extension.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVCaptureDevice.h>
//#import "Factory.h"
#import "MJExtension.h"
#import "StringUtils.h"

@implementation KykjImToolkit


//根据省份证号获取年龄
+(NSString *)getIdentityCardAge:(NSString *)numberStr
{
if (getSafeString(numberStr).length == 0){
    return @"";
}
NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
[formatterTow setDateFormat:@"yyyy-MM-dd"];
NSDate *bsyDate = [formatterTow dateFromString:[[self class] birthdayStrFromIdentityCard:numberStr]];
NSDate * dateNow = [NSDate date];


NSInteger bsyYear = bsyDate.year;
NSInteger bsyMonth = bsyDate.month;
NSInteger bsyDay = bsyDate.day;
NSInteger nowYear = dateNow.year;
NSInteger nowMonth = dateNow.month;
NSInteger nowDay = dateNow.day;

NSInteger age =nowYear-bsyYear;
if (bsyMonth == nowMonth) {
    if (bsyDay > nowDay) {
        age--;
    }
}else if (bsyMonth > nowMonth){
    age--;
}
age = MAX(0, age);
return [NSString stringWithFormat:@"%ld",(long)age];
}

//根据身份证号获取生日
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
NSMutableString *result = [NSMutableString stringWithCapacity:0];
NSString *year = nil;
NSString *month = nil;

BOOL isAllNumber = YES;
NSString *day = nil;
if([numberStr length]<14)
    return result;

    //**截取前14位
NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];

    //**检测前14位否全都是数字;
const char *str = [fontNumer UTF8String];
const char *p = str;
while (*p!='\0') {
    if(!(*p>='0'&&*p<='9'))
        isAllNumber = NO;
    p++;
}
if(!isAllNumber)
    return result;

year = [numberStr substringWithRange:NSMakeRange(6, 4)];
month = [numberStr substringWithRange:NSMakeRange(10, 2)];
day = [numberStr substringWithRange:NSMakeRange(12,2)];

[result appendString:year];
[result appendString:@"-"];
[result appendString:month];
[result appendString:@"-"];
[result appendString:day];
return result;
}

+ (BOOL)isStringBlank:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    else if ([string isEqual:@"<null>"] || [string isMemberOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (string.length == 0)
    {
        return YES;
    }
    else
    {
        NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (str.length == 0)
        {
            return YES;
        }
    }
    return NO;
}
+ (NSString *)jsonFromObject:(NSObject*)obj
{
    return [obj mj_JSONString];
    
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString;
        if (!jsonData) {
            NSLog(@"%@",error);
        }else{
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
        NSRange range = {0,jsonString.length};
        //去掉字符串中的空格
        [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
        NSRange range2 = {0,mutStr.length};
//        //去掉字符串中的换行符
        [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSString *str = [NSString stringWithFormat:@"%@",mutStr];
    return str;
            
        }
               
    return nil;
  
}
+ (NSDictionary *)dictionaryWithJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+ (NSArray *)arrayWithJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    
    while (1) {
        
        if ([vc isKindOfClass:[UITabBarController class]]) {
            
            vc = ((UITabBarController*)vc).selectedViewController;
            
        }
        
        
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            
            vc = ((UINavigationController*)vc).visibleViewController;
            
        }
        
        
        
        if (vc.presentedViewController) {
            
            vc = vc.presentedViewController;
            
        }else{
            
            break;
            
        }
    }
    return vc;
}

+ (BOOL)checkTelephone:(NSString *)telephone
{
    NSString *pattern = @"^1+[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telephone];
    return isMatch;
}

+ (void)checkLibraryAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status)
        {
            case PHAuthorizationStatusNotDetermined: break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启相册权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:set];
                    [alert addAction:cancel];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                });
            }
                break;
            case PHAuthorizationStatusAuthorized:
            {
                if (callback)
                {
                    callback();
                }
            }
                break;
        }
    }];
}
+ (void)checkVideoAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted)
                {
                    if (callback)
                    {
                        callback();
                    }
                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启相机权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:set];
                [alert addAction:cancel];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            });
            
            
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (callback)
            {
                callback();
            }
        }
            break;
    }
}

+ (void)checkMicroAuthorityWithCallBack:(AuthorizationStatusCallBack)callback
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status)
    {
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                //                if (granted)
                //                {
                //                    if (callback)
                //                    {
                //                        callback();
                //                    }
                //                }
            }];
        }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"权限受限" message:@"当前操作需要开启麦克风权限，请到设置页面开启" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *set = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:set];
                [alert addAction:cancel];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            });
            
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (callback)
            {
                callback();
            }
        }
            break;
    }
}

+ (NSString *)getUniqueStrByUUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef= CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *retStr = [NSString stringWithString:(__bridge NSString *)uuidStrRef];
    CFRelease(uuidStrRef);
    return retStr;
}

+ (UIImage *)getImageResourceForName:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK.bundle" ofType:nil];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
