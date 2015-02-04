//
//  BDViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDViewController.h"
#import "UIView+Util.h"
#import "BDCommonUtil.h"
#import "BDViewControllerCommonConfig.h"

@interface BDViewController () {
    BDViewControllerCommonConfig *_commonConfig;
}

@end

@implementation BDViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init common config for view controller
        _commonConfig = [[BDViewControllerCommonConfig alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark
#pragma mark - statusBar
- (void)setStatusBarHidden:(BOOL)hidden {
    [self setStatusBarHidden:hidden withAnimationOnlyOnce:UIStatusBarAnimationNone];
}

- (void)setStatusBarHidden:(BOOL)hidden withAnimationOnlyOnce:(UIStatusBarAnimation)animation {
    _commonConfig.isStatusBarHidden = hidden;
    UIStatusBarAnimation oldAnimation = _commonConfig.statusBarUpdateAnimation;
    _commonConfig.statusBarUpdateAnimation = animation;
    [self setNeedsStatusBarAppearanceUpdateAnimated:(animation != UIStatusBarAnimationNone) completion:NULL];
    _commonConfig.statusBarUpdateAnimation = oldAnimation;
}

- (void)setStatusBarHidden:(BOOL)hidden withAnimationForEver:(UIStatusBarAnimation)animation {
    _commonConfig.isStatusBarHidden = hidden;
    _commonConfig.statusBarUpdateAnimation = animation;
    [self setNeedsStatusBarAppearanceUpdateAnimated:(animation != UIStatusBarAnimationNone) completion:NULL];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    [self setStatusBarStyle:statusBarStyle animated:NO];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated {
    _commonConfig.statusBarStyle = statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdateAnimated:animated completion:NULL];
}

- (void)setNeedsStatusBarAppearanceUpdateAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView animateWithDuration:animated?0.2f:0.f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - override UIViewController statusBar config
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _commonConfig.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return _commonConfig.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return _commonConfig.statusBarUpdateAnimation;
}

#pragma mark
#pragma mark - present && dismiss
/**
 *  if you present several view controllers in succession, only the top-most view is dismissed in an animated fashion by calling this method.
 *  but in iOS8 self.presentedViewController is dismissed in an animated fashinon.
 *   for example A present B, B present C, C is dismissed without animation.
 *
 */
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (flag && SystemVersionHigherThanOrEqualTo(@"8.0") && ([[self presentedViewControllers] count] > 1)) {
        UIViewController *topPresentedViewController = [[self presentedViewControllers] lastObject];
        UIView *topPresentedView = [topPresentedViewController.view getSnapshotView];
        [self.presentedViewController.view addSubview:topPresentedView];
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (NSArray *)presentedViewControllers {
    NSMutableArray *presentedVCs = [NSMutableArray array];
    
    for (UIViewController *presentedVC = self.presentedViewController; presentedVC != nil; presentedVC = presentedVC.presentedViewController) {
        [presentedVCs addObject:presentedVC];
    }
    if (presentedVCs.count) {
        return presentedVCs;
    } else {
        return nil;
    }
}

- (NSArray *)presentingViewControllers {
    NSMutableArray *presentingVCs = [NSMutableArray array];
    
    for (UIViewController *presentingVC = self.presentingViewController; presentingVC != nil; presentingVC = presentingVC.presentingViewController) {
        [presentingVCs addObject:presentingVC];
    }
    if (presentingVCs.count) {
        return presentingVCs;
    } else {
        return nil;
    }
}

@end
