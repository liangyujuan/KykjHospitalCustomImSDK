//
//  HODrugRecipeMessageCell.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HODrugRecipeMessageCell.h"
#import <RongIMKit/RCConversationCell.h>
#import "HOMedrMessage.h"
#import "HODrugRecipeMessageContentView.h"
#import "UIView+LSCore.h"
#import "Masonry/Masonry.h"

@interface HODrugRecipeMessageCell()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) HODrugRecipeMessageContentView * customerMessageContentView;

@end

@implementation HODrugRecipeMessageCell
+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {

    HOMedrMessage *message = (HOMedrMessage *)model.content;
    CGSize size = [HODrugRecipeMessageCell getBubbleBackgroundViewSize:message];

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

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK" ofType:@"bundle"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KykjHospitalCustomImSDK" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    
    self.customerMessageContentView = [[bundle loadNibNamed:@"HODrugRecipeMessageContentView" owner:nil options:nil] firstObject];
    
//    self.customerMessageContentView = [[[NSBundle mainBundle] loadNibNamed:@"HODrugRecipeMessageContentView" owner:nil options:nil] firstObject];
    [self.bubbleBackgroundView addSubview:self.customerMessageContentView];
    
    [self.customerMessageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(self.bubbleBackgroundView);
    }];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelector:)];
      tap.numberOfTapsRequired = 1;
      tap.numberOfTouchesRequired = 1;
    [self.customerMessageContentView addGestureRecognizer:tap];
}

- (void)tapSelector:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
#pragma mark - IBAction


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    [self setAutoLayout];
}

- (void)setAutoLayout {
    HOMedrMessage *message = (HOMedrMessage *)self.model.content;
    self.customerMessageContentView.message = message;
    
    CGFloat x = 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 6;
    CGFloat width =MIN([[UIScreen mainScreen]bounds].size.width*0.632, [[UIScreen mainScreen]bounds].size.width - x*2);
    x = [[UIScreen mainScreen]bounds].size.width - width - x;
    CGFloat height = [HODrugRecipeMessageContentView getContentViewSizeWith:width message:message];
    
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


+ (CGSize)getBubbleBackgroundViewSize:(HOMedrMessage *)message {
    
    CGFloat messageContentViewOriginX = 10 + [RCIM sharedRCIM].globalMessagePortraitSize.width + 6;
    CGFloat messageContentViewWidth =MIN([[UIScreen mainScreen]bounds].size.width*0.632, [[UIScreen mainScreen]bounds].size.width - messageContentViewOriginX*2);
    CGFloat messageContentViewHeight = [HODrugRecipeMessageContentView getContentViewSizeWith:messageContentViewWidth message:message] + 10;// 消息体与输入框的空隙10
    return CGSizeMake(messageContentViewWidth, messageContentViewHeight); // 10：与吓一条消息的距离
}

@end
