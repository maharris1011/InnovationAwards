//
//  LinkedInViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "LinkedInViewController.h"

@interface LinkedInViewController ()

@end

@implementation LinkedInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *URL = [NSURL URLWithString:@"http://www.linkedin.com/company/techcolumbus"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
}

- (void)viewDidLayoutSubviews
{
    [self.webView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20-44-44)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
- (IBAction)forwardPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)backwardPressed:(id)sender {
    [self.webView goBack];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

@end
