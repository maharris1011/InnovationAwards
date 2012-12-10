//
//  MasterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize backgroundView = _backgroundView;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"headerBackground.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];

    [self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mainBackground.png"]]];

    NSInteger frameHeight = self.view.bounds.size.height;
    NSInteger locationViewHeight = 140;
    [self.locationView setFrame:CGRectMake(0,frameHeight-locationViewHeight, 320, locationViewHeight)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTwitter"]) {
        // show the twitter screen
    }
}

@end
