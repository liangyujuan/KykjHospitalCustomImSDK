//
//  LYJAlertView.m
//  HospitalOnline
//
//  Created by KuaiYi on 2020/4/17.
//  Copyright © 2020 cc. All rights reserved.
//

#import "LYJAlertView.h"
#import "Factory.h"

@interface LYJAlertView ()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *alert;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, copy) OperationBlock operationBlock;
@property (nonatomic, copy) PassValueBlock passValueBlock;

@end

static LYJAlertView *_alertView;

@implementation LYJAlertView

+ (LYJAlertView *)sharedView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alertView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.alpha = 0.f;
        _alertView.maskView = [[UIView alloc] initWithFrame:_alertView.bounds];
        [_alertView addSubview:_alertView.maskView];
        _alertView.maskView.backgroundColor = [UIColor blackColor];
        _alertView.maskView.alpha = .3f;
    });
    return _alertView;
}

- (void)layoutSubviews
{
    _alert.layer.cornerRadius = 4.f;
}
#pragma mark - 确认弹出框
+ (void)showConfirmAlertWithContent:(NSString *)content
                      confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction
{
    [[self sharedView] confirmAlertWithTitle:@"" content:content confirmAction:action cancleAction:cancleAction];
}

+ (void)showConfirmAlertWithTitle:(NSString*)title content:(NSString *)content confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction
{
    [[self sharedView] confirmAlertWithTitle:title content:content confirmAction:action cancleAction:cancleAction];
}

- (void)confirmAlertWithTitle:(NSString*)title content:(NSString *)content
                  confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction
{
    _alert = [UIView new];
    _alert.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_alert];
    [_alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alertView).mas_offset(50);
        make.right.equalTo(_alertView).mas_offset(-50);
        make.center.equalTo(_alertView);
    }];
    
    _operationBlock = action;
    UILabel *contentLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(content).textAlignment(NSTextAlignmentCenter).numberOfLines(0).textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:16]).addToSuperView(self.alert);
    }];
    if (![KykjImToolkit isStringBlank:title]) {
        UILabel *titleLabel = [UILabel makeLabel:^(LabelMaker *make) {
            make.text(title).textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).numberOfLines(0).addToSuperView(self.alert);
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.alert);
//            make.left.equalTo(self.alert).mas_offset(20);
//            make.right.equalTo(self.alert).mas_offset(-20);
            make.top.equalTo(self.alert).mas_offset(25);
        }];
        
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alert).mas_offset(20);
            make.right.equalTo(self.alert).mas_offset(-20);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(20);
        }];
    }else{
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alert).mas_offset(20);
            make.right.equalTo(self.alert).mas_offset(-20);
            make.top.equalTo(self.alert).mas_offset(40);
        }];
    }
    
    
    UIButton *cancel = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.backgroundColor(UIColorFromRGB(0xEFF0F4)).titleForState(@"取消", UIControlStateNormal).titleColorForState(RGB(153, 153, 153), UIControlStateNormal).titleFont([UIFont systemFontOfSize:16]).addAction(self, @selector(closeAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.equalTo(contentLabel.mas_bottom).mas_offset(40);
        make.bottom.equalTo(self.alert).mas_offset(-25);
        make.left.equalTo(self.alert).mas_offset(35);
    }];
    
    UIButton *confirm = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.backgroundColor(RGB(1, 111, 255)).titleForState(@"确定", UIControlStateNormal).titleColorForState([UIColor whiteColor], UIControlStateNormal).titleFont([UIFont systemFontOfSize:16]).addAction(self, @selector(operationAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.alert).mas_offset(-25);
        make.right.equalTo(self.alert).mas_offset(-35);
    }];
    
    [self.window addSubview:_alertView];
    
    [self layoutIfNeeded];
    cancel.layer.cornerRadius = 4.f;
    confirm.layer.cornerRadius = 4.f;
    
    [UIView animateWithDuration:.25f animations:^{
        _alertView.alpha = 1.f;
    }];
}
#pragma mark - 提示弹出框
+ (void)showNoticeAlertWithTitle:(NSString *)title
                         content:(NSString *)content
                     buttonTitle:(NSString *)buttonTitle
                    buttonAction:(nullable OperationBlock)action
{
    [[self sharedView] noticeAlertWithTitle:title content:content buttonTitle:buttonTitle buttonAction:action];
}
- (void)noticeAlertWithTitle:(NSString *)title
                     content:(NSString *)content
                 buttonTitle:(NSString *)buttonTitle
                buttonAction:(nullable OperationBlock)action
{
    _alert = [UIView new];
    _alert.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_alert];
    [_alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alertView).mas_offset(50);
        make.right.equalTo(_alertView).mas_offset(-50);
        make.center.equalTo(_alertView);
    }];
    
    _operationBlock = action;
    
    UIButton *close = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.imageForState([KykjImToolkit getImageResourceForName:@"alert_close"], UIControlStateNormal).addAction(self, @selector(closeAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.equalTo(self.alert).mas_offset(-10);
        make.top.equalTo(self.alert).mas_offset(5);
    }];
    
    UILabel *titleLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(title).textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:16]).addToSuperView(self.alert);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alert);
        make.top.equalTo(self.alert).mas_offset(25);
    }];
    
    UILabel *contentLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(content).textAlignment(NSTextAlignmentCenter).numberOfLines(0).textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:15]).addToSuperView(self.alert);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alert).mas_offset(20);
        make.right.equalTo(self.alert).mas_offset(-20);
        make.top.equalTo(titleLabel.mas_bottom).mas_offset(15);
    }];
    
    UIButton *button = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.backgroundColor(RGB(1, 111, 255)).titleForState(buttonTitle, UIControlStateNormal).titleColorForState([UIColor whiteColor], UIControlStateNormal).titleFont([UIFont boldSystemFontOfSize:16]).addAction(self, @selector(operationAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(36);
        make.centerX.equalTo(self.alert);
        make.bottom.equalTo(self.alert).mas_offset(-25);
    }];
    
    [self.window addSubview:_alertView];
    
    [self layoutIfNeeded];
    button.layer.cornerRadius = 4.f;
    
    [UIView animateWithDuration:.25f animations:^{
        _alertView.alpha = 1.f;
    }];
}
+ (void)showMainColorTitle:(NSString *)title content:(NSString*)content confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction
{
    [[self sharedView]mainColorTitle:title content:content confirmAction:action cancleAction:cancleAction];
}
- (void)mainColorTitle:(NSString *)title content:(NSString*)content confirmAction:(nullable OperationBlock)action cancleAction:(nullable PassValueBlock)cancleAction
{
    _alert = [UIView new];
    _alert.backgroundColor = [UIColor whiteColor];
    [_alertView addSubview:_alert];
    [_alert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_alertView).mas_offset(50);
        make.right.equalTo(_alertView).mas_offset(-50);
        make.center.equalTo(_alertView);
    }];
    
    _operationBlock = action;
    
    UIView *topMainColorView = [[UIView alloc] init];
    topMainColorView.backgroundColor = RGB(1, 111, 255);
    [self.alert addSubview:topMainColorView];
    [topMainColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alert).mas_offset(20);
        make.right.equalTo(self.alert).mas_offset(-20);
        make.top.equalTo(self.alert);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *titleLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(content).textAlignment(NSTextAlignmentCenter).numberOfLines(0).textColor([UIColor whiteColor]).font([UIFont systemFontOfSize:16]).addToSuperView(self.alert);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topMainColorView);
    }];
    
    UILabel *contentLabel = [UILabel makeLabel:^(LabelMaker *make) {
        make.text(content).textAlignment(NSTextAlignmentCenter).numberOfLines(0).textColor(RGB(51, 51, 51)).font([UIFont systemFontOfSize:16]).addToSuperView(self.alert);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alert).mas_offset(20);
        make.right.equalTo(self.alert).mas_offset(-20);
        make.top.equalTo(topMainColorView.mas_bottom).mas_offset(20);
    }];
    
    UIButton *cancel = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.backgroundColor(UIColorFromRGB(0xEFF0F4)).titleForState(@"取消", UIControlStateNormal).titleColorForState(RGB(153, 153, 153), UIControlStateNormal).titleFont([UIFont systemFontOfSize:16]).addAction(self, @selector(closeAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.top.equalTo(contentLabel.mas_bottom).mas_offset(40);
        make.bottom.equalTo(self.alert).mas_offset(-25);
        make.left.equalTo(self.alert).mas_offset(35);
    }];
    
    UIButton *confirm = [UIButton makeButton:^(ButtonMaker * _Nonnull make) {
        make.backgroundColor(RGB(1, 111, 255)).titleForState(@"确定", UIControlStateNormal).titleColorForState([UIColor whiteColor], UIControlStateNormal).titleFont([UIFont systemFontOfSize:16]).addAction(self, @selector(operationAction), UIControlEventTouchUpInside).addToSuperView(self.alert);
    }];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.bottom.equalTo(self.alert).mas_offset(-25);
        make.right.equalTo(self.alert).mas_offset(-35);
    }];
    
    [self.window addSubview:_alertView];
    
    [self layoutIfNeeded];
    cancel.layer.cornerRadius = 4.f;
    confirm.layer.cornerRadius = 4.f;
    
    [UIView animateWithDuration:.25f animations:^{
        _alertView.alpha = 1.f;
    }];
}

- (void)operationAction
{
   [self closeAction];
    if (_operationBlock)
    {
        _operationBlock();
    }
}

- (void)closeAction
{
    [UIView animateWithDuration:.25f animations:^{
        _alertView.alpha = 0.f;
    } completion:^(BOOL finished) {
        self.operationBlock = nil;
        self.passValueBlock = nil;
        [self.alert removeFromSuperview];
        self.alert = nil;
        [_alertView removeFromSuperview];
    }];
}

- (UIWindow *)window
{
    if (!_window)
    {
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

@end
