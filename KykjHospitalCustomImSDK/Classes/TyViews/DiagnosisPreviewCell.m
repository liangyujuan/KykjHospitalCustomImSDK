//
//  DiagnosisPreviewCell.m
//  HospitalOnline
//
//  Created by KuaiYi on 2020/5/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import "DiagnosisPreviewCell.h"

@interface DiagnosisPreviewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation DiagnosisPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = colorBackground;
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
        [self setSubviews];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgView.layer.cornerRadius = 14.75f;
}
- (void)setSubviews
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(15);
        make.right.equalTo(self.contentView).mas_offset(-15);
    }];
    _titleLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(102, 102, 102)).font([UIFont systemFontOfSize:14]).addToSuperView(self.contentView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).mas_offset(20);
        make.left.equalTo(self.contentView).mas_offset(30);
    }];
    
    _contentLabel = [UILabel makeLabel:^(LabelMaker * _Nonnull make) {
        make.textColor(RGB(51, 51, 51)).font([UIFont boldSystemFontOfSize:14]).numberOfLines(0).addToSuperView(self.contentView);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.left.equalTo(self.contentView).mas_offset(45);
        make.right.equalTo(self.contentView).mas_offset(-45);
        make.bottom.equalTo(view).mas_offset(-7);
    }];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = colorBackground;

    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentLabel).insets(UIEdgeInsetsMake(7, 18, 7, 18));
        make.top.equalTo(self.contentLabel).mas_offset(-7);
        make.bottom.equalTo(self.contentLabel).mas_offset(7);
        make.left.equalTo(self.contentLabel).mas_offset(-18);
        make.right.equalTo(self.contentLabel).mas_offset(18);
    }];
    [self.contentView bringSubviewToFront:_contentLabel];
}
- (void)setCellTitle:(NSString *)title content:(NSString *)content
{
    _titleLabel.text = title;
    if ([KykjImToolkit isStringBlank:content]) {
        _contentLabel.text = @"暂无";
    }else{
        _contentLabel.text = content;
    }
    [self layoutIfNeeded];
}
@end
