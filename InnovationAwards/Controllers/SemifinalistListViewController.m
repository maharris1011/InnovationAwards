//
//  SemifinalistListViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/16/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//
#import "UITableViewController+GradientHeaders.h"
#import "SemifinalistListViewController.h"
#import "SemiFinalistDetailTableViewController.h"
#import "IASemifinalist.h"
#import "AppDelegate.h"
#import "UIImage+Resize.h"

@interface SemifinalistListViewController () {
    IACategory *_category;
}

@end

@implementation SemifinalistListViewController

@synthesize category = _category;


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSemifinalistDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // find the right URL for the selected index
        
        SemifinalistDetailTableViewController *detail = (SemifinalistDetailTableViewController *)[segue destinationViewController];
        detail.category = self.category;
        detail.semifinalist = indexPath.row;
    }
    
}


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
    [bgImageView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.backgroundView = bgImageView;

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section for all semifinalists
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // one row per semifinalist
    return [self.category.semifinalists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NomineeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    IASemifinalist *nominee = [[self.category semifinalists] objectAtIndex:indexPath.row];
    cell.textLabel.text = nominee.company;
    cell.textLabel.font = [UIFont fontWithName:IA_Font size:17];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ia_arrow.png"]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
