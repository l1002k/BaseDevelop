//
//  MainViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+Util.h"
#import "UIView+FrameAdditions.h"
#import "PushViewController.h"
#import "PresentViewController.h"
#import "BDNavigationViewController.h"
#import <objc/runtime.h>

@interface myObject : NSObject
- (void)test;

@end

@implementation myObject

- (void)test
{
    NSLog(@"myObject");
}

@end

@interface myObject1 : NSObject
- (void)test;

@end

@implementation myObject1

- (void)test
{
    NSLog(@"myObject1");
}

@end

@interface MainViewController ()
{
    BOOL isHidden;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (_index == 0) {
        self.view.backgroundColor = [UIColor magentaColor];
    } else if (_index == 1){
        self.view.backgroundColor = [UIColor blueColor];
    } else if (_index == 2) {
        self.view.backgroundColor = [UIColor orangeColor];
    } else if (_index == 3) {
        self.view.backgroundColor = [UIColor cyanColor];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    self.title = [NSString stringWithFormat:@"main view controller %d",_index];
    
    myObject *object = [myObject new];
    
    
//    const char *subclassName = [@"test_MainViewController" UTF8String];
    Class a = NSClassFromString(@"myObject1");
    object_setClass(object, a);
    
    if ([object respondsToSelector:@selector(test)]) {
        NSLog(@"");
        [object test];
    }
    Class b = object.class;
    Class c = object_getClass(object);
}

- (void)dismiss:(UIBarButtonItem *)sender {
    return;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)statusBarAction:(id)sender {
//    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
//        [self setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    } else {
//        [self setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    }
    if ([UIApplication sharedApplication].statusBarHidden) {
        isHidden = NO;
        [self setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    } else {
        isHidden = YES;
        [self setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (IBAction)presentAction:(id)sender {
    UIViewController *vc = nil;
    if (_index != 1) {
        MainViewController *mainVC = [MainViewController new];
        mainVC.index = _index + 1;
        vc = mainVC;
    } else
    {
        PresentViewController *present = [PresentViewController new];
        vc = present;
    }
    BDNavigationViewController *navi = [[BDNavigationViewController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:NULL];
}

- (IBAction)pushAction:(id)sender {
    PushViewController *push = [PushViewController new];
    [self.navigationController pushViewController:push animated:YES];
}

@end
