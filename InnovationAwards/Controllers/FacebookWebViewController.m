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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
