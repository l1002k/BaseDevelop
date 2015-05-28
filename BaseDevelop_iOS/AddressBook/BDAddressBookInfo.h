//
//  BDAddressBookInfo.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/28.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDAddressBookInfo : NSObject

@property(nonatomic)NSNumber *recordID;             //唯一标示符

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

@property(nonatomic)UIImage *image;                 //照片
@property(nonatomic)NSDate *birthday;               //生日

@property(nonatomic)id email;                       //电子邮件
@property(nonatomic)id address;                     //地址
@property(nonatomic)id date;                        //日期
@property(nonatomic)id phone;                       //电话
@property(nonatomic)id instantMessage;              //即时聊天信息
@property(nonatomic)id url;                         //URL
@property(nonatomic)id relatedNames;                //关联人
@property(nonatomic)id socialProfile;               //社交信息
@property(nonatomic)id kind;                        //类型(公司或个人)
@property(nonatomic)id alternateBirthday;           //生日的扩展


@end
