//
//  UIView+Coordinate.h
//  BaseDevelop
//
//  Created by leikun on 15-2-2.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (FrameAdditions)

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize  size;
@property(nonatomic) CGFloat x, y, width, height;
@property(nonatomic) CGFloat centerX, centerY;
/**
 *  the x in screen coordinate
 */
@property(nonatomic, readonly) CGFloat screenX;

/**
 *  the y in screen coordinate
 */
@property(nonatomic, readonly) CGFloat screenY;

/**
 *  right = self.frame.origin.x + self.frame.size.width;
 *  don't modify self.frame.origin.x when modified
 */
@property(nonatomic) CGFloat right;

/**
 *  bottom = self.frame.origin.y + self.frame.size.height
 *  don't modify self.frame.origin.y when modified
 */
@property(nonatomic) CGFloat bottom;

@end
