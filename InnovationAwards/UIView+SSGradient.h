//
//  UIView+SSGradient.h
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

CAGradientLayer *whiteGradient(void);
CAGradientLayer *gradientWithColor(UIColor *color1, UIColor *color);


@interface UIView (SSGradient)

- (void)addGradient:(CAGradientLayer *)gradient;

@end
