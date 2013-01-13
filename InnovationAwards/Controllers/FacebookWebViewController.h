//
//  FacebookWebViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface FacebookWebViewController : UIViewController<UIWebViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) NSString *startingURL;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *videosButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *back;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forward;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (strong, nonatomic) MBProgressHUD *progressHUD;


- (IBAction)forwardPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)peoplesChoiceVideoPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;
- (IBAction)refreshPressed:(id)sender;

@end
