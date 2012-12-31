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

@interface CategoryViewController () {
    NSDictionary *_categories;
}

@property (nonatomic, strong) NSDictionary *categories;
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
    self.categories = [delegate sharedCategoryData];
    
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
    NSArray *categories = [self.categories objectForKey:@"categories"];
    return [categories count];
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
    NSArray *categories = [self.categories objectForKey:@"categories"];
    NSDictionary *category = [categories objectAtIndex:indexPath.row];
    NSString *categoryName = [category objectForKey:@"category"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", categoryName];
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
        NSArray *categories = [self.categories objectForKey:@"categories"];
        NSDictionary *category = [categories objectAtIndex:indexPath.row];
        SemifinalistListViewController *semifinalists = (SemifinalistListViewController *)[segue destinationViewController];
        semifinalists.category = category;
    }
    
}



@end
