//
//  LeafNotification.h
//  LeafNotification
//
//  Created by Wang on 14-7-14.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LeafNotificationTypeWarrning,
    LeafNotificationTypeSuccess,
    LeafNotificationTypeRemind
}LeafNotificationType;


@interface LeafNotification : UIView

-(instancetype)initWithController:(UIViewController *)controller text:(NSString *)text;
/**
 *  停留时间
 */
@property (nonatomic,assign) NSTimeInterval duration;
@property(nonatomic,assign) LeafNotificationType type;

-(void)showWithAnimation:(BOOL)animation;
-(void)dismissWithAnimation:(BOOL)animation;

+(void)showInController:(UIViewController *)controller withText:(NSString *)text type:(LeafNotificationType)type;
+(void)showInView:(UIView *)view withText:(NSString *)text;

+(void)showInController:(UIViewController *)controller withText:(NSString *)text;

//设置消失时间
+(void)showInController:(UIViewController *)controller withText:(NSString *)text withTime:(NSInteger)time;

+(void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
