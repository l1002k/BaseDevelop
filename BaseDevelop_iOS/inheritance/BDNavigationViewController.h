//
//  BDNavigationViewController.h
//  BaseDevelop
//
//  Created by leikun on 15-2-5.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDNavigationViewController : UINavigationController

/**
 *  if self.topViewController isKindOfClass BDViewController, then this message will forward to self.topViewController. or call super method
 *
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
/**
 *  if self.topViewController isKindOfClass BDViewController, then this message will forward to self.topViewController. or call super method
 *
 */
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

/**
 *  以下的方法只会处理相应的push或pop动作，不会把push或pop事件传给对应的view controller
 */
- (void)pushViewControllerDirectly:(UIViewController *)viewController animated:(BOOL)animated;
/**
 *  以下的方法只会处理相应的push或pop动作，不会把push或pop事件传给对应的view controller
 */
- (UIViewController *)popViewControllerDirectlyAnimated:(BOOL)animated;
/**
 *  以下的方法只会处理相应的push或pop动作，不会把push或pop事件传给对应的view controller
 */
- (NSArray *)popToViewControllerDirectly:(UIViewController *)viewController animated:(BOOL)animated;
/**
 *  以下的方法只会处理相应的push或pop动作，不会把push或pop事件传给对应的view controller
 */
- (NSArray *)popToRootViewControllerDirectlyAnimated:(BOOL)animated;

@end
