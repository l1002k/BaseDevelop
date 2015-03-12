//
//  UIView+Util.h
//  BaseDevelop
//
//  Created by leikun on 15-2-2.
//  Copyright (c) 2015年 leikun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

/**
 *  remove all subviews of this view
 */
- (void)removeAllSubViews;

/**
 * Finds the first descendant view (including this view) that is a kind of that class
 */
- (id)descendantOrSelfWithClass:(Class)aClass;

/**
 * Finds the first ancestor view (including this view) that is a kind of that class
 */
- (id)ancestorOrSelfWithClass:(Class)aClass;

/**
 *  return a snapshot image for this view
 */
- (UIImage*)getSnapshotImage;

/**
 *  return a snapshot view of this view.
 *
 *  lower than iOS7 return a UIImageView by call -[UIView getSnapshotImage], otherwise, return -[UIView snapshotViewAfterScreenUpdates:]
 */
- (UIView *)getSnapshotView;

@end
