//
//  UIApplication+Util.m
//  BaseDevelop
//
//  Created by leikun on 15/5/14.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "UIApplication+Util.h"
#import <objc/message.h>

@implementation UIApplication (Util)

- (UIView *)getTopView {
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[self getUtilName1:YES], [self getUtilName2:YES],[self getUtilName3:YES]];
    id app = [UIApplication sharedApplication];
    id view = objc_msgSend(app, NSSelectorFromString(result));
    return view;
}

//下面几个方法获取我们需要的方法名
- (NSString *)getUtilName1:(BOOL)isTop {
    if (isTop) {
        return @"sta";
    } else {
        return @"k";
    }
}

- (NSString *)getUtilName2:(BOOL)isTop {
    if (isTop) {
        return @"tus";
    } else {
        return @"ey";
    }
}

- (NSString *)getUtilName3:(BOOL)isTop {
    if (isTop) {
        return @"Bar";
    } else {
        return @"Window";
    }
}

@end
