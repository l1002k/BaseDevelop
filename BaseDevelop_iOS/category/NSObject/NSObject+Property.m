//
//  NSObject+Property.m
//  BaseDevelop
//
//  Created by leikun on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

//获取属性的方法
static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            
            // if you want a list of what will be returned for these primitives, search online for
            // "objective-c" "Property Attribute Description Examples"
            // apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

@implementation NSObject (Property)

+ (NSArray *)propertyNamesForClass:(Class)cls {
    NSMutableArray* result = [NSMutableArray array];
    
    unsigned int propertyCount = 0;
    objc_property_t* properties = class_copyPropertyList(cls, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        NSString* propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if ([[self notProcessPropertyNames] containsObject:propertyName]) {
            continue;
        }
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

//获取属性名称数组
- (NSDictionary *)classPropsFor:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            if ([[self.class notProcessPropertyNames] containsObject:propertyName]) {
                continue;
            }
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

+ (NSArray *)notProcessPropertyNames {
    return @[@"hash", @"superclass", @"description", @"debugDescription"];
}

@end
