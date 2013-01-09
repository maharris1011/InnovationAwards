//
//  LinkedInViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedInViewController : UIViewController<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;

- (IBAction)forwardPressed:(id)sender;
- (IBAction)backwardPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;

@end
