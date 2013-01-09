//
//  LinkedInViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/5/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "LinkedInViewController.h"

@interface LinkedInViewController () {
    NSString *_szUrl;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this is the URL for the TechColumbus group
    _szUrl = @"https://www.linkedin.com/groups?gid=39787";
    NSURL *URL = [NSURL URLWithString:_szUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
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
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
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
            NSURL *url = [NSURL URLWithString:_szUrl];
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
