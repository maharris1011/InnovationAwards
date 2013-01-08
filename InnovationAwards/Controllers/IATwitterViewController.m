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
#import <Twitter/Twitter.h>

@interface IATwitterViewController () {
    NSArray *_tweets;
    NSString *_szUrl;
    NSString *_szTwitterUrl;
}

@property (nonatomic, strong) NSArray *tweets;

@end

@implementation IATwitterViewController {
    PullToRefreshView *pull;
    TWTweetComposeViewController *_tweetView;
}

@synthesize tweets = _tweets;

#pragma mark -- utilities
- (void)asynchronousGetImageAtUrl:(NSString *)url onComplete:(void(^)(UIImage *image))complete
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:[request responseData]];
            
            if (complete) {
                complete(image);
            }
        });
    }];
    [request startAsynchronous];
}


#pragma mark -- UIViewController stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // find the right URL for the selected index
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    self.tableView.backgroundView = bgImageView;

    // for when we "open from safari"
    NSString *query = @"https://m.twitter.com/search?q=#ia12 include:retweets&src=typd";
    _szUrl = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    _tweetView = [[TWTweetComposeViewController alloc] init];
    
    TWTweetComposeViewControllerCompletionHandler completionHandler =
    ^(TWTweetComposeViewControllerResult result) {
        switch (result)
        {
            case TWTweetComposeViewControllerResultCancelled:
                NSLog(@"Twitter Result: canceled");
                break;
            case TWTweetComposeViewControllerResultDone:
                NSLog(@"Twitter Result: sent");
                break;
            default:
                NSLog(@"Twitter Result: default");
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    };
    [_tweetView setCompletionHandler:completionHandler];
    
    [self foregroundRefresh:nil];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self reloadFromTwitter];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    self.navigationController.toolbarHidden = YES;
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
    static NSString *CellIdentifier = @"BetterTweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    NSDictionary *user = [tweet objectForKey:@"user"];

    __block UIImageView *profile = (UIImageView*)[cell viewWithTag:4];
    UILabel *name = (UILabel*)[cell viewWithTag:1];
    UILabel *tweetText = (UILabel*)[cell viewWithTag:2];
    UILabel *sentOn = (UILabel*)[cell viewWithTag:3];
    UILabel *userAt = (UILabel *)[cell viewWithTag:5];
    
    tweetText.text = [tweet objectForKey:@"text"];
    tweetText.adjustsFontSizeToFitWidth = YES;
    name.text = [user objectForKey:@"name"];
    NSString *sentString = [tweet objectForKey:@"created_at"];
    NSDate *sentDate = [NSDate dateFromString:sentString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
    sentOn.text = [NSString stringWithFormat:@"Sent: %@", [NSDate stringForDisplayFromDate:sentDate prefixed:YES alwaysDisplayTime:YES]];
    userAt.text = [NSString stringWithFormat:@"@%@", [user objectForKey:@"screen_name"]];
    
    __block NSString *url = [user objectForKey:@"profile_image_url"];
    __block UIImage *profileThumb = [[ImageCache sharedStore] imageForKey:url];
    // use default image for now
    if (profileThumb == nil)
    {        
        // get the photo from the web
        [self asynchronousGetImageAtUrl:url onComplete:^(UIImage *image) {
            if (image != nil) {
                [[ImageCache sharedStore] setImage:image forKey:url];
                profileThumb = image;
                profile.image = [profileThumb thumbnailImage:48 transparentBorder:1 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];
            }
        }];
    }
    profile.image = [profileThumb thumbnailImage:48 transparentBorder:1 cornerRadius:5 interpolationQuality:kCGInterpolationHigh];

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
    // call out to Twitter
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"20", @"count",
                          @"#ia12 include:retweets", @"q", @"recent", @"result_type", nil];
    
    [SZTwitterUtils getWithViewController:self
                                     path:@"/1.1/search/tweets.json"
                                   params:dict
                                  success:^(NSDictionary * result){
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

- (IBAction)composeButtonPressed:(id)sender
{
    [_tweetView setInitialText:@"#ia12"];
    [_tweetView addURL:[NSURL URLWithString:@"http://www.techcolumbusinnovationawards.com"]];
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)actionButtonPressed:(id)sender
{
    // show dialog for open in facebook app and open in safari
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        // 1 = open in safari
        NSURL *url = [NSURL URLWithString:_szUrl];
        
        // check it's open-able and open it!
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }

}



@end
