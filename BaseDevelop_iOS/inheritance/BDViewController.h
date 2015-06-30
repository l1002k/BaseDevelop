//
//  BDViewController.h
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ChangeToBDViewController(viewController) ([(viewController) isKindOfClass:BDViewController.class]?((BDViewController *)(viewController)):nil)

typedef enum {
    BDViewControllerTransitionPush,
    BDViewControllerTransitionPop,
    BDViewControllerTransitionPopCancelled,
    BDViewControllerTransitionPresent,
    BDViewControllerTransitionDismiss
} BDViewControllerTransitionType;

@interface BDViewController : UIViewController

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
#pragma mark - transition method
/**
 *  在执行页面切换操作的时候被调用，现在支持push, pop, present, dismiss. 如 A transition ro  B, 此时A是fromViewController, B是toViewController。满足下面的调用顺序:
 *  -[A willTransitionTo:B actionType: animated:] -> -[B willTransitionedFrom:A actionType: animated:] ->
 *  -[A didTransitionTo:B actionType: animated:] -> -[B didTransitionedFrom:A actionType: animated:]
 */
- (void)willTransitionTo:(BDViewController *)toViewController actionType:(BDViewControllerTransitionType)type animated:(BOOL)animated;
/**
 *  在执行页面切换操作的时候被调用，现在支持push, pop, present, dismiss. 如 A transition ro  B, 此时A是fromViewController, B是toViewController。满足下面的调用顺序:
 *  -[A willTransitionTo:B actionType: animated:] -> -[B willTransitionedFrom:A actionType: animated:] ->
 *  -[A didTransitionTo:B actionType: animated:] -> -[B didTransitionedFrom:A actionType: animated:]
 */
- (void)willTransitionedFrom:(BDViewController *)fromViewController actionType:(BDViewControllerTransitionType)type animated:(BOOL)animated;
/**
 *  在执行页面切换操作的时候被调用，现在支持push, pop, present, dismiss. 如 A transition ro  B, 此时A是fromViewController, B是toViewController。满足下面的调用顺序:
 *  -[A willTransitionTo:B actionType: animated:] -> -[B willTransitionedFrom:A actionType: animated:] ->
 *  -[A didTransitionTo:B actionType: animated:] -> -[B didTransitionedFrom:A actionType: animated:]
 */
- (void)didTransitionTo:(BDViewController *)toViewController actionType:(BDViewControllerTransitionType)type animated:(BOOL)animated;
/**
 *  在执行页面切换操作的时候被调用，现在支持push, pop, present, dismiss. 如 A transition ro  B, 此时A是fromViewController, B是toViewController。满足下面的调用顺序:
 *  -[A willTransitionTo:B actionType: animated:] -> -[B willTransitionedFrom:A actionType: animated:] ->
 *  -[A didTransitionTo:B actionType: animated:] -> -[B didTransitionedFrom:A actionType: animated:]
 */
- (void)didTransitionedFrom:(BDViewController *)fromViewController actionType:(BDViewControllerTransitionType)type animated:(BOOL)animated;

@end
