//
//  EventDetailsViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"

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
    [bgImageView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    
    self.tableView.backgroundView = bgImageView;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 0) {
        // goto the ia 12 web site
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.techcolumbus.org"]];
    }
}

- (void)viewDidUnload {
    [self setSponsorsImageView:nil];
    [super viewDidUnload];
}
@end
