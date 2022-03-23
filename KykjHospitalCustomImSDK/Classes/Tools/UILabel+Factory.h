//
//  UILabel+Factory.h
//  StatementManager
//
//  Created by KuaiYi on 2020/3/4.
//  Copyright © 2020 panchenglei. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LabelMaker : NSObject

- (LabelMaker *(^)(CGRect))frame;
- (LabelMaker *(^)(UIFont *))font;
- (LabelMaker *(^)(UIColor *))textColor;
- (LabelMaker *(^)(UIColor *))backgroundColor;
- (LabelMaker *(^)(NSTextAlignment))textAlignment;
- (LabelMaker *(^)(NSInteger))numberOfLines;
- (LabelMaker *(^)(NSString *text))text;
- (LabelMaker *(^)(NSAttributedString *attributedText))attributedText;
- (LabelMaker *(^)(BOOL))userInteraction;
- (LabelMaker *(^)(BOOL))enable;
- (LabelMaker *(^)(BOOL))adjustsFontSizeToFitWidth;
- (LabelMaker *(^)(CGFloat))minimumScale;
- (LabelMaker *(^)(UIView *))addToSuperView;

@end

@interface UILabel (Factory)

+ (instancetype)makeLabel:(void(^)(LabelMaker *make))labelMaker;

@end

NS_ASSUME_NONNULL_END
