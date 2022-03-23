//
//  StringUtils.h
//  dd
//
//  Created by Xia on 14-7-24.
//  Copyright (c) 2014年 letide. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface StringUtils : NSObject

NSString * getSafeString(id object);
NSURL * getImageAddress(NSString * urlStr);

//获取富文本frame
+ (CGRect) getAttributedStringSize:(NSAttributedString*)str Andwidht:(CGSize)size;

//服务器数据处理
+ (NSDictionary *)md5ParamsWith:(NSDictionary *)params;
+ (NSDictionary *)JsonDataWithmd5BaseData:(NSDictionary *)data;
+ (NSDictionary *)md5ParamsWith:(NSDictionary *)params needEncryption:(BOOL)isNeed;

@end
