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
#import "BDAddressBookManager.h"
#import "BDAddressBookPerson.h"

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
}

- (void)dismiss:(UIBarButtonItem *)sender {
//    [self dismissViewControllerAnimated:YES completion:NULL];
    BDAddressBookManager *manager = [[BDAddressBookManager alloc] init];
    [manager performABOperationBlockInABOQ:^(ABAddressBookRef addressBookRef, NSError *error) {
        if (error == nil) {
            NSArray *persons = [manager getAllPersonInAddressBookRef:addressBookRef];
            NSMutableArray *modifyPersons = [NSMutableArray array];
            for(BDAddressBookPerson *person in persons) {
                NSMutableArray *phone = [NSMutableArray arrayWithArray:person.phone];
                BDAddressBookPersonValueInfo *phoneItem = [[BDAddressBookPersonValueInfo alloc]init];
                phoneItem.labelKey = (__bridge NSString *)kABPersonPhoneIPhoneLabel;
                phoneItem.value = @"123456789";
                [phone addObject:phoneItem];
                
                BDAddressBookPerson *updatePerson =  [[BDAddressBookPerson alloc]init];
                updatePerson.recordID = person.recordID;
                updatePerson.phone = phone;
                [modifyPersons addObject:updatePerson];
                
                BDAddressBookPerson *addPerson = [[BDAddressBookPerson alloc]init];
                [addPerson mergeFromUpdatePerson:person];
                [modifyPersons addObject:addPerson];
            }
            error = [manager addOrUpdateAddressBookPersons:modifyPersons addressBookRef:addressBookRef];
        }
    }];
}

- (IBAction)statusBarAction:(id)sender {
//    if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
//        [self setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    } else {
//        [self setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    }
    if ([UIApplication sharedApplication].statusBarHidden) {
        isHidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    } else {
        isHidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
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
