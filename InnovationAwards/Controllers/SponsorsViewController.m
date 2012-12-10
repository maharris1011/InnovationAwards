//
//  SponsorsViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SponsorsViewController.h"


@interface SponsorsDataController : NSObject 

@property (nonatomic, retain) NSDictionary *sponsorshipLevels;

+ (SponsorsDataController *)sharedSponsorsDataController;

@end

// the Singleton
static SponsorsDataController *sharedSponsorsDataController = nil;

@implementation SponsorsDataController

@synthesize sponsorshipLevels = _sponsorshipLevels;

// Implementation
+ (SponsorsDataController *)sharedSponsorsDataController
{
    if (sharedSponsorsDataController == nil)
    {
        // get the file & parse it -- it's JSON in our main directory
        sharedSponsorsDataController = [[SponsorsDataController alloc] init];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"sponsors" ofType:@"json"];
        
        NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"jsonData = %@", jsonData);
        sharedSponsorsDataController.sponsorshipLevels = [jsonData objectFromJSONString];
        NSLog(@"parsed = %@", sharedSponsorsDataController.sponsorshipLevels);
    }
    return sharedSponsorsDataController;
}

@end


@interface SponsorsViewController ()

@end

@implementation SponsorsViewController

@synthesize sponsorshipData = _sponsorshipData;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

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
    // load our data from the file on disk
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"sponsors" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    _sponsorshipData = [jsonData objectFromJSONString];
    NSLog(@"jsonData parsed = %@", _sponsorshipData);
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // one section per sponsorship level
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    return [levelsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    NSDictionary *level = [levelsArray objectAtIndex:section];
    NSArray *sponsors = [level objectForKey:@"sponsors"];
    NSInteger sponsorCount = [sponsors count];
    return sponsorCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SponsorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    NSDictionary *level = [levelsArray objectAtIndex:indexPath.section];
    NSArray *sponsors = [level objectForKey:@"sponsors"];
    
    NSDictionary *sponsor = [sponsors objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [sponsor objectForKey:@"name"];
    cell.detailTextLabel.text = [sponsor objectForKey:@"sponsorship"];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    NSDictionary *level = [levelsArray objectAtIndex:section];
    NSString *levelName = [level objectForKey:@"level"];
    return (levelName == nil) ? @"" : levelName;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
