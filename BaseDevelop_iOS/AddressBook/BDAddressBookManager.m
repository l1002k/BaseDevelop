//
//  BDAddressBookManager.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookManager.h"
#import "BDCommonUtil.h"
#import "NSString+FileManager.h"
#import "NSObject+PerformBlock.h"

static void *const BDAddressBookManagerOperationQueueKey = (void *)&BDAddressBookManagerOperationQueueKey;

@interface BDAddressBookManager ()

@end

@implementation BDAddressBookManager

- (void)backupAddressBookToPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock {
    if ([path hasPrefix:[NSString HomePath]]) {
        NSThread *callThead = [NSThread currentThread];
        [self performABOperationBlockInABOQ:^(ABAddressBookRef addressBookRef, NSError *error) {
            if (!error) {
                CFArrayRef persons = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                CFDataRef vcardDataRef = ABPersonCreateVCardRepresentationWithPeople(persons);
                CFSafeRelease(persons);
                NSData *vcardData = CFBridgingRelease(vcardDataRef);
                [vcardData writeToFile:path atomically:YES];
            }
            [self performBlock:^{
                SafeBlockCall(completionBlock, error);
            } onThread:callThead waitUntilDone:YES];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"要缓存的路径不合法" code:BDABMReBackupCacheNotExistsError userInfo:nil];
        SafeBlockCall(completionBlock, error);
        NSAssert([path hasPrefix:[NSString HomePath]], @"非法的备份路径：%@", path);
    }
}

- (void)reBackupAddressBookFromPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock {
    if ([path isFileExists]) {
        NSThread *callThead = [NSThread currentThread];
        [self performABOperationBlockInABOQ:^(ABAddressBookRef addressBookRef, NSError *error) {
            if (!error) {
                CFArrayRef persons = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
                if (CFArrayGetCount(persons)) {
                }
            }
            [self performBlock:^{
                SafeBlockCall(completionBlock, error);
            } onThread:callThead waitUntilDone:YES];
        }];
    } else {
        NSError *error = [NSError errorWithDomain:@"还原路径不存在" code:BDABMReBackupCacheNotExistsError userInfo:nil];
        SafeBlockCall(completionBlock, error);
        NSAssert([path isFileExists], @"还原路径不存在：%@", path);
    }
}

#pragma mark - 内部方法
//线程和访问权限的整合，operationBlock专注业务代码
- (void)performABOperationBlockInABOQ:(BDABMAddressBookOperationBlock)operationBlock {
    ABAuthorizationStatus status = [self addressBookAuthorizedStatus];
    //如果未被授权或受限的访问权限，则直接返回
    if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
        operationBlock (NULL, [NSError errorWithDomain:@"未被授权访问通讯录" code:BDABMAuthorizationError userInfo:nil]);
    } else {
        [self performSafeBlockInABOperationQueue:^{
            NSError *error = nil;
            ABAddressBookRef addressBookRef = [self createAddressBookRef:&error];
            if (!error) {
                error = [self requestAccessWithAddressBook:addressBookRef];
                error = error ? [NSError errorWithDomain:@"申请通讯录访问权限失败" code:BDABMRequestAccessError userInfo:@{@"sourceError":error}] : error;
            } else {
                error = [NSError errorWithDomain:@"创建通信录失败" code:BDABMCreateAddressBookError userInfo:@{@"sourceError":error}];
            }
            SafeBlockCall(operationBlock, addressBookRef, error);
            CFSafeRelease(addressBookRef);
        }];
    }
}

#pragma mark - dispatch queue
- (dispatch_queue_t)addressBookOperationQueue {
    //确保operationQueue只有一个，保证对addressBook的操作都是串行的。
    static dispatch_queue_t addressBookOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        addressBookOperationQueue = dispatch_queue_create("BDAddressBookManagerQueue", NULL);
        dispatch_queue_set_specific(addressBookOperationQueue, BDAddressBookManagerOperationQueueKey, BDAddressBookManagerOperationQueueKey, NULL);
    });
    return addressBookOperationQueue;
}

- (void)performSafeBlockInABOperationQueue:(void(^)())block {
    if (dispatch_get_specific(BDAddressBookManagerOperationQueueKey) != NULL) {
        SafeBlockCall(block);
    } else {
        dispatch_async([self addressBookOperationQueue], block);
    }
}

#pragma mark - ABAddressBook
// 获取对联系人的授权状态
- (ABAuthorizationStatus) addressBookAuthorizedStatus {
    return ABAddressBookGetAuthorizationStatus();
}

//新建一个addressBook的句柄，使用的时候注意释放
- (ABAddressBookRef) createAddressBookRef:(NSError **)error {
    CFErrorRef errorRef = NULL;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &errorRef);
    if (error) {
        *error = CFBridgingRelease(errorRef);
    }
    return addressBookRef;
}

//请求访问权限
- (NSError *)requestAccessWithAddressBook:(ABAddressBookRef)addressBookRef {
    __block NSError *accessError = nil;
    //请求访问权限是一个异步过程，转成同步执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
        accessError = (__bridge NSError *)error;
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return accessError;
}

@end
