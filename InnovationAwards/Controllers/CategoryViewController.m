//
//  CategoryViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "UITableViewController+GradientHeaders.h"
#import "CategoryViewController.h"
#import "SemiFinalistDetailViewController.h"

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"semifinalists" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    self.categories = [jsonData objectFromJSONString];
    NSLog(@"jsonData parsed = %@", self.categories);
    
    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, 1136)];
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
    // one section per category
    NSArray *categories = [self.categories objectForKey:@"categories"];
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // one row per nominee in the category
    NSArray *categories = [self.categories objectForKey:@"categories"];
    NSDictionary *category = [categories objectAtIndex:section];
    NSArray *nominees = [category objectForKey:@"semifinalists"];
    return [nominees count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *categories = [self.categories objectForKey:@"categories"];
    NSDictionary *category = [categories objectAtIndex:indexPath.section];
    NSArray *nominees = [category objectForKey:@"semifinalists"];

    NSString *nominee = [nominees objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", nominee];
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *categories = [self.categories objectForKey:@"categories"];
    NSDictionary *category = [categories objectAtIndex:section];
    
    NSString *categoryName = [category objectForKey:@"category"];
    return categoryName;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self gradientHeaderViewForSection:section];

    
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCategoryWeb"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // find the right URL for the selected index
        NSArray *categories = [self.categories objectForKey:@"categories"];
        NSDictionary *category = [categories objectAtIndex:indexPath.section];
        
        NSString *url = [category objectForKey:@"URL"];

        SemiFinalistDetailViewController *detail = (SemiFinalistDetailViewController *)[segue destinationViewController];
        detail.urlOfCategory = url;
        detail.categoryName = [category objectForKey:@"category"];
    }

}

@end
