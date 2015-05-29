//
//  BDAddressBookGroup.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookObject.h"

@interface BDAddressBookGroup : BDAddressBookObject

@property(nonatomic)NSString *groupName;    //分组名
@property(nonatomic)NSArray *persons;       //分组联系人数组

@end
