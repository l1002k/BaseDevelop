//
//  NSString+FileManager.h
//  BaseDevelop
//
//  Created by leikun on 15/6/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FileManager)

+ (NSString *)HomePath;
+ (NSString *)DocumentsPath;
+ (NSString *)CachesPath;
+ (NSString *)TemporaryPath;

- (BOOL)isFileExists;
- (BOOL)createDirectoryIfNeed:(NSError **)error;

@end
