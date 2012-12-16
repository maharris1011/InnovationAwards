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

@interface IATwitterViewController () {
    NSArray *_tweets;
}

@property (nonatomic, strong) NSArray *tweets;

- (void)postToTwitter:(NSString *)text;


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

    // adjust the background view to match
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, 1136)];
    self.tableView.backgroundView = bgImageView;
    
    // add buttons to the toolbar
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showCommentComposer)];

    [self setToolbarItems:[NSArray arrayWithObject:tweetButton]];
    [self.navigationController.toolbar setTintColor:[UIColor blackColor]];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
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
    static NSString *CellIdentifier = @"BetterTweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    NSDictionary *user = [tweet objectForKey:@"user"];

    UIImageView *profile = (UIImageView*)[cell viewWithTag:4];
    UILabel *name = (UILabel*)[cell viewWithTag:1];
    UILabel *tweetText = (UILabel*)[cell viewWithTag:2];
    UILabel *sentOn = (UILabel*)[cell viewWithTag:3];
    UILabel *userAt = (UILabel *)[cell viewWithTag:5];
    
    tweetText.text = [tweet objectForKey:@"text"];
    tweetText.adjustsFontSizeToFitWidth = YES;
    name.text = [user objectForKey:@"name"];
    NSString *sentString = [tweet objectForKey:@"created_at"];
    NSDate *sentDate = [NSDate dateFromString:sentString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
    sentOn.text = [NSString stringWithFormat:@"Sent On: %@", [NSDate stringForDisplayFromDate:sentDate prefixed:YES alwaysDisplayTime:YES]];
    userAt.text = [NSString stringWithFormat:@"@%@", [user objectForKey:@"screen_name"]];
    
    NSString *url = [user objectForKey:@"profile_image_url"];
    UIImage *profileThumb = [[ImageCache sharedStore] imageForKey:url];
    profile.image = [profileThumb thumbnailImage:50 transparentBorder:1 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];

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

- (void)postToTwitter:(NSString *)text
{
    NSString *withTag = [NSString stringWithFormat:@"%@ #ia12", text];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:withTag forKey:@"status"];
    
    [SZTwitterUtils postWithViewController:self path:@"/1/statuses/update.json" params:params success:^(id result) {
        NSLog(@"Posted to Twitter feed: %@", result);
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to post to Twitter feed: %@ / %@", [error localizedDescription], [error userInfo]);
    }];
    
}

- (void)showCommentComposer
{
    SZEntity *entity = [SZEntity entityWithKey:@"http://www.techcolumbusinnovationawards.com" name:@"IA2012"];
    [SZCommentUtils showCommentComposerWithViewController:self entity:entity completion:^(id<SZComment> comment) {
        NSLog(@"Created comment: %@", [comment text]);
        [self postToTwitter:[comment text]];
    } cancellation:^{
        NSLog(@"Cancelled comment create");
    }];
}


@end
