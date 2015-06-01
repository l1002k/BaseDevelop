//
//  NSString+FileManager.m
//  BaseDevelop
//
//  Created by leikun on 15/6/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "NSString+FileManager.h"

@implementation NSString (FileManager)

+ (NSString *)HomePath {
    return NSHomeDirectory();
}

+ (NSString *)DocumentsPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)CachesPath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

+ (NSString *)TemporaryPath {
    return NSTemporaryDirectory();
}

- (BOOL)isFileExists {
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:self];
}

- (BOOL)createDirectoryIfNeed:(NSError **)error {
    if ([self isFileExists]) {
        return YES;
    } else {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *createError = nil;
        BOOL result = [manager createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:&createError];
        if (error) {
            *error = createError;
        }
        return result;
    }
}

@end
