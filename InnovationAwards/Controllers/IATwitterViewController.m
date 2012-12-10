//
//  IATwitterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "IATwitterViewController.h"

@interface IATwitterViewController ()

@property (strong, nonatomic) NSArray *tweets;

@end

@implementation IATwitterViewController {
    PullToRefreshView *pull;
}

@synthesize tweets = _tweets;

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
    
    // add buttons to the toolbar
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"210-twitterbird.png"]
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(postToTwitter)];
    [self setToolbarItems:[NSArray arrayWithObject:tweetButton]];
    [self.navigationController.toolbar setTintColor:self.navigationController.navigationBar.tintColor];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self reloadFromTwitter];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    @try {
        
        // Configure the cell...
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        NSDictionary *user = [tweet objectForKey:@"user"];
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
        UITextView *textLabel = (UITextView *)[cell viewWithTag:3];
        UILabel *dateLabel = (UILabel *)[cell viewWithTag:4];
        
        nameLabel.attributedText = [user objectForKey:@"name"];
        textLabel.text = [tweet objectForKey:@"text"];
        dateLabel.text = [tweet objectForKey:@"created_at"];
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception  reason]);
    }
    
    return cell;
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadFromTwitter
{
    // call out to Twitter
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"20", @"count",
                          @"#ia12", @"q", @"recent", @"result_type", nil];
    
    [SZTwitterUtils getWithViewController:self
                                     path:@"/1.1/search/tweets.json"
                                   params:dict
                                  success:^(NSDictionary * result){
                                      NSLog(@"We succeeded");
                                      // we have a batch of tweets.  Put those
                                      // into the tweets array
                                      self.tweets = [result objectForKey:@"statuses"];
                                      
                                      [self.tableView reloadData];
                                      [pull finishedLoading];
                                  }
                                  failure:^(NSError *e){
                                      NSLog(@"Error: %@", e);
                                      [pull finishedLoading];
                                  }];
    
}


- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadFromTwitter];
}

- (void)postToTwitter {
    NSString *text = @"The Status";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    
    [SZTwitterUtils postWithViewController:self path:@"/1/statuses/update.json" params:params success:^(id result) {
        NSLog(@"Posted to Twitter feed: %@", result);
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to post to Twitter feed: %@ / %@", [error localizedDescription], [error userInfo]);
    }];
    
}

@end
