//
//  HODrugRecipeMessageContentView.m
//  HospitalOnline
//
//  Created by cc_yunxin on 2020/4/7.
//  Copyright © 2020 cc. All rights reserved.
//

#import "HODrugRecipeMessageContentView.h"
#import "NSString+Extension.h"
#import "KykjImToolkit.h"

@interface HODrugRecipeMessageContentView ()

@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UIImageView *patientSex;
@property (weak, nonatomic) IBOutlet UILabel *patientAge;
@property (weak, nonatomic) IBOutlet UILabel *lastDiagnose;
@property (weak, nonatomic) IBOutlet UILabel *messageTypeLab;

@end

@implementation HODrugRecipeMessageContentView

- (IBAction)checkShowDrugDetail:(id)sender {
}

- (void)setMessage:(HOMedrMessage *)message{
    _message = message;
    
    self.patientName.text = message.extraModel.name;
    self.patientSex.image = message.extraModel.sex.intValue==2?[KykjImToolkit getImageResourceForName:@"PL_woman"]: [KykjImToolkit getImageResourceForName:@"PL_man_ic"];
    self.patientAge.text = [NSString stringWithFormat:@"%@岁",message.extraModel.age];
    self.lastDiagnose.text = message.extraModel.diagnose;
    self.messageTypeLab.text = @"电子报告";
}

+ (CGFloat)getContentViewSizeWith:(CGFloat)width message:(HOMedrMessage *)message{
    
    NSString * diagnoseStr = message.extraModel.diagnose;
    CGFloat diagnoseHeight = [diagnoseStr sizeWithFont:[UIFont systemFontOfSize:13.f]
                                                  maxW:width-44
                                                  maxH:MAXFLOAT].height;
    diagnoseHeight = MAX(18, diagnoseHeight);
    return diagnoseHeight+169.f;
}
@end
