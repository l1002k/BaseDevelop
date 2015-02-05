//
//  MainViewController.h
//  BaseDevelop
//
//  Created by leikun on 15-2-3.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDViewController.h"

@interface MainViewController : BDViewController

@property(nonatomic) int index;

- (IBAction)statusBarAction:(id)sender;
- (IBAction)presentAction:(id)sender;
- (IBAction)pushAction:(id)sender;

@end
