//
//  UIButton+Factory.h
//  StatementManager
//
//  Created by KuaiYi on 2020/3/4.
//  Copyright © 2020 panchenglei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ButtonMaker : NSObject

- (ButtonMaker *(^)(CGRect))frame;
- (ButtonMaker *(^)(NSString *, UIControlState))titleForState;
- (ButtonMaker *(^)(NSAttributedString *, UIControlState))attributedTitleForState;
- (ButtonMaker *(^)(UIImage *, UIControlState))imageForState;
- (ButtonMaker *(^)(UIColor *, UIControlState))titleColorForState;
- (ButtonMaker *(^)(UIEdgeInsets))contentEdgeInsets;
- (ButtonMaker *(^)(UIImage *, UIControlState))backgroundImageForState;
- (ButtonMaker *(^)(UIFont *))titleFont;
- (ButtonMaker *(^)(UIColor *))backgroundColor;
- (ButtonMaker *(^)(id _Nonnull, SEL, UIControlEvents))addAction;
- (ButtonMaker *(^)(UIView *))addToSuperView;

@end

@interface UIButton (Factory)

+ (instancetype)makeButton:(void(^)(ButtonMaker *make))buttonMaker;

@end

NS_ASSUME_NONNULL_END
