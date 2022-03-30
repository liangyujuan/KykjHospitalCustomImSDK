//
//  LeafNotification.m
//  LeafNotification
//
//  Created by Wang on 14-7-14.
//  Copyright (c) 2014年 Wang. All rights reserved.
//

#import "LeafNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>

#define DEFAULT_EDGE 24.0f
#define DEFAULT_SPACE_IMG_TEXT 5.0f
#define DEFAULT_RATE_WIDTH 1.0f
#define DEFAULT_DURATION 0.5f
#define DEFAULT_ANIMATON_DURATION 0.3f
#define DEFAULT_HEIGHT 68.0f

@interface LeafNotification()
{
    float imageSizeWH;
}
@property(nonatomic,strong) UIViewController *controller;
@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIImageView *flagImageView;
@property(nonatomic,strong) UILabel *textLabel;

@end
@implementation LeafNotification

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.backgroundColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 0.0f;
        self.layer.opacity = 0.7;
        
        _textLabel = [[UILabel alloc] initWithFrame:frame];
//        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        imageSizeWH = DEFAULT_EDGE;
        _flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSizeWH, imageSizeWH)];
        self.duration = DEFAULT_DURATION;
        
        [self addSubview:self.textLabel];
        [self addSubview:self.flagImageView];
      
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    
}
*/
-(void)setType:(LeafNotificationType)type
{
    switch (type) {
        case LeafNotificationTypeWarrning:
            self.flagImageView.image = [UIImage imageNamed:@"notification_warring"];
            break;
        case LeafNotificationTypeSuccess:
            self.flagImageView.image = [UIImage imageNamed:@"notification_success"];
            break;
        case LeafNotificationTypeRemind:
        {
            [_flagImageView setFrame:CGRectMake(0, 0, 0, 0)];
            imageSizeWH = 0;
            [self.flagImageView setImage:nil];
        }
            break;
        default:
            break;
    }
}
-(instancetype)initWithController:(UIViewController *)controller text:(NSString *)text{
    if([self initWithFrame:CGRectMake(0, -DEFAULT_HEIGHT, controller.view.bounds.size.width*DEFAULT_RATE_WIDTH, DEFAULT_HEIGHT)]){
        self.text = text;
        self.controller = controller;
        self.textLabel.text = text;
        self.flagImageView.image = [UIImage imageNamed:@"notification_warring"];
        [self.textLabel sizeToFit];
        CGSize size = self.textLabel.bounds.size;
        if(size.width > self.bounds.size.width - imageSizeWH - 2*DEFAULT_SPACE_IMG_TEXT){
            self.flagImageView.center = CGPointMake(imageSizeWH/2 + DEFAULT_SPACE_IMG_TEXT, DEFAULT_HEIGHT/2 + DEFAULT_SPACE_IMG_TEXT/2);
        }else{
            CGFloat edge_left = (self.bounds.size.width - size.width - DEFAULT_SPACE_IMG_TEXT*2 - imageSizeWH)/2;
            self.flagImageView.center = CGPointMake(edge_left + DEFAULT_SPACE_IMG_TEXT + imageSizeWH/2, DEFAULT_HEIGHT/2 + DEFAULT_SPACE_IMG_TEXT/2);
        }
        self.textLabel.center = CGPointMake(CGRectGetMaxX(self.flagImageView.frame) +DEFAULT_SPACE_IMG_TEXT + size.width/2, self.flagImageView.center.y);
        
        self.center = CGPointMake(self.controller.view.bounds.size.width/2,self.center.y);
    }
    return self;
}

-(void)showWithAnimation:(BOOL)animation{
    CGRect frame = self.frame;
    if([self.controller.parentViewController isKindOfClass:[UINavigationController class]] && !self.controller.navigationController.navigationBar.isHidden){
        frame.origin.y = 64 - DEFAULT_SPACE_IMG_TEXT;
    }else{
        frame.origin.y = -DEFAULT_SPACE_IMG_TEXT;
    }
    if(animation){
        [UIView animateWithDuration:DEFAULT_ANIMATON_DURATION animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self showHandle];
        }];
    }else{
        self.frame = frame;
        [self showHandle];
    }
}
-(void)showHandle{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DEFAULT_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithAnimation:YES];
    });
}
-(void)dismissWithAnimation:(BOOL)animation{
    CGRect frame = self.frame;
    frame.origin.y = -DEFAULT_HEIGHT;
    if(animation){
        [UIView animateWithDuration:DEFAULT_ANIMATON_DURATION animations:^{
            self.frame = frame;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
//        self.frame = frame;
        [self removeFromSuperview];
    }
}

+(void)showInController:(UIViewController *)controller withText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];

}

+(void)showInView:(UIView *)view withText:(NSString *)text{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
    
}

//设置时间的提示
+(void)showInController:(UIViewController *)controller withText:(NSString *)text withTime:(NSInteger)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5f];

}





+(void)showInController:(UIViewController *)controller withText:(NSString *)text type:(LeafNotificationType)type{
    LeafNotification *notification = [[LeafNotification alloc] initWithController:controller text:text];
    [controller.view addSubview:notification];
    notification.type = type;
    [notification showWithAnimation:YES];
    
}

+(void)showHint:(NSString *)hint yOffset:(float)yOffset{
    //显示提示信息
    if ([hint isKindOfClass:[NSString class]]) {
        UIView *view = [[UIApplication sharedApplication].delegate window];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //下面的2行代码必须要写，如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.8f];
        hud.userInteractionEnabled = NO;
    //设置自定义样式的mode
        hud.mode = MBProgressHUDModeCustomView;
        CGRect rect = [hint boundingRectWithSize:CGSizeMake(MAXFLOAT, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} context:nil];
        hud.minSize = CGSizeMake(rect.size.width+30, 60);
        
        hud.bezelView.layer.masksToBounds = NO;
       
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = hint;
        titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.layer.cornerRadius = 10;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        [hud.bezelView addSubview:titleLabel];

        float titleW = [UIApplication sharedApplication].delegate.window.bounds.size.width-135;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.center.equalTo(hud.bezelView);
            make.centerX.equalTo(hud.bezelView);
            make.top.equalTo(hud.bezelView).mas_offset(18);
            make.bottom.equalTo(hud.bezelView).mas_offset(-18);
            make.width.mas_equalTo(titleW);
        }];

        hud.margin = 20.f;
    //    hud.yOffset = 180;
    //    hud.yOffset += yOffset;
    //    hud.yOffset = -[UIApplication sharedApplication].delegate.window.bounds.size.height/2;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5f];
    }
   
    
}

@end
