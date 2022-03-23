//
//  TYMemberModel.h
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/3/10.
//  Copyright © 2022 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYMemberModel : NSObject

@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *homeTel;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSString *nameCn;
@property (nonatomic, copy) NSString *onBehalf;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *tyUserId;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *countLeft;
@property (nonatomic, copy) NSString *isInChatRoom; // "isInChatRoom":是否正在视频中，1：是，2：否

@property (nonatomic, copy) NSString *ryToken;//融云token

@end

NS_ASSUME_NONNULL_END
