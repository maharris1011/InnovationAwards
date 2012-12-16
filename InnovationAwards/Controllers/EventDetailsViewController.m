//
//  EventDetailsViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "UIButton+SSGradient.h"

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the background image
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, 1136)];
    
    self.tableView.backgroundView = bgImageView;
    [self.buttonDone addGradient:buttonGradientWithColor(darkPurple, lightPurple)];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"headerBackground.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return @"The Event";
            
        default:
            return nil;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // now create the header label
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,320,22)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = IA_headlineBold;
    headerLabel.shadowOffset = CGSizeMake(1, 1);
    headerLabel.textColor = yellowText;
    headerLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [view addSubview:headerLabel];
    return view;
    
}

- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setButtonDone:nil];
    [super viewDidUnload];
}
@end
