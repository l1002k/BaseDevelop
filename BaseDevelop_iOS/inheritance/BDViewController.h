//
//  BDViewController.h
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDViewController : UIViewController

//-----------------statusBar-------------------------//
- (void)setStatusBarHidden:(BOOL)hidden;
- (void)setStatusBarHidden:(BOOL)hidden withAnimationOnlyOnce:(UIStatusBarAnimation)animation;
- (void)setStatusBarHidden:(BOOL)hidden withAnimationForEver:(UIStatusBarAnimation)animation;
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated;
//-----------------statusBar end---------------------//

//--------------present && dismiss------------------//

/**
 *  The view controllers which is presented by self or self.presentedViewController. except self
 *
 *  @return NSArray<UIViewController *> or nil
 */
- (NSArray *)presentedViewControllers;

/**
 *  The view controllers which present self or self.presentingViewController. except self
 *
 *  @return NSArray<UIViewController *> or nil
 */
- (NSArray *)presentingViewControllers;

//--------------present && dismiss end----------------//

@end
