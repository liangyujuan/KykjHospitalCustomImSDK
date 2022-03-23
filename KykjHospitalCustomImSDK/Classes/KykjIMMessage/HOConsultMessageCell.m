//
//  HOConsultMessageCell.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/3.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HOConsultMessageCell.h"
#import <RongIMKit/RCConversationCell.h>
#import "HOConsultMessage.h"
#import "HOConsultMessageContentView.h"
#import "UIView+LSCore.h"
#import "Factory.h"


@interface HOConsultMessageCell()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) HOConsultMessageContentView * customerMessageContentView;

@end

@implementation HOConsultMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {

    HOConsultMessage *message = (HOConsultMessage *)model.content;
    CGSize size = [HOConsultMessageCell getBubbleBackgroundViewSize:message];

    CGFloat __messagecontentview_height = size.height;
    __messagecontentview_height += extraHeight;

    return CGSizeMake(collectionViewWidth, __messagecontentview_height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    self.bubbleBackgroundView.userInteractionEnabled = YES;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    self.customerMessageContentView = [[bundle loadNibNamed:@"HOConsultMessageContentView" owner:nil options:nil] firstObject];
    
//    self.customerMessageContentView = [[[NSBundle bundleWithPath:path] loadNibNamed:@"HOConsultMessageContentView" owner:nil options:nil] firstObject];

   
//    self.customerMessageContentView = [[[NSBundle mainBundle] loadNibNamed:@"HOConsultMessageContentView" owner:nil options:nil] firstObject];
    [self.bubbleBackgroundView addSubview:self.customerMessageContentView];
    
    [self.customerMessageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.bubbleBackgroundView);
    }];
}

#pragma mark - IBAction


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    [self setAutoLayout];
    
     self.customerMessageContentView.message = self.model.content;
}

- (void)setAutoLayout {
    HOConsultMessage *message = (HOConsultMessage *)self.model.content;
    
    CGFloat x = 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 6;
    CGFloat width =MIN(ScreenWidth*0.632, ScreenWidth - x*2);
    x = ScreenWidth - width - x;
    CGFloat height = [HOConsultMessageContentView getContentViewSizeWith:width message:message];
    
    UIRectCorner bubbleBackgroundViewRectCorner;
    if (self.messageDirection == MessageDirection_SEND){
        //发送
        self.messageContentView.frame = CGRectMake(x, self.messageContentView.frame.origin.y, width, height);
        bubbleBackgroundViewRectCorner = UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }else{
        //接收
        self.messageContentView.frame = CGRectMake(self.messageContentView.frame.origin.x, self.messageContentView.frame.origin.y, width, height);
        bubbleBackgroundViewRectCorner = UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    }
    
    self.bubbleBackgroundView.frame = CGRectMake(0, 0, self.messageContentView.frame.size.width, self.messageContentView.frame.size.height);
    
    [self.bubbleBackgroundView addRoundedCorners:bubbleBackgroundViewRectCorner  withRadii:CGSizeMake(5, 5) viewRect:self.bubbleBackgroundView.bounds];
}


+ (CGSize)getBubbleBackgroundViewSize:(HOConsultMessage *)message {
    
    CGFloat messageContentViewOriginX = 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 6;
    CGFloat messageContentViewWidth =MIN(ScreenWidth*0.632, ScreenWidth - messageContentViewOriginX*2);
    CGFloat messageContentViewHeight = [HOConsultMessageContentView getContentViewSizeWith:messageContentViewWidth message:message] + 10;// 消息体与输入框的空隙10
    return CGSizeMake(messageContentViewWidth, messageContentViewHeight); // 10：与吓一条消息的距离
}
@end
