//
//  BDAddressBookPerson.m
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookPerson.h"
#import "BDCommonUtil.h"
#import "NSObject+Property.h"

@interface BDAddressBookPersonValueInfo ()

@property(nonatomic)NSString *labelKey;

@end

@implementation BDAddressBookPersonValueInfo

@end

@implementation NSArray (BDAddressBookPersonValueInfo)

- (NSArray *)allPersonValueKeys {
    NSMutableArray *result = [NSMutableArray array];
    for(BDAddressBookPersonValueInfo *info in self) {
        if (![info isKindOfClass:BDAddressBookPersonValueInfo.class]) {
            return nil;
        }
        [result addObject:info.key];
    }
    return result.count > 0 ? result : nil;
}

- (NSArray *)allPersonValueValues {
    NSMutableArray *result = [NSMutableArray array];
    for(BDAddressBookPersonValueInfo *info in self) {
        if (![info isKindOfClass:BDAddressBookPersonValueInfo.class]) {
            return nil;
        }
        [result addObject:info.value];
    }
    return result.count > 0 ? result : nil;
}

@end

@implementation BDAddressBookPerson

#pragma mark - 公用属性
+ (ABPropertyID)getAddressPropertyIDFromPropertyName:(NSString *)propertyName {
    static NSDictionary *nameToIDDictionary;
    static NSArray * validPropertyWithoutPropertyID;
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
                                @"socialProfile":@(kABPersonSocialProfileProperty),
                                @"relatedNames":@(kABPersonRelatedNamesProperty),
                                @"address":@(kABPersonAddressProperty),
                               };
        
        validPropertyWithoutPropertyID = @[@"recordID", @"originalImage", @"thumbnailImage", @"sourceImage"];
    });
    NSNumber *propertyID = [nameToIDDictionary objectForKey:propertyName];
   if ([validPropertyWithoutPropertyID containsObject:propertyName]) {
       return kABPropertyInvalidID;
    } else if (propertyID == nil) {
        //对于ios8新增的字段进行单独处理，兼容ios7
        if ([propertyName isEqualToString:@"alternateBirthday"]) {
            return SystemVersionHigherThanOrEqualTo(@"8.0")?kABPersonAlternateBirthdayProperty:kABPropertyInvalidID;
        }
        
        NSAssert(NO, @"未知的propertyName:%@",propertyName);
        return kABPropertyInvalidID;
    }
    return [propertyID intValue];
}

- (BDAddressBookObjectType)objectType {
    return BDAddressBookObjectPerson;
}

#pragma mark - 读取属性方法
//基类方法
+ (id)readValueFromRecord:(ABRecordRef)record propertyName:(NSString *)propertyName {
    ABRecordType type = ABRecordGetRecordType(record);
    if (type != kABPersonType) {
        NSAssert(NO, @"record的type类型不是kABPersonType");
        return nil;
    }
    if ([propertyName isEqualToString:@"recordID"]) {
        return [super readValueFromRecord:record propertyName:propertyName];
    } else if ([propertyName isEqualToString:@"thumbnailImage"]) {
        return [self readImageValueFromRecord:record imageFormat:kABPersonImageFormatThumbnail];
    } else if ([propertyName isEqualToString:@"originalImage"]) {
        return [self readImageValueFromRecord:record imageFormat:kABPersonImageFormatOriginalSize];
    } else if ([propertyName isEqualToString:@"sourceImage"]) {
        return [self readSourceImageValueFromRecord:record];
    } else {
        return [self readValueWithPropertyIDFromRecord:record propertyName:propertyName];
    }
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

+ (UIImage *)readSourceImageValueFromRecord:(ABRecordRef)record {
    UIImage *image = nil;
    if (ABPersonHasImageData(record)) {
        NSData *imageData = CFBridgingRelease(ABPersonCopyImageData(record));
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
        case kABMultiDictionaryPropertyType:
            result = [self parseMultiValueRef:ref propertyName:propertyName];
            break;
        default:
            NSAssert(NO, @"未检查过的值类型propertyID : %@, name : %@, type : %@",@(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)), @(type));
            break;
    }
    CFSafeRelease(ref);
    return result;
}

/*--------下面的方法是解析单个属性的值--------------*/
+ (id)parseSingleRef:(CFTypeRef)ref propertyName:(NSString *)propertyName{
    return (__bridge id)ref;
}

+ (id)parseMultiValueRef:(ABMultiValueRef)ref propertyName:(NSString *)propertyName{
    NSMutableArray *result = [NSMutableArray array];
    
    for (int i = 0; i < ABMultiValueGetCount(ref); i++) {
        CFTypeRef valueRef = ABMultiValueCopyValueAtIndex(ref, i);
        CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(ref, i);
        CFStringRef localizedLabelRef = ABAddressBookCopyLocalizedLabel(labelRef);
        ABMultiValueIdentifier identifier = ABMultiValueGetIdentifierAtIndex(ref, i);
        BDAddressBookPersonValueInfo *valueInfo = [[BDAddressBookPersonValueInfo alloc] init];
        valueInfo.key = CFBridgingRelease(localizedLabelRef);
        valueInfo.labelKey = CFBridgingRelease(labelRef);
        valueInfo.value = CFBridgingRelease(valueRef);
        valueInfo.valueIdentifier = @(identifier);
        [result addObject:valueInfo];
    }
    
    return result.count > 0 ? result : nil;
}

/*--------下面的方法是解析单个属性的值 end----------*/

#pragma mark - 转换成ABRecordRef
- (ABRecordRef)createRecordRefWithoutRecordID {
    ABRecordRef person = ABPersonCreate();
    
    CFErrorRef errorRef = NULL;
    if (_sourceImage) {
        //可以根据具体需求调整压缩系数
        NSData *sourceImageData = UIImageJPEGRepresentation(_sourceImage, 1);
        ABPersonSetImageData(person, (__bridge CFDataRef)sourceImageData, &errorRef);
        if (errorRef) {
            NSAssert(NO, @"设置propertyName : sourceImage, 发生错误 : %@", CFBridgingRelease(errorRef));
            return NULL;
        }
    }
    
    for(NSString *propertyName in [NSObject propertyNamesForClass:self.class]) {
        ABPropertyID property = [self.class getAddressPropertyIDFromPropertyName:propertyName];
        id value = [self valueForKey:propertyName];
        if (property != kABPropertyInvalidID && value) {
            
            ABPropertyType type = ABPersonGetTypeOfProperty(property);
            switch (type) {
                case kABInvalidPropertyType:
                    NSAssert(NO, @"查下SDK为什么propertyName : %@, propertyID : %@, name : %@ 的值类型不合法", propertyName, @(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)));
                    break;
                case kABStringPropertyType:
                case kABIntegerPropertyType:
                case kABRealPropertyType:
                case kABDateTimePropertyType:
                case kABDictionaryPropertyType:
                    ABRecordSetValue(person, property, (__bridge CFTypeRef)value, &errorRef);
                    break;
                case kABMultiStringPropertyType:
                case kABMultiIntegerPropertyType:
                case kABMultiRealPropertyType:
                case kABMultiDateTimePropertyType:
                case kABMultiDictionaryPropertyType:
                {
                    if ([value isKindOfClass:NSArray.class] && [value count] > 0) {
                        ABMutableMultiValueRef multiValueRef = ABMultiValueCreateMutable(property);
                        for(BDAddressBookPersonValueInfo *info in value) {
                            ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFTypeRef)info.value, (__bridge CFStringRef)info.labelKey, NULL);
                        }
                        ABRecordSetValue(person, property, multiValueRef, &errorRef);
                        CFSafeRelease(multiValueRef);
                    }
                    break;
                }
                default:
                    NSAssert(NO, @"未检查过的值类型propertyName : %@, propertyID : %@, name : %@, type : %@", propertyName, @(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)), @(type));
                    break;
            }
            
            if (errorRef) {
                NSAssert(NO, @"设置propertyName : %@,  propertyID : %@, name : %@, type : %@, 发生错误 : %@", propertyName, @(property), CFBridgingRelease(ABPersonCopyLocalizedPropertyName(property)), @(type), CFBridgingRelease(errorRef));
                return NULL;
            }
        }
    }
    return person;
}

@end
