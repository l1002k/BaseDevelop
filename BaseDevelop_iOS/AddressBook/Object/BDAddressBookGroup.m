//
//  BDAddressBookGroup.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookGroup.h"
#import "BDAddressBookPerson.h"
#import "NSObject+Property.h"
#import "BDCommonUtil.h"

@implementation BDAddressBookGroup

- (BDAddressBookObjectType)objectType {
    return BDAddressBookObjectGroup;
}

#pragma mark - 读取属性
+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    ABRecordType type = ABRecordGetRecordType(record);
    if (type != kABGroupType) {
        NSAssert(NO, @"record的type类型不是kABGroupType");
        return nil;
    }
    
    if ([propertyName isEqualToString:@"recordID"]) {
        return [super readValueFromRecord:record propertyName:propertyName];
    } else if ([propertyName isEqualToString:@"groupName"]) {
        return CFBridgingRelease(ABRecordCopyValue(record, kABGroupNameProperty));
    } else {
        return [self readPersons:record];
    }
}

+ (NSArray *)readPersons:(ABRecordRef)record {
    NSMutableArray *result = [NSMutableArray array];
    
    CFArrayRef arrayRef = ABGroupCopyArrayOfAllMembers(record);
    for (int i=0; i<CFArrayGetCount(arrayRef); i++) {
        ABRecordRef record = CFArrayGetValueAtIndex(arrayRef, i);
        BDAddressBookPerson *person = [[BDAddressBookPerson alloc]initWithABRecord:record];
        [result addObject:person];
    }
    CFSafeRelease(arrayRef);
    return result.count > 0 ? result : nil;
}

@end
