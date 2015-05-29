//
//  BDAddressBookObject.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef enum {
    BDAddressBookObjectNotDetermined = -1,
    BDAddressBookObjectPerson,
    BDAddressBookObjectGroup,
    BDAddressBookObjectSource
} BDAddressBookObjectType;

@interface BDAddressBookObject : NSObject

@property(nonatomic)NSNumber *recordID;             //唯一标示符

- (instancetype)initWithABRecord:(ABRecordRef)record;

- (BDAddressBookObjectType)objectType;

//根据属性名读返回值
+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName;

@end
