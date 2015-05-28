//
//  BDAddressBookInfo.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDAddressBookInfo : NSObject

@property(nonatomic)NSNumber *recordID;

@property(nonatomic)NSString *firstName;
@property(nonatomic)NSString *lastName;
@property(nonatomic)NSString *middleName;
@property(nonatomic)NSString *prefix;
@property(nonatomic)NSString *suffix;
@property(nonatomic)NSString *nickName;
@property(nonatomic)NSString *firstNamePhonetic;
@property(nonatomic)NSString *lastNamePhonetic;
@property(nonatomic)NSString *middleNamePhonetic;
@property(nonatomic)NSDate *birthday;

@property(nonatomic)NSString *organiztion;
@property(nonatomic)NSString *jobTitle;
@property(nonatomic)NSString *department;

@property(nonatomic)NSString *note;
@property(nonatomic)NSDate *creationDate;
@property(nonatomic)NSDate *modificationDate;

@property(nonatomic)UIImage *image;
@property(nonatomic)id email;
@property(nonatomic)id address;
@property(nonatomic)id date;
@property(nonatomic)id kind;
@property(nonatomic)id phone;
@property(nonatomic)id instantMessage;
@property(nonatomic)id url;
@property(nonatomic)id relatedNames;
@property(nonatomic)id socialProfile;
@property(nonatomic)id alternateBirthday;


@end
