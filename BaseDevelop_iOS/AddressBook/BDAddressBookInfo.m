//
//  BDAddressBookInfo.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookInfo.h"
#import "BDCommonUtil.h"
#import "NSObject+Property.h"

@implementation BDAddressBookValueInfo

+ (NSArray *)allKeys:(NSArray *)valueInfos {
    NSMutableArray *result = [NSMutableArray array];
    for(BDAddressBookValueInfo *info in valueInfos) {
        [result addObject:info.key];
    }
    return result.count > 0 ? result : nil;
}

+ (NSArray *)allValues:(NSArray *)valueInfos {
    NSMutableArray *result = [NSMutableArray array];
    for(BDAddressBookValueInfo *info in valueInfos) {
        [result addObject:info.value];
    }
    return result.count > 0 ? result : nil;
}

@end

@implementation BDAddressBookInfo

- (instancetype)initWithABRecord:(ABRecordRef)record
{
    self = [super init];
    if (self) {
        NSArray *propertyNames = [NSObject propertyNamesForClass:BDAddressBookInfo.class];
        for(NSString *propertyName in propertyNames) {
            id propertyValue = [self.class readValueFromRecord:record propertyName:propertyName];
            [self setValue:propertyValue forKey:propertyName];
        }
    }
    return self;
}

#pragma mark - 公用属性
+ (ABPropertyID)getAddressPropertyIDFromPropertyName:(NSString *)propertyName {
    static NSDictionary *nameToIDDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nameToIDDictionary = @{
                                @"firstName":@(kABPersonFirstNameProperty),
                                @"lastName":@(kABPersonLastNameProperty),
                                @"middleName":@(kABPersonLastNameProperty),
                                @"prefix":@(kABPersonPrefixProperty),
                                @"suffix":@(kABPersonSuffixProperty),
                                @"nickName":@(kABPersonNicknameProperty),
                                @"firstNamePhonetic":@(kABPersonFirstNamePhoneticProperty),
                                @"lastNamePhonetic":@(kABPersonLastNamePhoneticProperty),
                                @"middleNamePhonetic":@(kABPersonMiddleNamePhoneticProperty),
                                @"organiztion":@(kABPersonOrganizationProperty),
                                @"jobTitle":@(kABPersonJobTitleProperty),
                                @"department":@(kABPersonDepartmentProperty),
                                @"note":@(kABPersonNoteProperty),
                                @"creationDate":@(kABPersonCreationDateProperty),
                                @"modificationDate":@(kABPersonModificationDateProperty),
                                @"birthday":@(kABPersonBirthdayProperty),
                                @"kind":@(kABPersonKindProperty),
                                @"phone":@(kABPersonPhoneProperty),
                                @"email":@(kABPersonEmailProperty),
                                @"instantMessage":@(kABPersonInstantMessageProperty),
                                @"url":@(kABPersonURLProperty),
                                @"date":@(kABPersonDateProperty),
                                @"alternateBirthday":@(kABPersonAlternateBirthdayProperty),
                                @"socialProfile":@(kABPersonSocialProfileProperty),
                                @"relatedNames":@(kABPersonRelatedNamesProperty),
                                @"address":@(kABPersonAddressProperty)
                               };
    });
    NSNumber *propertyID = [nameToIDDictionary objectForKey:propertyName];
   if ([propertyName isEqualToString:@"recordID"] || [propertyName isEqualToString:@"thumbnailImage"] || [propertyName isEqualToString:@"originalImage"]) {
       NSAssert(NO, @"recordID, thumbnailImage, originalImage没有propertyID属性");
       return kABPropertyInvalidID;
    } else if (propertyID == nil) {
        NSAssert(NO, @"未在nameToIDDictionary字典中定义的propertyName:%@",propertyName);
        return kABPropertyInvalidID;
    }
    return [propertyID intValue];
}

#pragma mark - 读取属性方法
+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    if ([propertyName isEqualToString:@"recordID"]) {
        return [self readRecordID:record];
    } else if ([propertyName isEqualToString:@"thumbnailImage"]) {
        return [self readImageValueFromRecord:record imageFormat:kABPersonImageFormatThumbnail];
    } else if ([propertyName isEqualToString:@"originalImage"]) {
        return [self readImageValueFromRecord:record imageFormat:kABPersonImageFormatOriginalSize];
    } else {
        return [self readValueWithPropertyIDFromRecord:record propertyName:propertyName];
    }
}

//读取唯一标示符
+ (NSNumber *)readRecordID:(ABRecordRef)record {
    return @(ABRecordGetRecordID(record));
}

//读取图片
+ (UIImage *)readImageValueFromRecord:(ABRecordRef)record imageFormat:(ABPersonImageFormat)format {
    UIImage *image = nil;
    if (ABPersonHasImageData(record)) {
        NSData *imageData = CFBridgingRelease(ABPersonCopyImageDataWithFormat(record, kABPersonImageFormatThumbnail));
        image = [[UIImage alloc]initWithData:imageData];
    }
    return image;
}

//读带propertyID的属性
+ (id)readValueWithPropertyIDFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    ABPropertyID property = [self getAddressPropertyIDFromPropertyName:propertyName];
    if (property == kABPropertyInvalidID) {
        return nil;
    }
    ABPropertyType type = ABPersonGetTypeOfProperty(property);
    CFTypeRef ref = ABRecordCopyValue(record, property);
    id result = nil;
    switch (type) {
        case kABInvalidPropertyType:
            NSAssert(NO, @"查下SDK为什么propertyID : %@, name : %@ 的值类型不合法", @(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)));
            break;
        case kABStringPropertyType:
        case kABIntegerPropertyType:
        case kABRealPropertyType:
        case kABDateTimePropertyType:
            case kABDictionaryPropertyType:
            result = [self parseSingleRef:ref propertyName:propertyName];
            break;
        case kABMultiStringPropertyType:
        case kABMultiIntegerPropertyType:
        case kABMultiRealPropertyType:
        case kABMultiDateTimePropertyType:
            result = [self parseMultiNormalRef:ref propertyName:propertyName];
            break;
        case kABMultiDictionaryPropertyType:
            result = [self parseMultiDictionaryRef:ref propertyName:propertyName];
            break;
        default:
            NSAssert(NO, @"未检查过的值类型propertyID : %@, name : %@, type : %@",@(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)), @(type));
            break;
    }
    CFSafeRelease(ref);
    return result;
}

+ (id)parseSingleRef:(CFTypeRef)ref propertyName:(NSString *)propertyName{
    return (__bridge id)ref;
}

+ (id)parseMultiNormalRef:(ABMultiValueRef)ref propertyName:(NSString *)propertyName{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < ABMultiValueGetCount(ref); i++) {
        CFTypeRef valueRef = ABMultiValueCopyValueAtIndex(ref, i);
        CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(ref, i);
        CFStringRef localizedLabelRef = ABAddressBookCopyLocalizedLabel(labelRef);
        BDAddressBookValueInfo *valueInfo = [[BDAddressBookValueInfo alloc] init];
        valueInfo.key = CFBridgingRelease(localizedLabelRef);
        valueInfo.value = CFBridgingRelease(valueRef);
        [result addObject:valueInfo];
        CFSafeRelease(labelRef);
    }
    
    return result.count > 0 ? result : nil;
}

+ (id)parseMultiDictionaryRef:(ABMultiValueRef)ref propertyName:(NSString *)propertyName{
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < ABMultiValueGetCount(ref); i++) {
        CFTypeRef valueRef = ABMultiValueCopyValueAtIndex(ref, i);
        NSDictionary *dictionary = CFBridgingRelease(valueRef);
        [result addObject:dictionary];
    }
    
    return result.count > 0 ? result : nil;
}


@end
