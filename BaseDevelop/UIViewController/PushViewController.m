//
//  PushViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-4.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "PushViewController.h"
#import "UIView+FrameAdditions.h"

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [NSString stringWithFormat:@"push view controller %d",_index];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor magentaColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = self.title;
    [self.view addSubview:label];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 200, 320, 40);
    [btn setTitle:@"push" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor magentaColor];
}

- (void)btnAction:(id)sender {
    PushViewController *push = [[PushViewController alloc]init];
    push.index = _index + 1;
    [self.navigationController pushViewController:push animated:YES];
}

- (void)dismiss:(UIBarButtonItem *)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    PushViewController *vc = [PushViewController new];
    vc.index = 10;
    [self.navigationController popToViewController:nil animated:YES];
}

@end
