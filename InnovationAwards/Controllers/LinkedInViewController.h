//
//  LinkedInViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)forwardPressed:(id)sender;
- (IBAction)backwardPressed:(id)sender;

@end
