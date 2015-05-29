//
//  NSObject+Property.m
//  BaseDevelop
//
//  Created by leikun on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

@implementation NSObject (Property)

+ (NSArray *)propertyNamesForClass:(Class)cls {
    NSMutableArray* result = [NSMutableArray array];
    
    unsigned int propertyCount = 0;
    objc_property_t* properties = class_copyPropertyList(cls, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [result addObject:propertyName];
    }
    free(properties);
    
    return result.count > 0 ? result : nil;
}

- (NSArray *)allPropertyNamesExceptNSObject {
    NSMutableArray* result = [NSMutableArray array];
    for (Class currentClass = [self class]; currentClass != [NSObject class]; currentClass = [currentClass superclass]) {
        NSArray *propertyNames = [NSObject propertyNamesForClass:currentClass];
        if (propertyNames) {
            [result addObjectsFromArray:propertyNames];
        }
    }
    return result.count > 0 ? result : nil;
}

- (NSDictionary *)covertToDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *propertyNames = [self allPropertyNamesExceptNSObject];
    for(NSString *propertyName in propertyNames)
    {
        id value = [self valueForKey:propertyName];
        if (value)
        {
            NSDictionary *dictionary = [self getDictionaryWithPropertyName:propertyName];
            if (dictionary)
            {
                [result addEntriesFromDictionary:dictionary];
            }else
            {
                [result setObject:value forKey:propertyName];
            }
        }
    }
    return result.count > 0 ? result : nil;
}

- (NSDictionary *)getDictionaryWithPropertyName:(NSString *)propertyName
{
    return nil;
}

@end
