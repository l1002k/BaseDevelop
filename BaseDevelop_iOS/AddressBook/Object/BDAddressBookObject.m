//
//  BDAddressBookObject.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookObject.h"
#import "NSObject+Property.h"

@implementation BDAddressBookObject

- (instancetype)initWithABRecord:(ABRecordRef)record
{
    self = [super init];
    if (self) {
        ABRecordType type = ABRecordGetRecordType(record);
        if (type != self.objectType) {
            NSAssert(NO, @"传入的ABRecordRef类型不正确, type : %@", @(type));
            return nil;
        }
        NSArray *propertyNames = [self allPropertyNamesExceptNSObject];
        for(NSString *propertyName in propertyNames) {
            id propertyValue = [self.class readValueFromRecord:record propertyName:propertyName];
            [self setValue:propertyValue forKey:propertyName];
        }
    }
    return self;
}

- (BDAddressBookObjectType)objectType {
    [self doesNotRecognizeSelector:_cmd];
    return BDAddressBookObjectNotDetermined;
}

+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"recordID"]) {
        return [self readRecordID:record];
    } else {
        [self doesNotRecognizeSelector:_cmd];
    }
    return nil;
}

//读取唯一标示符
+ (NSNumber *)readRecordID:(ABRecordRef)record {
    return @(ABRecordGetRecordID(record));
}

@end
