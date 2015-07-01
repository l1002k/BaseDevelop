//
//  NSBundle+Language.h
//  BaseDevelop
//
//  Created by leikun on 15/7/1.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

//modify the language when the app is running
@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

@end
