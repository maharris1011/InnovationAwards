//
//  SponsorImageTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/6/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "SponsorImageTableViewController.h"
#import "UIImage+RoundedCorner.h"

@interface SponsorImageTableViewController ()

@end

@implementation SponsorImageTableViewController

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

    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    self.tableView.backgroundView = bgImageView;
    
    UIImage *sponsorsImage = [UIImage imageNamed:@"ia12_sponsors.png"];
    self.sponsorImageView.image = [sponsorsImage roundedCornerImage:15 borderSize:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
    [self setSponsorImageView:nil];
    [super viewDidUnload];
}
@end
