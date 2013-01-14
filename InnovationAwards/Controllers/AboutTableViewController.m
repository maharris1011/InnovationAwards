//
//  AboutTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "AboutTableViewController.h"
#import "UIButton+SSGradient.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

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
    
    // Do any additional setup after loading the view.
    self.versionCell.detailTextLabel.text = [NSString stringWithFormat:@"%@.%@",
                                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];


}

- (void)viewWillAppear:(BOOL)animated
{
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"headerBackgroundRounded.png"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLayoutSubviews
{
    // done button
    NSInteger width = 550;
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        width = 300;
    }
    
    [self.doneButton setFrame:CGRectMake(0, 0, width, 45)];
    
    CAGradientLayer *gradient = buttonGradientWithColor(lightPurple, darkPurple);
    [self.doneButton addGradient:gradient];
    self.doneButton.layer.borderColor = darkPurple.CGColor;
    self.doneButton.layer.borderWidth = 1;
    self.doneButton.layer.masksToBounds = YES;
    self.doneButton.titleLabel.font = [UIFont fontWithName:IA_Font600 size:15.0];
    self.doneButton.titleLabel.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// using static cells, so don't need any of the tableview delegate/datasource stuff

- (void)viewDidUnload {
    [self setVersionCell:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -- UITableViewDelegate methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.techcolumbus.org"]];
        }
        if (indexPath.row == 1) {
            NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?q=1275+Kinnear+Road,+Columbus,+Ohio,+43221"];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    if (indexPath.section == 1)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/237563402993296"]];
        }
        else
        {
            // goto the ia 12 web site
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/Sandlot.Software"]];
        }
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
        // now create the header label
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 22)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,[UIScreen mainScreen].bounds.size.width,22)];
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
@end
