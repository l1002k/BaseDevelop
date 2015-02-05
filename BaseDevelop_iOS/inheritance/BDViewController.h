//
//  BDViewController.h
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChangeToBDViewController(viewController) ([(viewController) isKindOfClass:BDViewController.class]?((BDViewController *)(viewController)):nil)

/**
 *  对于will和did的push, pop, present, dismiss都遵循要消失的先调，要显示的后调
 */
@interface BDViewController : UIViewController

//-----------------statusBar-------------------------//
- (void)setStatusBarHidden:(BOOL)hidden;
- (void)setStatusBarHidden:(BOOL)hidden withAnimation:(UIStatusBarAnimation)animation;
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated;
//-----------------statusBar end---------------------//

#pragma mark
#pragma mark - new method
/**
 *  只会处理相应的present动作，不会把present事件传给对应的view controller
 */
- (void)presentViewControllerDirectly:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
/**
 *  if you present several modal view controllers in succession, only the top-most view is dismissed in an animated fashion by calling this method.
 *  but in iOS8 self.presentedViewController is dismissed in an animated fashinon.
 *   for example A present B, B present C, C is dismissed without animation.
 *
 *  只会处理相应的present动作，不会把present事件传给对应的view controller
 */
- (void)dismissViewControllerDirectlyAnimated:(BOOL)flag completion:(void (^)(void))completion;
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

#pragma mark
#pragma mark - call when push
/**
 *  在执行push操作的时候被调用，满足下面的调用顺序, 如 A push B, 此时A是pushingViewController, B是pushedViewController。
 *  -[A willPush:B animated:] -> -[B willPushedBy:A animated:] ->
 *  -[A didPush:B animated:] -> -[B didPushedBy:A animated:] ->
 */
- (void)willPush:(BDViewController *)pushedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPush: animated:]
 *
 */
- (void)didPush:(BDViewController *)pushedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPush: animated:]
 *
 */
- (void)willPushedBy:(BDViewController *)pushingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPush: animated:]
 *
 */
- (void)didPushedBy:(BDViewController *)pushingViewController animated:(BOOL)animated;

#pragma mark
#pragma mark - call when pop
/**
 *  在执行pop操作的时候被调用，满足下面的调用顺序, 如 B pop to A, 此时A是pushingViewController, B是pushedViewController。
 *  -[B willPopTo:A animated:] -> -[A willPopFrom:B animated:] ->
 *  -[B didPopTo:A animated:] -> -[A didPopFrom:B animated:] ->
 */
- (void)willPopTo:(BDViewController *)pushingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPopTo: animated:]
 *
 */
- (void)didPopTo:(BDViewController *)pushingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPopTo: animated:]
 *
 */
- (void)willPopFrom:(BDViewController *)pushedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPopTo: animated:]
 *
 */
- (void)didPopFrom:(BDViewController *)pushedViewController animated:(BOOL)animated;

#pragma mark
#pragma mark - call when present
/**
 *  在执行present操作的时候被调用，满足下面的调用顺序, 如 A present B, 此时A是presentingViewController, B是presentedViewController。
 *  -[A willPresent:B animated:] -> -[B willPresentedBy:A animated:] ->
 *  -[A didPresent:B animated:] -> -[B didPresentedBy:A animated:] ->
 */
- (void)willPresent:(BDViewController *)presentedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPresent: animated:]
 *
 */
- (void)didPresent:(BDViewController *)presentedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPresent: animated:]
 *
 */
- (void)willPresentedBy:(BDViewController *)presentingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willPresent: animated:]
 *
 */
- (void)didPresentedBy:(BDViewController *)presentingViewController animated:(BOOL)animated;

#pragma mark
#pragma mark - call when dismiss
/**
 *  在执行present操作的时候被调用，满足下面的调用顺序, 如 B dismiss to A, 此时A是presentingViewController, B是presentedViewController。
 *  -[B willDismissTo:A animated:] -> -[A willDismissedFrom:B animated:] ->
 *  -[B didDismissTo:A animated:] -> -[A didDismissedFrom:B animated:] ->
 */
- (void)willDismissTo:(BDViewController *)presentingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willDismissTo: animated:]
 *
 */
- (void)didDismissTo:(BDViewController *)presentingViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willDismissTo: animated:]
 *
 */
- (void)willDismissedFrom:(BDViewController *)dismissedViewController animated:(BOOL)animated;
/**
 *  参见 -[BDViewController willDismissTo: animated:]
 *
 */
- (void)didDismissedFrom:(BDViewController *)dismissedViewController animated:(BOOL)animated;

@end
