//
//  PushViewController.m
//  BaseDevelop
//
//  Created by leikun on 15-2-4.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "PushViewController.h"
#import "UIView+FrameAdditions.h"
#import "MainViewController.h"
#import "BDNavigationBar.h"
#import "BDNavigationViewController.h"
#import <AddressBook/AddressBook.h>
#import "BDAddressBookPerson.h"
#import "BDAddressBookGroup.h"
#import "BDAddressBookSource.h"

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
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 300, 320, 40);
    [btn1 setTitle:@"present" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    btn1.backgroundColor = [UIColor magentaColor];
}

- (void)btnAction:(id)sender {
    [self test];
//    PushViewController *push = [[PushViewController alloc]init];
//    push.index = _index + 1;
//    [self.navigationController pushViewController:push animated:YES];
}

- (void)btn1Action:(id)sender {
    MainViewController *mainVC = [[MainViewController alloc]init];
    BDNavigationViewController *navi = [[BDNavigationViewController alloc]initWithRootViewController:mainVC];
    [self presentViewController:navi animated:YES completion:NULL];
}

- (void)dismiss:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)test {
    CFErrorRef error = NULL;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(addressBook);
//    ABRecordRef dRecord = NULL;
    
    for (int i=0; i<CFArrayGetCount(records); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(records, i);
        NSArray *values = [BDAddressBookPerson readValueFromRecord:record propertyName:@"phone"];
        NSArray *phones = [values allPersonValueValues];
        NSLog(@"phones = %@", phones);
    }
    CFRelease(addressBook);
}

@end
