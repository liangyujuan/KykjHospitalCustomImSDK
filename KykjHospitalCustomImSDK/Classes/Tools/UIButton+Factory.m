//
//  UIButton+Factory.m
//  StatementManager
//
//  Created by KuaiYi on 2020/3/4.
//  Copyright © 2020 panchenglei. All rights reserved.
//

#import "UIButton+Factory.h"

@interface ButtonMaker ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation ButtonMaker
- (ButtonMaker *(^)(CGRect))frame
{

    
    return ^ButtonMaker *(CGRect rect){
        self.button.frame = rect;
        return self;
    };
}

- (ButtonMaker *(^)(NSString *, UIControlState))titleForState
{
 
    return ^ButtonMaker *(NSString *title, UIControlState state){
        [self.button setTitle:title forState:state];
        return self;
    };
}

- (ButtonMaker *(^)(NSAttributedString *, UIControlState))attributedTitleForState
{
    return ^ButtonMaker *(NSAttributedString *attributedString, UIControlState state){
        [self.button setAttributedTitle:attributedString forState:state];
        return self;
    };
}

- (ButtonMaker *(^)(UIImage *, UIControlState))imageForState
{
    return ^ButtonMaker *(UIImage *image, UIControlState state){
        [self.button setImage:image forState:state];
        return self;
    };
}

- (ButtonMaker *(^)(UIColor *, UIControlState))titleColorForState
{
    return ^ButtonMaker *(UIColor *color, UIControlState state){
        [self.button setTitleColor:color forState:state];
        return self;
    };
}
- (ButtonMaker *(^)(UIEdgeInsets))contentEdgeInsets
{
    return ^ButtonMaker *(UIEdgeInsets edgeInsets){
        self.button.contentEdgeInsets = edgeInsets;
        return self;
    };
}

- (ButtonMaker *(^)(UIImage *, UIControlState))backgroundImageForState
{
    return ^ButtonMaker *(UIImage *image, UIControlState state){
        [self.button setBackgroundImage:image forState:state];
        return self;
    };
}

- (ButtonMaker *(^)(UIFont *))titleFont
{
    return ^ButtonMaker *(UIFont *font){
        self.button.titleLabel.font = font;
        return self;
    };
}

- (ButtonMaker *(^)(UIColor *))backgroundColor
{
    return ^ButtonMaker *(UIColor *backgroundColor){
        [self.button setBackgroundColor:backgroundColor];
        return self;
    };
}

- (ButtonMaker *(^)(id _Nonnull, SEL, UIControlEvents))addAction
{
    return ^ButtonMaker *(id _Nonnull obj, SEL action, UIControlEvents event){
        [self.button addTarget:obj action:action forControlEvents:event];
        return self;
    };
}

- (ButtonMaker *(^)(UIView *))addToSuperView
{
    return ^ButtonMaker *(UIView *superView){
        [superView addSubview:self.button];
        return self;
    };
}

@end

@implementation UIButton (Factory)
+ (instancetype)makeButton:(void(^)(ButtonMaker *make))buttonMaker
{
    ButtonMaker *maker = [ButtonMaker new];
    maker.button = [self buttonWithType:UIButtonTypeCustom];
    maker.button.adjustsImageWhenHighlighted = NO;
    buttonMaker(maker);
    return maker.button;
}

@end
