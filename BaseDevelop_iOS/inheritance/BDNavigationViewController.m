//
//  BDNavigationViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-5.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDNavigationViewController.h"
#import "BDViewController.h"

#define ChangeToBDViewController(viewController) ([viewController isKindOfClass:BDViewController.class]?((BDViewController *)viewController):nil)

@interface BDNavigationViewController () <UINavigationBarDelegate>

@end

@implementation BDNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - override push & pop method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BDViewController *fromVC = ChangeToBDViewController(self.topViewController);
    BDViewController *toVC = ChangeToBDViewController(viewController);
    
    [fromVC willPush:viewController animated:animated];
    [toVC willPushedBy:fromVC animated:animated];
    
    [CATransaction begin];
    [super pushViewController:viewController animated:animated];
    [CATransaction setCompletionBlock:^{
        [fromVC didPush:viewController animated:animated];
        [toVC didPushedBy:fromVC animated:animated];
    }];
    [CATransaction commit];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [CATransaction begin];
    UIViewController *fromViewController = [super popViewControllerAnimated:animated];
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@", fromViewController);
    }];
    [CATransaction commit];
    return fromViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [CATransaction begin];
    NSArray *fromViewControllers = [super popToViewController:viewController animated:animated];
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@", fromViewControllers);
    }];
    [CATransaction commit];
    return fromViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    [CATransaction begin];
    NSArray *fromViewControllers = [super popToRootViewControllerAnimated:animated];
    [CATransaction setCompletionBlock:^{
        NSLog(@"%@", fromViewControllers);
    }];
    [CATransaction commit];
    return fromViewControllers;
}

@end
