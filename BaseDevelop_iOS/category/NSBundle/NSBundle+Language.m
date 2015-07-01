//
//  NSBundle+Language.m
//  BaseDevelop
//
//  Created by leikun on 15/7/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSBundle+Language.h"
#import <objc/runtime.h>

void *BDBundleLanguageKey = &BDBundleLanguageKey;

@interface BDBundle : NSBundle

@end

@implementation BDBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, BDBundleLanguageKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BDBundle class]);
    });
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], BDBundleLanguageKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
