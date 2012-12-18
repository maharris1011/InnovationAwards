//
//  FacebookWebViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "FacebookWebViewController.h"

@interface FacebookWebViewController ()

@end

@implementation FacebookWebViewController


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
    NSString *szUrl = @"http://m.facebook.com/TechColumbusOhio";
    NSURL *URL = [NSURL URLWithString:szUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    [self.webView setFrame:CGRectMake(0, 0, 320, 480-20-44-44)];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forwardPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)backPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)peoplesChoiceVideoPressed:(id)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://a.pgtb.me/t2Nvh8"]]];

}
@end
