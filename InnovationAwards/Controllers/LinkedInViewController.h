//
//  LinkedInViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LinkedInViewController : UIViewController<UIActionSheetDelegate, UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *startingURL;

- (IBAction)forwardPressed:(id)sender;
- (IBAction)backwardPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;

@end
