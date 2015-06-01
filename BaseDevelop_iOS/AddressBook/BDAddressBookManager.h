//
//  BDAddressBookManager.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef enum {
    BDABMAuthorizationError,
    BDABMCreateAddressBookError,
    BDABMRequestAccessError,
    BDABMSaveAddressBookError,
    BDABMBackupIllegalCachePathError,
    BDABMReBackupCacheNotExistsError
} BDABMErrorCode;

typedef void (^BDABMAddressBookOperationBlock)(ABAddressBookRef addressBookRef, NSError *error);
typedef void (^BDABMAddressBookCompletionBlock)(NSError *error);

@interface BDAddressBookManager : NSObject

//异步备份addressBook
- (void)backupAddressBookToPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock;
//异步还原addressBook
- (void)reBackupAddressBookFromPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock;

//在addresBook线程运行operationBlock
- (void)performABOperationBlockInABOQ:(BDABMAddressBookOperationBlock)operationBlock;

@end
