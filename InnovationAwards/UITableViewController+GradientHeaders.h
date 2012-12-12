//
//  UITableViewController+GradientHeaders.h
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UITableViewController (GradientHeaders)

- (UIView *)gradientHeaderViewForSection:(NSInteger)section;

@end
