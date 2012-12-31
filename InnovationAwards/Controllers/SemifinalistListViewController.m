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
#import "AppDelegate.h"

@interface SemifinalistListViewController () {
    NSDictionary *_category;
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
        
        detail.categoryName = [self.category objectForKey:@"category"];
        detail.categoryURL = [self.category objectForKey:@"URL"];
        NSArray *semifinalistList = [self.category objectForKey:@"semifinalists"];
        NSString *semifinalistName = [semifinalistList objectAtIndex:indexPath.row];
        
        AppDelegate *myapp = [[UIApplication sharedApplication] delegate];
        NSDictionary *semifinalist_detail_object = [myapp sharedSemifinalistDetail];
        NSDictionary *semifinalist_detail = [semifinalist_detail_object objectForKey:semifinalistName];
        detail.semifinalistData = semifinalist_detail;
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section for all semifinalists
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *nominees = [self.category objectForKey:@"semifinalists"];
    return [nominees count];
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
    NSArray *nominees = [self.category objectForKey:@"semifinalists"];
    NSString *nominee = [nominees objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", nominee];
    cell.backgroundView = [self gradientViewForCell:cell];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
