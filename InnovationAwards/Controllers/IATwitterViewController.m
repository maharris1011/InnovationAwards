//
//  IATwitterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "IATwitterViewController.h"
#import "ASIHTTPRequest.h"
#import "UIImage+RoundedCorner.h"
#import "UITableViewController+GradientHeaders.h"
#import "NSDate+Helper.h"
#import "TweetDetailsViewController.h"
#import "Tweet.h"
#import <Social/SLRequest.h>

@interface IATwitterViewController () 


@end

@implementation IATwitterViewController {
    PullToRefreshView *_pull;
    NSString *_szTwitterUrl;
    NSArray *_tweets;
}

@synthesize tweets = _tweets;
@synthesize pull = _pull;

#pragma mark -- UIViewController stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // find the right URL for the selected index
        Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
        TweetDetailsViewController *tweetDetails = (TweetDetailsViewController *)[segue destinationViewController];
        tweetDetails.tweet = tweet;
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


- (void)viewDidUnload
{
  // be kind to memory
    
    [self setPull:nil];
    [self setTweets:nil];
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.backgroundView = bgImageView;

    // set up our pullToRefresh mechanism
    _pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [_pull setDelegate:self];
    [self.tableView addSubview:_pull];

    // always refresh when we come back to the view
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
   
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [_pull setState:PullToRefreshViewStateLoading];
    [self reloadFromTwitter];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self foregroundRefresh:nil];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    static NSString *CellIdentifier = @"BetterTweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];

    __block UIImageView *profile = (UIImageView*)[cell viewWithTag:4];
    UILabel *name = (UILabel*)[cell viewWithTag:1];
    UILabel *tweetText = (UILabel*)[cell viewWithTag:2];
    UILabel *sentOn = (UILabel*)[cell viewWithTag:3];
    UILabel *userAt = (UILabel *)[cell viewWithTag:5];
   
    // set up the tableview cell
    tweetText.text = tweet.text;
    name.text = tweet.name;
    sentOn.text = [NSString stringWithFormat:@"Sent: %@", tweet.createdAtString];
    userAt.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    
    if (nil != tweet.normalProfileImageURL)
    {
        __block UIActivityIndicatorView *activityIndicator;
        [profile addSubview:activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        activityIndicator.center = profile.center;
        [activityIndicator startAnimating];
        
        [profile setImageWithURL:[NSURL URLWithString:tweet.normalProfileImageURL]
                placeholderImage:[UIImage imageNamed:@"twitter-bird-blue-on-white.png"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                       {
                           [activityIndicator removeFromSuperview];
                           activityIndicator = nil;
                       }];
    }
    
    // set up the background
    UIView *bgView = [self gradientViewForCell:cell];
    [cell insertSubview:bgView atIndex:0];
    
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
    [SZTwitterUtils getWithViewController:self path:@"/1.1/search/tweets.json"
                                   params:[NSDictionary dictionaryWithObjectsAndKeys:                                                                                                                                                                                                                                              @"#ia12 include:retweets", @"q",                                                                                                                                                                                                                                              @"20", @"count",                                                                                                                                                                                                                                              @"recent", @"result_type", nil]
                                  success:^(id result) {
                                      // We should be getting back a JSON response of a dictionary of tweets called "statuses"
                                      NSDictionary *tweetsDict = (NSDictionary *)result;
                                      NSArray *statuses = [tweetsDict objectForKey:@"statuses"];
                                      
                                      // put the statuses into our array
                                      NSMutableArray *newTweets = [[NSMutableArray alloc] initWithCapacity:0];
                                      for (NSDictionary *status in statuses)
                                      {
                                          [newTweets addObject:[[Tweet alloc] initFromDictionary:status]];
                                      }
                                      self.tweets = newTweets;
                                      
                                      // update the UI
                                      [self.tableView reloadData];
                                      [_pull finishedLoading];

                                   } failure:^(NSError *error){
                                       NSLog(@"reloadFromTwitter got response: %@", error.localizedDescription);
                                       NSString *output = [NSString stringWithFormat:@"reloadFromTwitter: HTTP response status: %@", error.localizedDescription];
                                       [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];

                                       // update the UI
                                       [self.tableView reloadData];
                                       [_pull finishedLoading];

                                   }];
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadFromTwitter];
}

#pragma mark -- UIActions

- (SLComposeViewController *)createTweetSheet
{
    SLComposeViewController *tweetSheet = nil;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    }
    return tweetSheet;
}

- (IBAction)composeButtonPressed:(id)sender
{
    SLComposeViewController *slcvc = [self createTweetSheet];
    if (slcvc != nil) {
        // a little preconfiguration
        [slcvc setInitialText:@"#ia12"];
        [slcvc addURL:[NSURL URLWithString:@"http://www.techcolumbusinnovationawards.com"]];
        
        // show the sheet & get the tweet sent
        [self presentModalViewController:slcvc animated:YES];
    }
}

- (IBAction)actionButtonPressed:(id)sender
{
    // show dialog for open in safari
    // the twitter app doesn't have a URL scheme that supports showing arbitrary hashtags
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" 
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                      destructiveButtonTitle:nil 
                                           otherButtonTitles:@"Open in Safari", nil];
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        if (buttonIndex == 0)
        {
            // use mobile site because it's nice
            NSString *query = @"https://m.twitter.com/search?q=#ia12 include:retweets&src=typd";
            NSString *szTwitterWebUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            // in all cases, we just load in safari, because we can't trust they have the app
            NSURL *url = [NSURL URLWithString:szTwitterWebUrl];
            [[UIApplication sharedApplication] openURL:url];
        } 
    }

}

- (void)displayText:(NSString *)output
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IA2012"
                                                    message:output
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
