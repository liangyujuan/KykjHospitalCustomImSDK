//
//  Factory.h
//  StatementManager
//
//  Created by KuaiYi on 2020/3/4.
//  Copyright © 2020 panchenglei. All rights reserved.
//

#ifndef Factory_h
#define Factory_h

#import "UILabel+Factory.h"
#import "UIButton+Factory.h"
//#import "UITextField+Factory.h"
#import "UITableView+Factory.h"
#import "YXBaseViewController.h"
#import "HttpOperationManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/SDWebImage.h>

#import "UINavigationBar+Awesome.h"
#import "KykjImToolkit.h"

#import "YXOrderRecordModel.h"
#import "HttpOperationManager.h"
//#import "MJExtension/MJExtension.h"
#import "LeafNotification.h"
#import "StringUtils.h"
#import "LYEmptyView.h"
#import "UINavigationBar+Awesome.h"
#import "LYJAlertView.h"


#define ScreenRect                [[UIScreen mainScreen] bounds]
#define ScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight              [[UIScreen mainScreen] bounds].size.height
#define StatuBarHeight            [[UIApplication sharedApplication] statusBarFrame].size.height
//非刘海机型statuBar高度为20，刘海机型statuBar高度为40，这里判读大于21为刘海机型
#define TabBarHeight              (StatuBarHeight > 21? 83.f:49.f)
#define NavStaHeight              (StatuBarHeight+44.f)

/**
获取颜色
@param rgbValue 0x999999
@return UIColor
*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]

#define colorTheme RGB(1, 184, 145)
#define colorBackground RGB(249, 249, 249)

#define kDefaultImage [KykjImToolkit getImageResourceForName:@"defaultImage"]


//weak 指针
#define WS(weakself)  __weak __typeof(&*self)weakself = self;

#define isWeakself(weakself)  if (!weakself) {return ;}

//strong 指针
#define SS(strongself)  __strong __typeof(&*weakself)strongself = weakself;

#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif


//MBProgressHUD 快捷使用
#define MBProgressHUDShowInThisView if(![MBProgressHUD HUDForView:self.view])[MBProgressHUD showHUDAddedTo:self.view animated:YES]

//#define MBProgressHUDHideAllInThisView(weakself) [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES]

typedef NS_ENUM(NSUInteger, EMREditViewType) {
    EMREditViewAdultWomanNormalType = 0,//成年女性，不展示月经史详情部分，只展示婚育史
    EMREditViewAdultWomanMonthliesType = 1,//成年女性，展示月经史详情部分，婚育史
    EMREditViewAdultManType = 2,//成年男性，
    EMREditViewChildrenWomanNormalType = 3,//小于十四岁女性，不展示月经史详情部分，只展示个人史
    EMREditViewChildrenWomanMonthliesType = 4,//小于十四岁女性，展示月经史详情部分，个人史
    EMREditViewChildrenManType = 5 //小于14岁男性
};

#define RegWayCode @"HLW_DOCTOR_IOS"

#define VersionNumber [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]//当前版本号


static NSString *const kIMRCUserInfoRefresh      =     @"kIMRCUserInfoRefresh";

#endif /* Factory_h */
