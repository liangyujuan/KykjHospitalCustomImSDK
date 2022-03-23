//
//  KykjHospitalCustomImSDK-Bridging-Header.h
//  KykjHospitalCustomImSDK
//
//  Created by 梁玉娟 on 2022/2/23.
//

//#ifndef KykjHospitalCustomImSDK_Bridging_Header_h
//#define KykjHospitalCustomImSDK_Bridging_Header_h

#if !defined(UGC) && !defined(PLAYER)
#import <ImSDK/ImSDK.h>
#import <TXLiteAVSDK_TRTC/TXLiteAVSDK.h>
#import "TRTCCalling.h"
//#import "GenerateTestUserSig.h"
#endif

#ifdef ENTERPRISE
@import TXLiteAVSDK_TRTC;
#endif

#if defined(TRTC) && !defined(TRTC_APPSTORE)
@import TXLiteAVSDK_TRTC;
#endif

#ifdef TRTC_APPSTORE
@import TXLiteAVSDK_TRTC;
#endif
