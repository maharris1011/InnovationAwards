//
//  CategoryViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "UITableViewController+GradientHeaders.h"
#import "CategoryViewController.h"
#import "AppDelegate.h"
#import "SemifinalistListViewController.h"
#import "IACategory.h"

@interface CategoryViewController () {
    NSArray *_categories;
}
@end

@implementation CategoryViewController

@synthesize categories = _categories;

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
 
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.categories = [delegate sharedCategories];
    
    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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
    // one section total
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // one row per category
    return [self.categories count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...
    IACategory *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", category.name];
    cell.backgroundView = [self gradientViewForCell:cell];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSemifinalistList"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        // find the right URL for the selected index
        IACategory *category = [self.categories objectAtIndex:indexPath.row];
        SemifinalistListViewController *slvc = (SemifinalistListViewController *)[segue destinationViewController];
        slvc.category = category;
    }
    
}



@end
