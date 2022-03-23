//
//  HOConsultMessageContentView.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/3.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HOConsultMessageContentView.h"
#import "LZPictureBrowser.h"
#import "Factory.h"
#import "NSString+Extension.h"


@interface HOConsultMessageContentView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UIImageView *patientSex;
@property (weak, nonatomic) IBOutlet UILabel *patientAge;
@property (weak, nonatomic) IBOutlet UILabel *lastDiagnose;
@property (weak, nonatomic) IBOutlet UILabel *illnessDes;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLab;

@property (weak, nonatomic) IBOutlet UIView *imageListView;
@property (weak, nonatomic) IBOutlet UIView *diagnoseView;
@property (weak, nonatomic) IBOutlet UIView *illnessDesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diagnoseViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *illnessDesHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageListViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;

@end

@implementation HOConsultMessageContentView

- (void)setMessage:(HOConsultMessage *)message{
    _message = message;
    
    if ([message.extraModel.srcType isEqualToString:@"fz"]) {
        self.titleLab.text = @"互联网复诊";
    }else{
        self.titleLab.text = @"健康咨询";
    }
    
    self.patientName.text = message.extraModel.name;
    
    self.patientSex.image = message.extraModel.sex.intValue==2?[KykjImToolkit getImageResourceForName:@"PL_woman"]: [KykjImToolkit getImageResourceForName:@"PL_man_ic"];
    self.patientAge.text = [NSString stringWithFormat:@"%i岁",message.extraModel.age.intValue];
    
    if (message.extraModel.firstIllness.length == 0) {
        self.diagnoseView.hidden = YES;
        self.diagnoseViewHeight.constant = 0;
    }else{
        self.diagnoseView.hidden = NO;
        self.lastDiagnose.attributedText = message.extraModel.firstConsultationInfo;
        self.diagnoseViewHeight.constant = message.extraModel.diagnoseViewHeight;
    }
    
    self.contentTitleLabel.textColor = RGB(152, 152, 152);
    
    self.illnessDes.text = message.extraModel.txt;
    self.illnessDesHeight.constant = message.extraModel.illnessDesHeight;
    
    if (message.extraModel.arrayImage.count > 0) {
        [self.image1 sd_setImageWithURL:getImageAddress(message.extraModel.arrayImage[0])  placeholderImage:kDefaultImage];
        self.imageListView.hidden = NO;
        self.imageListViewHeight.constant = message.extraModel.imageListViewHeight;
    }else{
        self.imageListView.hidden = YES;
        self.imageListViewHeight.constant = 0;
    }
    
    if (message.extraModel.arrayImage.count > 1) {
        [self.image2 sd_setImageWithURL:getImageAddress(message.extraModel.arrayImage[1]) placeholderImage:kDefaultImage];
        self.image2.hidden = NO;
    }else{
        self.image2.hidden = YES;
    }
    
    if (message.extraModel.arrayImage.count > 2) {
        [self.image3 sd_setImageWithURL:getImageAddress(message.extraModel.arrayImage[2]) placeholderImage:kDefaultImage];
        self.image3.hidden = NO;
    }else{
        self.image3.hidden = YES;
    }
    
    if (message.extraModel.arrayImage.count > 3) {
        self.imageCountLab.text = [NSString stringWithFormat:@"%li+",message.extraModel.arrayImage.count];
        self.imageCountLab.hidden = NO;
        self.image3.hidden = YES;
    }else{
        self.imageCountLab.hidden = YES;
    }
    
}

- (IBAction)actionImageTap:(UIGestureRecognizer *)tap{
    LZPictureBrowser *pictureVC = [[LZPictureBrowser alloc] init];
    if (self.message.extraModel!=nil) {
        [pictureVC showWithPictureURLs:self.message.extraModel.arrayImage atIndex:tap.view.tag];
    }
 
}

+ (CGFloat)getContentViewSizeWith:(CGFloat)width message:(HOConsultMessage *)message{
    
    NSString * diagnoseStr = message.extraModel.firstIllness;
    CGFloat diagnoseHeight = [StringUtils getAttributedStringSize:message.extraModel.firstConsultationInfo Andwidht:CGSizeMake(width-28, MAXFLOAT)].size.height;
//    [diagnoseStr sizeWithFont:[UIFont systemFontOfSize:15.f]
//                                                  maxW:width-28
//                                                  maxH:MAXFLOAT].height;
    if (diagnoseStr.length == 0) {
        diagnoseHeight = -36;
    }
    message.extraModel.diagnoseViewHeight = diagnoseHeight + 36;
    
    
    NSString * illnessDes = message.extraModel.txt;
    CGFloat illnessDesHeight = [illnessDes sizeWithFont:[UIFont systemFontOfSize:13.f]
                                                         maxW:width-28
                                                         maxH:MAXFLOAT].height;
    illnessDesHeight = MAX(15, illnessDesHeight);
    message.extraModel.illnessDesHeight = illnessDesHeight + 36;
    
    CGFloat imageHeight = (width-80)/3.f;
    if (message.extraModel.arrayImage.count == 0) {
        imageHeight = -33.f;
    }
    message.extraModel.imageListViewHeight = imageHeight + 33;
    
    return diagnoseHeight+illnessDesHeight+imageHeight+206;
}

@end
