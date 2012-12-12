//
//  UIView+SSGradient.m
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+SSGradient.h"
#import "Constants.h"


CAGradientLayer *whiteGradient(void)
{
    return gradientWithColor([UIColor whiteColor], [UIColor grayColor]);
}

CAGradientLayer *gradientWithColor(UIColor *color1, UIColor *color2)
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    
    [gradient setColors:[NSArray arrayWithObjects:(id)color2.CGColor, (id)color1.CGColor, nil]];
    
    return gradient;
}


@implementation UIView (SSGradient)


- (void)addGradient:(CAGradientLayer *)gradient
{
    gradient.frame = self.bounds;
    [self.layer insertSublayer:gradient atIndex:0];
}

@end
