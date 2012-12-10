//
//  SemiFinalistDetailViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemiFinalistDetailViewController.h"

@interface SemiFinalistDetailViewController ()

@end

@implementation SemiFinalistDetailViewController

@synthesize urlOfCategory = _urlOfCategory;


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
	// Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString:self.urlOfCategory];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.actionBar == nil) {
        self.entity = [SZEntity entityWithKey:self.urlOfCategory name:self.categoryName];
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
        
        SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
        shareOptions.dontShareLocation = YES;
        self.actionBar.shareOptions = shareOptions;
    }
}

@end
