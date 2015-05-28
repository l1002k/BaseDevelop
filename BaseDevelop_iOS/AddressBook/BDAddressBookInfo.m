//
//  BDAddressBookInfo.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookInfo.h"
#import <AddressBook/AddressBook.h>

@implementation BDAddressBookInfo

- (instancetype)initWithABRecord:(ABRecordRef)record
{
    self = [super init];
    if (self) {
        _recordID = @(ABRecordGetRecordID(record));
        
        _firstName = [self readSingleValueFromRecord:record propertyID:kABPersonFirstNameProperty];
        _lastName = [self readSingleValueFromRecord:record propertyID:kABPersonLastNameProperty];
        _middleName = [self readSingleValueFromRecord:record propertyID:kABPersonLastNameProperty];
        _prefix = [self readSingleValueFromRecord:record propertyID:kABPersonPrefixProperty];
        _suffix = [self readSingleValueFromRecord:record propertyID:kABPersonSuffixProperty];
        _nickName = [self readSingleValueFromRecord:record propertyID:kABPersonNicknameProperty];
        _firstNamePhonetic = [self readSingleValueFromRecord:record propertyID:kABPersonFirstNamePhoneticProperty];
        _lastNamePhonetic = [self readSingleValueFromRecord:record propertyID:kABPersonLastNamePhoneticProperty];
        _middleNamePhonetic = [self readSingleValueFromRecord:record propertyID:kABPersonMiddleNamePhoneticProperty];
        
        _organiztion = [self readSingleValueFromRecord:record propertyID:kABPersonOrganizationProperty];
        _jobTitle = [self readSingleValueFromRecord:record propertyID:kABPersonJobTitleProperty];
        _department = [self readSingleValueFromRecord:record propertyID:kABPersonDepartmentProperty];
        
        _note = [self readSingleValueFromRecord:record propertyID:kABPersonNoteProperty];
        _creationDate = [self readSingleValueFromRecord:record propertyID:kABPersonCreationDateProperty];
        _modificationDate = [self readSingleValueFromRecord:record propertyID:kABPersonModificationDateProperty];
        
        _birthday = [self readSingleValueFromRecord:record propertyID:kABPersonBirthdayProperty];
    }
    return self;
}

- (id)readSingleValueFromRecord:(ABRecordRef)record propertyID:(ABPropertyID)property {
    CFTypeRef ref = ABRecordCopyValue(record, property);
    return CFBridgingRelease(ref);
}

@end
