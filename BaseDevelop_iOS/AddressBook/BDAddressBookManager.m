//
//  BDAddressBookManager.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookManager.h"
#import <AddressBook/AddressBook.h>
#import "BDCommonUtil.h"
#import "BDAddressBookPerson.h"

static void *const BDAddressBookManagerQueueKey = (void *)&BDAddressBookManagerQueueKey;

@interface BDAddressBookManager () {
    dispatch_queue_t _addressBookQueue;
    BOOL isGranted;
}

@end

@implementation BDAddressBookManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _addressBookQueue = dispatch_queue_create("BDAddressBookManagerQueue", NULL);
        dispatch_queue_set_specific(_addressBookQueue, BDAddressBookManagerQueueKey, (__bridge void*)self, NULL);
    }
    return self;
}

- (void)test {
    [self safeRunAddressBookBlock:^(ABAddressBookRef ref, NSError* error) {
        CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(ref);
        for (int i=0; i<CFArrayGetCount(records); i++) {
            ABRecordRef record = CFArrayGetValueAtIndex(records, i);
            NSArray *values = [BDAddressBookPerson readValueFromRecord:record propertyName:@"phone"];
            NSArray *phones = [values allPersonValueValues];
            NSLog(@"phones = %@", phones);
        }
        CFSafeRelease(records);
    }];
}

#pragma mark - dispatch queue
- (void)safeRunBlock:(void(^)())block {
    if (dispatch_get_specific(BDAddressBookManagerQueueKey) != NULL) {
        SafeBlockCall(block);
    } else {
        dispatch_sync(_addressBookQueue, block);
    }
}

#pragma mark - ABAddressBook
- (ABAddressBookRef)addressBookRef {
    NSAssert(dispatch_get_specific(BDAddressBookManagerQueueKey) != NULL, @"use addressBookRef must in _addressBookQueue");
    static ABAddressBookRef addressBookRef;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CFErrorRef error = NULL;
        addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
        NSAssert(error == nil, @"create address book ref error : %@",(__bridge NSError *)error);
    });
    return addressBookRef;
}

- (NSError *)requestAccessWithAddressBook {
    NSAssert(dispatch_get_specific(BDAddressBookManagerQueueKey) != NULL, @"requestAccessWithAddressBook must in _addressBookQueue");
    __block NSError *accessError = nil;
    if (!isGranted) {
        __block BOOL isAccess  = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
            isAccess = granted;
            accessError = (__bridge NSError *)error;
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        isGranted = isAccess;
    }
    return accessError;
}

- (void)safeRunAddressBookBlock:(void(^)(ABAddressBookRef ref, NSError* error))addressBookBlock {
    __weak typeof(self) weakSelf = self;
    void(^ block)() = ^(){
        addressBookBlock(self.addressBookRef, [weakSelf requestAccessWithAddressBook]);
    };
    [self safeRunBlock:block];
}

@end
