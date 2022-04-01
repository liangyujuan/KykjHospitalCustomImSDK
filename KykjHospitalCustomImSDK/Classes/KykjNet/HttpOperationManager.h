//
//  HttpOperationManager.h
//  HealthXilan
//
//  Created by adtech on 16/3/11.
//  Copyright © 2016年 adtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Factory.h"
//@import AFNetworking;
#import <AFNetworking/AFNetworking.h>

//@class AFHTTPSessionManager;

//请求成功时的回调block
typedef void (^getDataBlock)(id data);

@interface HttpOperationManager : AFHTTPSessionManager

//http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
                      showAlert:(BOOL)show
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;
    //http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
                      showAlert:(BOOL)show
                        showLog:(BOOL)showLog
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

    //http POST
+ (void)HTTP_GetWithUrl:(id)url
              showAlert:(BOOL)show
                showLog:(BOOL)showLog
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

    //http POST
+ (void)HTTP_POSTWithParameters:(id)parameters
                      showAlert:(BOOL)show
                        showLog:(BOOL)showLog
                 needEncryption:(BOOL)isNeed
                        success:(void (^)(id responseObject))success
                        failure:(void (^)(NSError *error))failure;

 //海南互联网医院登录监管
+ (void)HTTP_POSTHaiNanLoginWithParameters:(id)parameters
                                 showAlert:(BOOL)show
                                   showLog:(BOOL)showLog
                            needEncryption:(BOOL)isNeed
                                   success:(void (^)(id responseObject))success
                                   failure:(void (^)(NSError *error))failure;

//+ (void)uploadCAImagesuccess:(void (^)(id responseObject))success
//failure:(void (^)(NSError *error))failure;

+(void)uploadImageWithData:(NSData *)data
              withsuccess:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

+(void)uploadImageArrayWithDatas:(NSArray <NSData *>*)datas
                     withsuccess:(void (^)(id responseObject))success
                         failure:(void (^)(NSError *error))failure;
//+ (void)checkAPPVersionSuccess:(void (^)(id responseObject))success
//                       failure:(void (^)(NSError *error))failure;
@end
