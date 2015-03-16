//
//  BDNavigationBar.m
//  BaseDevelop
//
//  Created by leikun on 15-3-16.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import "BDNavigationBar.h"

@interface BDNavigationBar () {
    CGFloat _extraHeight;
}

@end

@implementation BDNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    _extraHeight = 20;
    [self setTransform:CGAffineTransformMakeTranslation(0, -(_extraHeight))];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + _extraHeight - 20.f;
            frame.size.height = bounds.size.height + 20;
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize result = [super sizeThatFits:size];
    result.height += _extraHeight;
    return result;
}

@end
