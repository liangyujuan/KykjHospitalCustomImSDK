//
//  KyVideoRenderCollectionViewCell.m
//  HospitalOnline
//
//  Created by 梁玉娟 on 2022/2/25.
//  Copyright © 2022 cc. All rights reserved.
//

#import "KyVideoRenderCollectionViewCell.h"
#import "Factory.h"

@interface KyVideoRenderCollectionViewCell ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation KyVideoRenderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        [self setSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.bgView.layer.cornerRadius = 10.f;
}

- (void)setSubviews
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)setCellWithUserId:(NSString *)userId orderUserId:(NSString*)orderUserId
{
    if ([userId isEqualToString:orderUserId]) {

        [self.trtcCloud updateLocalView:self.bgView];
        
    }else{
        [self.trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeSmall
                               view:self.bgView];
    }
    
}

@end
