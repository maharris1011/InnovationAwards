//
//  UIView+SSGradient.m
//  iSandlot
//
//  Created by Mark Harris on 11/18/12.
//
//

#import <QuartzCore/QuartzCore.h>
#import "UIButton+SSGradient.h"


CAGradientLayer *gradientWithColor(UIColor *color2, UIColor *color1)
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    
    [gradient setColors:[NSArray arrayWithObjects:(id)color2.CGColor, (id)color1.CGColor, nil]];
    
    return gradient;
}


@implementation UIButton (SSGradient)


- (void)addGradient:(CAGradientLayer *)gradient
{
    gradient.frame = self.bounds;
    NSString *caption = self.titleLabel.text;
    
    // Assign gradient to the button.
    self.layer.masksToBounds = true;
    [self.layer insertSublayer:gradient atIndex:0];
    self.layer.cornerRadius = 10;
    
    // Set the button's title. Alignment and font have to be set here to make it work.
    [self setTitle:caption forState:UIControlStateNormal];
}

@end
