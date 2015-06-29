//
//  BDAddressBookPerson.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookObject.h"
#import <UIKit/UIKit.h>

//某些property的值是键值对，但是key会重复
@interface BDAddressBookPersonValueInfo : NSObject

@property(nonatomic)NSNumber *valueIdentifier;
@property(nonatomic, readonly)NSString *labelKey; //AddressBook库使用的关键字
@property(nonatomic)NSString *key;                //由labelKey转换而来
@property(nonatomic)id value;

@end

@interface NSArray (BDAddressBookPersonValueInfo)

- (NSArray *)allPersonValueKeys;
- (NSArray *)allPersonValueValues;

@end

@interface BDAddressBookPerson : BDAddressBookObject

@property(nonatomic)NSString *firstName;            //姓氏
@property(nonatomic)NSString *lastName;             //名字
@property(nonatomic)NSString *middleName;           //中间名
@property(nonatomic)NSString *prefix;               //前缀
@property(nonatomic)NSString *suffix;               //后缀
@property(nonatomic)NSString *nickName;             //昵称
@property(nonatomic)NSString *firstNamePhonetic;    //姓氏拼音或音标
@property(nonatomic)NSString *lastNamePhonetic;     //名字拼音或音标
@property(nonatomic)NSString *middleNamePhonetic;   //中间名拼音或音标

@property(nonatomic)NSString *organiztion;          //公司
@property(nonatomic)NSString *jobTitle;             //职务
@property(nonatomic)NSString *department;           //部门

@property(nonatomic)NSString *note;                 //备注
@property(nonatomic)NSDate *creationDate;           //创建时间
@property(nonatomic)NSDate *modificationDate;       //最近一次修改时间

//thumbnailImage, originalImage不支持修改
@property(nonatomic, readonly)UIImage *thumbnailImage;        //缩略照片
@property(nonatomic, readonly)UIImage *originalImage;         //原始照片
@property(nonatomic)UIImage *sourceImage;           //未处理过的照片

@property(nonatomic)NSDate *birthday;               //生日

@property(nonatomic)NSNumber *kind;                 //类型(公司kABPersonKindOrganization或个人kABPersonKindPerson)

@property(nonatomic)NSDictionary *alternateBirthday;//生日的扩展,农历等

/*
 *   以下数据都是NSArray<BDAddressBookPersonValueInfo *>的结构
 *   其中phone, email, instantMessage, url的BDAddressBookValueInfo.value是NSString。key可能不唯一导致不能用NSDictionary
 *   date的BDAddressBookValueInfo.value是NSDate
 *   socialProfile,relatedNames, address的BDAddressBookValueInfo.value是NSDictionary
 */
//NSString
@property(nonatomic)NSArray *phone;                 //电话
@property(nonatomic)NSArray *email;                 //电子邮件
@property(nonatomic)NSArray *instantMessage;        //即时聊天信息
@property(nonatomic)NSArray *url;                   //URL
//NSDate
@property(nonatomic)NSArray *date;                  //日期
//NSDictionary
@property(nonatomic)NSArray *socialProfile;         //社交信息
@property(nonatomic)NSArray *relatedNames;          //关联人
@property(nonatomic)NSArray *address;               //地址

- (ABRecordRef)createRecordRefWithoutRecordID;

@end
