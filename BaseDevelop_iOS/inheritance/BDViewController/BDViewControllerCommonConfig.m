//
//  BDViewControllerCommonConfig.m
//  BaseDevelop
//
//  Created by leikun on 15-2-4.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDViewControllerCommonConfig.h"

@implementation BDViewControllerCommonConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isStatusBarHidden = NO;
        _statusBarStyle = UIStatusBarStyleDefault;
        _statusBarUpdateAnimation = UIStatusBarAnimationNone;
    }
    return self;
}

@end
