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

@interface MainViewController ()
{
    UIView *redView;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    redView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.width, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self performSelector:@selector(test) withObject:nil afterDelay:2.f];
    
    [self test];
}

- (void)test
{
    UIView *snopshotView = [redView snapshotViewAfterScreenUpdates:NO];
    snopshotView.y = 250;
    [self.view addSubview:snopshotView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
