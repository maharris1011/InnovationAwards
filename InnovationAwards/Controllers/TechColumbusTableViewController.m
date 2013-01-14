//
//  TechColumbusTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/6/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "TechColumbusTableViewController.h"
#import "UIImage+Resize.h"

@interface TechColumbusTableViewController ()

@end

@implementation TechColumbusTableViewController

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
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        // goto the ia 12 web site
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.techcolumbus.org"]];
    }

    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSString *addrTechColumbus = [[NSString stringWithFormat:@"1275 Kinnear Rd., Columbus, OH 43221"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = nil;
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            // open google maps
            url = [NSString stringWithFormat:@"comgooglemaps://?q=%@", addrTechColumbus];
        }
        else
        {
            // open maps in safari
            url = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", addrTechColumbus];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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


@end
