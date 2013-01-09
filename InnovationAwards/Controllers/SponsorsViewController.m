//
//  SponsorsViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SponsorsViewController.h"
#import "UITableViewController+GradientHeaders.h"


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

    // load our data from the file on disk
    
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"2012_sponsors" ofType:@"json"];
    NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    _sponsorshipData = [jsonData objectFromJSONString];

    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SponsorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    NSDictionary *level = [levelsArray objectAtIndex:indexPath.section];
    NSArray *sponsors = [level objectForKey:@"sponsors"];
    
    NSDictionary *sponsor = [sponsors objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [sponsor objectForKey:@"name"];
    NSString *sponsorship = [sponsor objectForKey:@"sponsorship"];
    if ([sponsorship length] == 0) {
        cell.detailTextLabel.text = [sponsor objectForKey:@"url"];
    }
    else
    {
        cell.detailTextLabel.text = sponsorship;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
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
    return [self gradientHeaderViewForSection:section];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // fire up the browser to show the URL of the sponsor
    NSArray *levelsArray = [self.sponsorshipData objectForKey:@"levels"];
    NSDictionary *level = [levelsArray objectAtIndex:indexPath.section];
    NSArray *sponsors = [level objectForKey:@"sponsors"];
    NSDictionary *sponsor = [sponsors objectAtIndex:indexPath.row];
    NSString *urlString = [sponsor objectForKey:@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    
    
}

@end
