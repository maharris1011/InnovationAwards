//
//  RegistrationViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>


@interface RegistrationViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end
