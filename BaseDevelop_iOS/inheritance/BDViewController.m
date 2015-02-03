//
//  BDViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDViewController.h"
#import "UIView+Util.h"

@interface BDViewController ()

@end

@implementation BDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    BOOL isGreaterThanIOS8 = [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch];
    if (flag && isGreaterThanIOS8 && ([[self presentedViewControllers] count] > 1)) {
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
