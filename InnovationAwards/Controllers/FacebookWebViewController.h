//
//  FacebookWebViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookWebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)forwardPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)peoplesChoiceVideoPressed:(id)sender;

@end
