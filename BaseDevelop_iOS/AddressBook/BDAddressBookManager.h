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
    BDABMReBackupCacheNotExistsError,
    BDABMAddOrUpdateRecordError
} BDABMErrorCode;

typedef void (^BDABMAddressBookOperationBlock)(ABAddressBookRef addressBookRef, NSError *error);
typedef void (^BDABMAddressBookCompletionBlock)(NSError *error);

/*
 *  调用示例
 *     
 *      BDAddressBookManager *manager = [[BDAddressBookManager alloc] init];
 *      [manager performABOperationBlockInABOQ:^(ABAddressBookRef addressBookRef, NSError *error) {
 *          if (error == nil) {
 *              NSArray *persons = [manager getAllPersonInAddressBookRef:addressBookRef];
 *          }
 *       }];
 *
 *
 */

@interface BDAddressBookManager : NSObject

//异步备份addressBook
- (void)backupAddressBookToPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock;
//异步还原addressBook
- (void)reBackupAddressBookFromPath:(NSString *)path completion:(BDABMAddressBookCompletionBlock)completionBlock;

//把ABAddressBookCopyArrayOfAllPeople拿到的所有数据转换成NSArray<BDAddressBookPerson *>
- (NSArray *)getAllPersonInAddressBookRef:(ABAddressBookRef)addressBookRef;
/*
 * 添加或更新BDAddressBookPerson, persons为NSArray<BDAddressBookPerson *>,
 * 如果BDAddressBookPerson的recordID!=nil做更新操作，否则添加操作
 */
- (NSError *)addOrUpdateAddressBookPersons:(NSArray *)persons addressBookRef:(ABAddressBookRef)addressBookRef;

//在addresBook线程运行operationBlock
- (void)performABOperationBlockInABOQ:(BDABMAddressBookOperationBlock)operationBlock;

@end
