//
//  LinkedInViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "LinkedInViewController.h"

@interface LinkedInViewController () {
    NSString *_title;
}

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

- (void)configureView
{
    self.forward.enabled = self.webView.canGoForward;
    self.back.enabled = self.webView.canGoBack;
    self.refresh.enabled = !self.webView.loading;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _title = @"IA12 on LinkedIn";
    
    // this is how we show progress
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.labelText = @"Loading...";
    [self.view addSubview:self.progressHUD];

    // this is the URL for the TechColumbus group
    self.startingURL = @"https://www.linkedin.com/groups?gid=39787";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startingURL]]];
}

- (void)viewDidLayoutSubviews
{
    [self.webView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20-44-44)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setActionButton:nil];
    [self setProgressHUD:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    [self configureView];
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationItem setTitle:@"Loading..."];
    [self.progressHUD show:YES];
    [self configureView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0.0, 44.0);"];
    [self.navigationItem setTitle:_title];
    [self.progressHUD hide:YES];
    [self configureView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationItem setTitle:_title];
    [self.progressHUD hide:YES];
    [self configureView];
}

- (IBAction)forwardPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)backwardPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)refreshPressed:(id)sender
{
    [self.webView reload];
}

#pragma mark -- UIActionSheetDelegate
- (IBAction)actionButtonPressed:(id)sender
{
    // show dialog for open in facebook app and open in safari
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", @"Open LinkedIn", nil];
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        if (buttonIndex == 0)
        {
            // safari
            // make a real URL
            NSURL *url = [NSURL URLWithString:self.startingURL];
            [[UIApplication sharedApplication] openURL:url];
            
        }
        else if (buttonIndex == 1)
        {
            // open linkedIn's app
            NSURL *url = [NSURL URLWithString:@"linkedin://"];
            // check it's open-able and open it!
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }
        
    }
}
@end
