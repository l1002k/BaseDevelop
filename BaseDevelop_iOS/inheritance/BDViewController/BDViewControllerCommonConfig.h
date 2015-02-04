//
//  BDViewControllerCommonConfig.h
//  BaseDevelop
//
//  Created by leikun on 15-2-4.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  This object contain some common config for view controller
 */
@interface BDViewControllerCommonConfig : NSObject

@property(nonatomic) BOOL isStatusBarHidden;       //default NO

@property(nonatomic) UIStatusBarStyle statusBarStyle; //default UIStatusBarStyleDefault


@property(nonatomic) UIStatusBarAnimation statusBarUpdateAnimation;  //default UIStatusBarAnimationNone

@property(nonatomic) NSString *backBarItemTitle;  // default nil


@end
