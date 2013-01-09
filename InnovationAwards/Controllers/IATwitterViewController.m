//
//  IATwitterViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "IATwitterViewController.h"
#import "ASIHTTPRequest.h"
#import "UIImage+Resize.h"
#import "UITableViewController+GradientHeaders.h"
#import "NSDate+Helper.h"
#import "TweetDetailsViewController.h"
#import "Tweet.h"
#import <Twitter/Twitter.h>

@interface IATwitterViewController () 

@property (nonatomic, strong) NSArray *tweets;

@end

@implementation IATwitterViewController {
    PullToRefreshView *pull;
    TWTweetComposeViewController *_tweetView;
    NSString *_szTwitterUrl;
    NSArray *_tweets;
}

@synthesize tweets = _tweets;

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
  _tweetView = nil;
  _pull = nil;
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
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
   
    // set up our communication with Twitter
    _tweetView = [[TWTweetComposeViewController alloc] init];
    
    TWTweetComposeViewControllerCompletionHandler completionHandler =
    ^(TWTweetComposeViewControllerResult result) {
        NSString *output = @"Unknown Response from Twitter";
        switch (result)
        {
            case TWTweetComposeViewControllerResultCancelled:
                NSLog(@"Twitter Result: canceled");
                output = @"Tweet Cancelled.";
                break;
            case TWTweetComposeViewControllerResultDone:
                NSLog(@"Twitter Result: sent");
                output = @"Tweet Sent!"; 
                break;
            default:
                NSLog("@unknown result from Twitter %@", result);
                break;
        }
        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        [self dismissModalViewControllerAnimated:YES];
    };

    [_tweetView setCompletionHandler:completionHandler];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self reloadFromTwitter];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self foregroundRefresh];
    self.navigationController.toolbarHidden = NO;
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

    UIImageView *profile = (UIImageView*)[cell viewWithTag:4];
    UILabel *name = (UILabel*)[cell viewWithTag:1];
    UILabel *tweetText = (UILabel*)[cell viewWithTag:2];
    UILabel *sentOn = (UILabel*)[cell viewWithTag:3];
    UILabel *userAt = (UILabel *)[cell viewWithTag:5];
   
    // set up the tableview cell
    tweetText.text = tweet.text;
    name.text = tweetText.name;
    sentOn.text = [NSString stringWithFormat:@"Sent: %@", [NSDate stringForDisplayFromDate:tweet.createdAt prefixed:YES alwaysDisplayTime:YES]];
    userAt.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    profile.image = [tweet.profileImage thumbnailImage:48 transparentBorder:1 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
    
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
  // set up a TWRequest object
  TWRequest *getRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.twitter.com/1.1/search/tweets.json"] 
                                              parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        @"20", @"count",
                                                                        @"#ia12 include:retweets", @"q", 
                                                                        @"recent", @"result_type", nil]
                                           requestMethod:TWRequestMethodGET];
  [getRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        NSString *output;
        
        if ([urlResponse statusCode] == 200) 
        {
            // We should be getting back a JSON response of a dictionary of tweets called "statuses"
            NSError *jsonParsingError = nil;
            NSDictionary *tweetsDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSArray *statuses = [tweetsDict objectForKey:@"statuses"];
            
            // put the statuses into our array
            self.tweets = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *status in statuses)
            {
                [self.tweets addObject:[[Tweet alloc] initFromDictionary:status];
            }
        }
        else
        {
            NSLog(@"reloadFromTwitter got response: %@", urlResponse);
            NSString *output = [NSString stringWithFormat:@"reloadFromTwitter: HTTP response status: %i", [urlResponse statusCode]];
            [self performSelectorOnMainThread:@selector(displayText:) withObject:response waitUntilDone:NO]; 
        }

        // update the UI
        [self.tableView reloadData];
        [pull finishedLoading];
  }
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadFromTwitter];
}

- (IBAction)composeButtonPressed:(id)sender
{
    [_tweetView setInitialText:@"#ia12"];
    [_tweetView addURL:[NSURL URLWithString:@"http://www.techcolumbusinnovationawards.com"]];
    [self presentModalViewController:_tweetView animated:YES];
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
            szTwitterWebUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            // in all cases, we just load in safari, because we can't trust they have the app
            NSURL *url = [NSURL URLWithString:szTwitterWebUrl];
            [[UIApplication sharedApplication] openURL:url];
        } 
    }

}

@end
