//
//  SemiFinalistDetailViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SemiFinalistDetailViewController : UIViewController

@property (nonatomic, strong) NSString *urlOfCategory;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *semifinalistName;

@property (nonatomic, strong) SZActionBar *actionBar;
@property (nonatomic, strong) id<SZEntity> entity;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)backPressed:(id)sender;
- (IBAction)forwardPressed:(id)sender;
@end
