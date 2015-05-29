//
//  BDAddressBookSource.h
//  BaseDevelop
//
//  Created by  雷琨 on 15/5/29.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDAddressBookObject.h"

@interface BDAddressBookSource : BDAddressBookObject

@property(nonatomic)NSString *sourceName;           //名字
@property(nonatomic)NSNumber *sourceType;           //类型
@property(nonatomic)NSArray *groups;                //联系人

- (instancetype)initWithABRecord:(ABRecordRef)record groupsRef:(CFArrayRef)groupsRef;

@end
