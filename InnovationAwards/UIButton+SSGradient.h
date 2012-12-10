//
//  UIButton+SSGradient.h
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

CAGradientLayer *gradientWithColor(UIColor *color2, UIColor *color1);


@interface UIButton (SSGradient)

- (void)addGradient:(CAGradientLayer *)gradient;

@end
