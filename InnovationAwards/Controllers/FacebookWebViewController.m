//
//  FacebookWebViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "FacebookWebViewController.h"

@interface FacebookWebViewController () {
    NSString *_szUrl;
    NSString *_szFBSchemeUrl;
    NSString *_szVideosUrl;
}

@end

@implementation FacebookWebViewController
@synthesize actionButton = _actionButton;

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
    // refresh the web view
    _szUrl = @"http://m.facebook.com/TechColumbusOhio";
    _szFBSchemeUrl = @"fb://profile/86633934712"; // id of the TechColumbusOhio page
    _szVideosUrl = @"http://a.pgtb.me/t2Nvh8";    // shortened URL
    
    NSURL *URL = [NSURL URLWithString:_szUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    [self.webView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-20-44-44)];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView stringByEvaluatingJavaScriptFromString:@"window.scrollTo(0.0, 44.0);"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- UIActions
- (IBAction)forwardPressed:(id)sender
{
    [self.webView goForward];
}

- (IBAction)backPressed:(id)sender
{
    [self.webView goBack];
}

- (IBAction)refreshPressed:(id)sender
{
    [self.webView reload];
}

- (IBAction)peoplesChoiceVideoPressed:(id)sender
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_szVideosUrl]]];

}
- (IBAction)actionButtonPressed:(id)sender
{
    // show dialog for open in facebook app and open in safari
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Open in Safari", @"Open in Facebook", nil];
    
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as showFromBarButtonItem:self.actionButton animated:YES];
}

#pragma mark -- UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *szUrl = nil;
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        switch (buttonIndex)
        {
            case 0:
                szUrl = [self.webView.request.URL absoluteString];
                break;
                
            case 1:
                // 1 = open in facebook app
                szUrl = _szFBSchemeUrl;
                break;
                
            default:
                break;
        }
        
    }
    // make sure we hit the right button
    if (szUrl)
    {
        // make a real URL
        NSURL *url = [NSURL URLWithString:szUrl];
        
        // check it's open-able and open it!
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)viewDidUnload {
    [self setActionButton:nil];
    [super viewDidUnload];
}
@end
