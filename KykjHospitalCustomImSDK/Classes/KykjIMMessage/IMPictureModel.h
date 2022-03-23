//
//  IMPictureModel.h
//  HospitalOnline
//
//  Created by KuaiYi on 2020/12/17.
//  Copyright © 2020 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPictureModel : NSObject

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, copy) NSString *CONSULT_CON;

@property (nonatomic, copy) NSString *USER_PHONE;

@property (nonatomic, copy) NSString *CONSULT_ID;

@property (nonatomic, copy) NSString *CONSULT_TIME;

@property (nonatomic, copy) NSString *USER_NAME;

@end

NS_ASSUME_NONNULL_END
