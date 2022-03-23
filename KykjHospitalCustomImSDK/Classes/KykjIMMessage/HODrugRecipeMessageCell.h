//
//  HODrugRecipeMessageCell.h
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "HOMedrMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface HODrugRecipeMessageCell : RCMessageCell

/*！
 白色背景View
 */
@property (strong, nonatomic) UIView *whiteBgView;

/*!
 临床诊断的Label
*/
@property(strong, nonatomic) UILabel *clinicalDiagnosisLabel;

/*!
 titleLabel
 */
@property(strong, nonatomic) UILabel *titleLabel;

/*！
 查看处方按钮
 */
@property (strong, nonatomic) UIButton *checkPrescriptionButton;
/*！
 查看药方点击回调
 */
@property (copy, nonatomic) void(^checkPrescriptionButtonClickBlock)(UIButton *button);


/*!
 分割线
 */
@property(strong, nonatomic) UIView *line;


/*!
 背景View
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/*!
 根据消息内容获取显示的尺寸

 @param message 消息内容

 @return 显示的View尺寸
 */
+ (CGSize)getBubbleBackgroundViewSize:(HOMedrMessage *)message;


@end

NS_ASSUME_NONNULL_END
