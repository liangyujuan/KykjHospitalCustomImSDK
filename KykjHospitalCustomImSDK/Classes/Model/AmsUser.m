//
//  AmsUser.m
//  HealthXiLanDoctor
//
//  Created by adtech on 16/3/14.
//  Copyright © 2016年 adtech. All rights reserved.
//

#import "AmsUser.h"
#import "KykjImToolkit.h"

@implementation AmsUser

- (NSString *)age{
    return [KykjImToolkit getIdentityCardAge:self.ID_CARD];
}

- (NSString *)sexStr{
    if (self.SEX.integerValue == 0) {
        return @"未填写";
    }else if (self.SEX.integerValue == 1){
        return @"男";
    }else if (self.SEX.integerValue == 2){
         return @"女";
    }
    return @"未填写";
}


@end
