//
//  BDAddressBookSource.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookSource.h"
#import "NSObject+Property.h"
#import "BDCommonUtil.h"
#import "BDAddressBookGroup.h"

@implementation BDAddressBookSource

- (instancetype)initWithABRecord:(ABRecordRef)record {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (instancetype)initWithABRecord:(ABRecordRef)record groupsRef:(CFArrayRef)groupsRef
{
    self = [super initWithABRecord:record];
    if (self) {
        NSMutableArray *groups = CFArrayGetCount(groupsRef)>0?[NSMutableArray array]:nil;
        for (int i=0; i<CFArrayGetCount(groupsRef); i++) {
            ABRecordRef groupRef = CFArrayGetValueAtIndex(groupsRef, i);
            BDAddressBookGroup *group = [[BDAddressBookGroup alloc]initWithABRecord:groupRef];
            [groups addObject:group];
        }
        _groups = groups;
    }
    return self;
}

- (BDAddressBookObjectType)objectType {
    return BDAddressBookObjectSource;
}

#pragma mark - 读取属性
+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    ABRecordType type = ABRecordGetRecordType(record);
    if (type != kABSourceType) {
        NSAssert(NO, @"record的type类型不是kABSourceType");
        return nil;
    }
    if ([propertyName isEqualToString:@"recordID"]) {
        return [super readValueFromRecord:record propertyName:propertyName];
    } else if ([propertyName isEqualToString:@"sourceName"]) {
        return CFBridgingRelease(ABRecordCopyValue(record, kABSourceNameProperty));
    } else if ([propertyName isEqualToString:@"sourceType"]) {
        return CFBridgingRelease(ABRecordCopyValue(record, kABSourceTypeProperty));
    } else {
        return nil;
    }
}

@end
