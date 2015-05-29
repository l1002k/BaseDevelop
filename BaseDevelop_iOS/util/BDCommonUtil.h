//
//  BDCommonUtil.h
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#ifndef BaseDevelop_BDCommonUtil_h
#define BaseDevelop_BDCommonUtil_h

//-------------------- system version ----------------------------//
#define SystemVersionString [[UIDevice currentDevice] systemVersion]
#define SystemVersionFloat  [[[UIDevice currentDevice] systemVersion] floatValue]

#define SystemVersionEqualTo(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame)

#define SystemVersionHigherThan(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending)
#define SystemVersionlowerThan(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)

#define SystemVersionHigherThanOrEqualTo(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define SystemVersionlowerThanOrEqualTo(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending)
//-------------------- system version end --------------------------//

//-------------------- block call ----------------------------------//
#define SafeBlockCall(block, ...) (block ? block(__VA_ARGS__) : nil)
//-------------------- block call end ------------------------------//

//-------------------- CF object release ------------------------------//
#define CFSafeRelease(cf) (cf != NULL ? CFRelease(cf) : NULL)
//-------------------- CF object release end --------------------------//

#endif
