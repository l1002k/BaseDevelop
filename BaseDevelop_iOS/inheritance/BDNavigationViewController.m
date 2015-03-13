//
//  BDNavigationViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-5.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDNavigationViewController.h"
#import "BDViewController.h"

@interface BDNavigationViewController () <UINavigationBarDelegate>
{
    BOOL _isPushOrPopAnimated;
}

@end

@implementation BDNavigationViewController

#pragma mark
#pragma mark - override dismiss & present method
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *topViewController = self.topViewController;
    if (topViewController && [topViewController isKindOfClass:BDViewController.class]) {
        [topViewController dismissViewControllerAnimated:flag completion:completion];
    } else {
        NSAssert(NO, @"Application tried to dismiss a model view controller but the topViewController is %@, this behavior may cause unsafe action", topViewController);
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *topViewController = self.topViewController;
    if (topViewController && [topViewController isKindOfClass:BDViewController.class]) {
        [topViewController presentViewController:viewControllerToPresent animated:flag completion:completion];
    } else {
        NSAssert(NO, @"Application tried to present a model view controller but the topViewController is %@, this behavior may cause unsafe action", topViewController);
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}

#pragma mark
#pragma mark - custom push & pop method
- (void)pushViewControllerDirectly:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == nil || ![viewController isKindOfClass:UIViewController.class]) {
        NSAssert(NO, @"Application tried to push a nil view controller %@ or unknown object on target %@", viewController, self);
        return;
    }
    if (_isPushOrPopAnimated) {
        NSAssert(NO, @"Application tried to push a view controller when push or pop annimation is running");
        return;
    }
    _isPushOrPopAnimated = YES;
    [CATransaction begin];
    [super pushViewController:viewController animated:animated];
    [CATransaction setCompletionBlock:^{
        _isPushOrPopAnimated = NO;
    }];
    [CATransaction commit];
}

- (UIViewController *)popViewControllerDirectlyAnimated:(BOOL)animated {
    if (self.viewControllers.count <= 1) {
        NSAssert(NO, @"Application tried to pop a view controller but there is less than 2 view controller on target %@", self);
    }
    if (_isPushOrPopAnimated) {
        NSAssert(NO, @"Application tried to push a view controller when push or pop annimation is running");
        return nil;
    }
    _isPushOrPopAnimated = YES;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _isPushOrPopAnimated = NO;
    }];
    UIViewController *result = [super popViewControllerAnimated:animated];
    [CATransaction commit];
    return result;
}

- (NSArray *)popToViewControllerDirectly:(UIViewController *)viewController animated:(BOOL)animated {
    if (![self.viewControllers containsObject:viewController]) {
        NSAssert(NO, @"Application tried to pop to a view controller which don't contain in the stack on target %@", self);
        return nil;
    }
    if (_isPushOrPopAnimated) {
        NSAssert(NO, @"Application tried to push a view controller when push or pop annimation is running");
        return nil;
    }
    _isPushOrPopAnimated = YES;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _isPushOrPopAnimated = NO;
    }];
    NSArray *result = [super popToViewController:viewController animated:animated];
    [CATransaction commit];
    return result;
}

- (NSArray *)popToRootViewControllerDirectlyAnimated:(BOOL)animated {
    if (self.viewControllers.count <= 1) {
        NSAssert(NO, @"Application tried to pop to root view controller but there is less than 2 view controller on target %@", self);
    }
    if (_isPushOrPopAnimated) {
        NSAssert(NO, @"Application tried to push a view controller when push or pop annimation is running");
        return nil;
    }
    _isPushOrPopAnimated = YES;
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        _isPushOrPopAnimated = NO;
    }];
    NSArray *result = [super popToRootViewControllerAnimated:animated];
    [CATransaction commit];
    return result;
}

#pragma mark
#pragma mark - override push & pop method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BDViewController *fromVC = nil;
    BDViewController *toVC = nil;
    if (viewController && [viewController isKindOfClass:UIViewController.class]) {
        fromVC = ChangeToBDViewController(self.topViewController);
        toVC = ChangeToBDViewController(viewController);
    }
    
    [fromVC willTransitionTo:toVC actionType:BDViewControllerTransitionPush animated:animated];
    [toVC willTransitionedFrom:fromVC actionType:BDViewControllerTransitionPush animated:animated];
    
    [CATransaction begin];
    [self pushViewControllerDirectly:viewController animated:animated];
    [CATransaction setCompletionBlock:^{
        [fromVC didTransitionTo:toVC actionType:BDViewControllerTransitionPush animated:animated];
        [toVC didTransitionedFrom:fromVC actionType:BDViewControllerTransitionPush animated:animated];
    }];
    [CATransaction commit];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    BDViewController *fromVC = nil;
    BDViewController *toVC = nil;
    if (self.viewControllers.count > 1) {
        fromVC = ChangeToBDViewController(self.topViewController);
        toVC = ChangeToBDViewController(self.viewControllers[self.viewControllers.count - 2]);
    }
    
    [fromVC willTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
    [toVC willTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    
    [CATransaction begin];
    UIViewController *fromViewController = [self popViewControllerDirectlyAnimated:animated];
    [CATransaction setCompletionBlock:^{
        [fromVC didTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
        [toVC didTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    }];
    [CATransaction commit];
    return fromViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BDViewController *fromVC = nil;
    BDViewController *toVC = nil;
    if ([self.viewControllers containsObject:viewController]) {
        fromVC = ChangeToBDViewController(self.topViewController);
        toVC = ChangeToBDViewController(viewController);
    }
    
    [fromVC willTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
    [toVC willTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    
    [CATransaction begin];
    NSArray *fromViewControllers = [self popToViewControllerDirectly:viewController animated:animated];
    [CATransaction setCompletionBlock:^{
        [fromVC didTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
        [toVC didTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    }];
    [CATransaction commit];
    return fromViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    BDViewController *fromVC = nil;
    BDViewController *toVC = nil;
    if (self.viewControllers.count > 1) {
        fromVC = ChangeToBDViewController(self.topViewController);
        toVC = ChangeToBDViewController(self.viewControllers[0]);
    }
    
    [fromVC willTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
    [toVC willTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    
    [CATransaction begin];
    NSArray *fromViewControllers = [self popToRootViewControllerDirectlyAnimated:animated];
    [CATransaction setCompletionBlock:^{
        [fromVC didTransitionTo:toVC actionType:BDViewControllerTransitionPop animated:animated];
        [toVC didTransitionedFrom:fromVC actionType:BDViewControllerTransitionPop animated:animated];
    }];
    [CATransaction commit];
    return fromViewControllers;
}

@end
