//
//  NSObject+Property.h
//  BaseDevelop
//
//  Created by leikun on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Property)

//获取定制Class的所有属性名
+ (NSArray *)propertyNamesForClass:(Class)cls;
//获取当前对象的所有属性名除了NSObject
- (NSArray *)allPropertyNamesExceptNSObject;
//获取定制Class的所有属性类型名
+ (NSDictionary *)propertyClassNameForClass:(Class)klass;
//获取当前对象的所有属性类型名除了NSObject
- (NSDictionary *)allPropertyClassNamesExceptNSObject;

//讲当前对象转换成NSDictionary
- (NSDictionary *)covertToDictionary;
/*
 * 在covertToDictionary过程中指定propertyName的NSDictionary
 * 返回nil，则使用@{propertyName:propertyValue}
 * 非空，则使用返回值
 */
- (NSDictionary *)getDictionaryWithPropertyName:(NSString *)propertyName;

@end
