//
//  LYJAlertView.h
//  HospitalOnline
//
//  Created by KuaiYi on 2020/4/17.
//  Copyright © 2020 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OperationBlock)(void);
typedef void(^PassValueBlock)(id obj);

@interface LYJAlertView : UIView

/**
 确认弹出框

 @param content 内容
 @param action 确认按钮事件
 */
+ (void)showConfirmAlertWithContent:(NSString *)content
                      confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction;

+ (void)showConfirmAlertWithTitle:(NSString*)title content:(NSString *)content confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction;

#pragma mark - 提示弹出框
+ (void)showNoticeAlertWithTitle:(NSString *)title
                         content:(NSString *)content
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(nullable OperationBlock)action;

+ (void)showMainColorTitle:(NSString *)title content:(NSString*)content confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction;

@end

NS_ASSUME_NONNULL_END
