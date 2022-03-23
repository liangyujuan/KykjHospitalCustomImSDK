//
//  HttpOperationManager.m
//  HealthXilan
//
//  Created by adtech on 16/3/11.
//  Copyright © 2016年 adtech. All rights reserved.
//

#import "HttpOperationManager.h"
//#import "StringUtils.h"

#define CWBaseURLString @"https://hospital.tianyucare.com/ystapp/"//生产

#define serverHttpImageBase_URL @"https://hospital.tianyucare.com"

@implementation HttpOperationManager
+ (instancetype)httpManager {
    static HttpOperationManager *_httpManager= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpManager = [[HttpOperationManager alloc] initWithBaseURL:[NSURL URLWithString:CWBaseURLString]];
    });
    
    return _httpManager;
}

    //http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
                      showAlert:(BOOL)show
                   showProgress:(BOOL)showProgress
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{

    [HttpOperationManager HTTP_POSTWithParameters:parameters showAlert:show showLog:YES success:success failure:failure];
}

//http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
        showAlert:(BOOL)show
          showLog:(BOOL)showLog
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    
    [HttpOperationManager HTTP_POSTWithParameters:parameters showAlert:show showLog:showLog needEncryption:YES success:success failure:failure];
}

//http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
        showAlert:(BOOL)show
          success:(void (^)(id responseObject))success
          failure:(void (^)(NSError *error))failure
{
    
    [HttpOperationManager HTTP_POSTWithParameters:parameters showAlert:show showProgress:NO success:success failure:failure];
}

//http POST
+ (void)HTTP_GetWithUrl:(id)url
              showAlert:(BOOL)show
                showLog:(BOOL)showLog
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure{
    NSLog(@"【请求参数】%@",url);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    ///设置非校验模式
    manager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 客户端是否信任非法证书
    manager.securityPolicy.allowInvalidCertificates=NO;
    ///是否在证书域字段中验证域名
    [manager.securityPolicy setValidatesDomainName:YES];
    
    __weak typeof(manager) weakmanger = manager;
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* responseData = (NSDictionary*)responseObject;
        if (showLog) {
            NSLog(@"responseData:%@",responseData);
        }
            //如果responseData为nil，服务器端返回有错
        if (!responseData && show) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:@"抱歉，数据出错~"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
            [promptAlert show];
            return;
        }
        success(responseData);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (!weakmanger.reachabilityManager.isReachable && show) {
                
                UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                      message:@"网络出错"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
                [promptAlert show];
            }
                //打印错误数据
            if (error) {
                NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
            }
                //回调函数
            failure(error);
        }];
//    __weak typeof(manager) weakmanger = manager;
//    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary* responseData = (NSDictionary*)responseObject;
//        if (showLog) {
//            NSLog(@"responseData:%@",responseData);
//        }
//            //如果responseData为nil，服务器端返回有错
//        if (!responseData && show) {
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"抱歉，数据出错~"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//            return;
//        }
//        success(responseData);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //检查网络是否链接
//        if (!weakmanger.reachabilityManager.isReachable && show) {
//
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"网络出错"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//        }
//            //打印错误数据
//        if (error) {
//            NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
//        }
//            //回调函数
//        failure(error);
//    }];
}

+ (void)HTTP_POSTWithParameters:(id)parameters
                      showAlert:(BOOL)show
                        showLog:(BOOL)showLog
                 needEncryption:(BOOL)isNeed
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure{
    
    isNeed = NO;
    
    id params = parameters;
    AFHTTPSessionManager * manager = [HttpOperationManager httpManager];
    NSLog(@"httpManager CWBaseURLString:%@",manager.baseURL);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    ///设置非校验模式
    manager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 客户端是否信任非法证书
    manager.securityPolicy.allowInvalidCertificates=NO;
    ///是否在证书域字段中验证域名
    [manager.securityPolicy setValidatesDomainName:YES];
    
    parameters = [StringUtils md5ParamsWith:parameters needEncryption:isNeed];
    
    NSLog(@"【请求参数】%@",parameters);
    
    NSString * tail = @"app.do";
    if (!isNeed) {
        tail = @"open.do";
    }
    __weak typeof(manager) weakmanger = manager;
    
    [manager POST:tail parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* responseData = (NSDictionary*)responseObject;
//        NSLog(@"======responseObject:%@",responseObject);
        if (isNeed) {
            responseData = [StringUtils JsonDataWithmd5BaseData:responseData];
        }
        if (showLog) {
            NSLog(@"\n【%@】 responseData:%@",params[@"method"],responseData);
        }
            //如果responseData为nil，服务器端返回有错
        if (!responseData && show) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:@"抱歉，数据出错~"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
            [promptAlert show];
            return;
        }
        success(responseData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //检查网络是否链接
    if (!weakmanger.reachabilityManager.isReachable && show) {
        
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                              message:@"网络出错"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil];
        [promptAlert show];
    }
        //打印错误数据
    if (error) {
        NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
    }
        //回调函数
    failure(error);
    }];
    
//    [manager POST:tail parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary* responseData = (NSDictionary*)responseObject;
//        NSLog(@"======responseObject:%@",responseObject);
//        if (isNeed) {
////            responseData = [StringUtils JsonDataWithmd5BaseData:responseData];
//        }
//        if (showLog) {
//            NSLog(@"\n【%@】 responseData:%@",params[@"method"],responseData);
//        }
//            //如果responseData为nil，服务器端返回有错
//        if (!responseData && show) {
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"抱歉，数据出错~"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//            return;
//        }
//        success(responseData);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //检查网络是否链接
//        if (!weakmanger.reachabilityManager.isReachable && show) {
//
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"网络出错"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//        }
//            //打印错误数据
//        if (error) {
//            CXTLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
//        }
//            //回调函数
//        failure(error);
//    }];
}

+ (void)HTTP_POSTHaiNanLoginWithParameters:(id)parameters
                                 showAlert:(BOOL)show
                                   showLog:(BOOL)showLog
                            needEncryption:(BOOL)isNeed
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure{
    
    isNeed = NO;
    
    NSLog(@"【请求参数】%@",parameters);
    id params = parameters;
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
        ///设置非校验模式
    manager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        // 客户端是否信任非法证书
    manager.securityPolicy.allowInvalidCertificates=NO;
        ///是否在证书域字段中验证域名
    [manager.securityPolicy setValidatesDomainName:YES];
    
//    parameters = [StringUtils md5ParamsWith:parameters needEncryption:isNeed];
    NSString * url = @"http://hlwyyv2.jkscw.com.cn/hlwyy_ysba_service/index/insertLoginDoctorInfo.do";
    
    __weak typeof(manager) weakmanger = manager;
    
    [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* responseData = (NSDictionary*)responseObject;
        if (isNeed) {
//            responseData = [StringUtils JsonDataWithmd5BaseData:responseObject];
        }
        if (showLog) {
            NSLog(@"\n【%@】 responseData:%@",params[@"method"],responseData);
        }
            //如果responseData为nil，服务器端返回有错
        if (!responseData && show) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:@"抱歉，数据出错~"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil];
            [promptAlert show];
            return;
        }
        success(responseData);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (!weakmanger.reachabilityManager.isReachable && show) {

                UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                      message:@"网络出错"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil];
                [promptAlert show];
            }
                //打印错误数据
            if (error) {
                NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
            }
                //回调函数
            failure(error);
        }];
    
//    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//        NSDictionary* responseData = (NSDictionary*)responseObject;
//        if (isNeed) {
////            responseData = [StringUtils JsonDataWithmd5BaseData:responseObject];
//        }
//        if (showLog) {
//            NSLog(@"\n【%@】 responseData:%@",params[@"method"],responseData);
//        }
//            //如果responseData为nil，服务器端返回有错
//        if (!responseData && show) {
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"抱歉，数据出错~"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//            return;
//        }
//        success(responseData);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            //检查网络是否链接
//        if (!weakmanger.reachabilityManager.isReachable && show) {
//
//            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
//                                                                  message:@"网络出错"
//                                                                 delegate:nil
//                                                        cancelButtonTitle:@"确定"
//                                                        otherButtonTitles:nil];
//            [promptAlert show];
//        }
//            //打印错误数据
//        if (error) {
//            NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
//        }
//            //回调函数
//        failure(error);
//    }];
}

+(void)uploadImageWithData:(NSData *)data
              withsuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    [[self class] uploadImageArrayWithDatas:@[data] withsuccess:success failure:failure];
}

+(void)uploadImageArrayWithDatas:(NSArray <NSData *>*)datas
                     withsuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFSecurityPolicy *secur=[AFSecurityPolicy defaultPolicy];
    secur.allowInvalidCertificates=NO;
    manager.securityPolicy=secur;
    //设置请求格式
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    //设置返回格式
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSInteger time = [[NSDate date] timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"%li",time];
    NSString * url = [NSString stringWithFormat:@"%@/ystresource/img_upload_json.jsp?dirtype=staff",serverHttpImageBase_URL];
    
    [manager POST:url parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * fileNameStr = [NSString stringWithFormat:@"%@_%li.png",fileName,idx];
            [formData appendPartWithFileData:obj name:@"image" fileName:fileNameStr mimeType:@"image/jpeg"];
        }];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"responseData:%@",dict);
            if (success)success(dict);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //打印错误数据
            if (error) {
                NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
            }
            if (failure)failure(error);
        }];
    
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//        [datas enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSString * fileNameStr = [NSString stringWithFormat:@"%@_%li.png",fileName,idx];
//            [formData appendPartWithFileData:obj name:@"image" fileName:fileNameStr mimeType:@"image/jpeg"];
//        }];
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"responseData:%@",dict);
//        if (success)success(dict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //打印错误数据
//        if (error) {
//            NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
//        }
//        if (failure)failure(error);
//    }];
}

//+ (void)uploadCAImagesuccess:(void (^)(id responseObject))success
//                     failure:(void (^)(NSError *error))failure{
//    
//    
//    if (![BjcaSignManager bjcaStampPic]) {
//        if (failure)failure(nil);
//        return;
//    }
//    
//    UIImage * image = [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:[BjcaSignManager bjcaStampPic] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
//    
//    NSData * caImageData = UIImagePNGRepresentation(image);
//    if (!caImageData) {
//        if (failure)failure(nil);
//        return;
//    }
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    AFSecurityPolicy *secur=[AFSecurityPolicy defaultPolicy];
//    secur.allowInvalidCertificates=NO;
//    manager.securityPolicy=secur;
//    //设置请求格式
//    manager.requestSerializer =[AFJSONRequestSerializer serializer];
//    //设置返回格式
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    
//    NSInteger time = [[NSDate date] timeIntervalSince1970];
//    NSString * fileName = [NSString stringWithFormat:@"%li.png",time];
//    NSString * url = [NSString stringWithFormat:@"%@/ystresource/img_upload_json.jsp?dirtype=staff",serverHttpImageBase_URL];
//    
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:caImageData name:@"caimage" fileName:fileName mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"responseData:%@",dict);
//        if (success)success(dict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //打印错误数据
//        if (error) {
//            NSLog(@"ERROR CODE:%ld INFO:%@", error.code, error.userInfo);
//        }
//        if (failure)failure(error);
//    }];
//}
//+ (void)checkAPPVersionSuccess:(void (^)(id responseObject))success
//                       failure:(void (^)(NSError *error))failure;
//{
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    [manager GET:@"http://itunes.apple.com/cn/lookup?id=1522649560" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        CXTLog(@"responseData:%@",dict);
//        if (success)success(dict);
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            if (failure)failure(error);
//        }];
//}
@end
