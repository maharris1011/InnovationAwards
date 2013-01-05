//
//  TweetDetailsViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/16/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//
#import "NSDate+Helper.h"
#import "UIImage+Resize.h"
#import "TweetDetailsViewController.h"

@interface TweetDetailsViewController ()


@end

@implementation TweetDetailsViewController

@synthesize screen_name = _screen_name;
@synthesize user_name = _user_name;
@synthesize text = _text;
@synthesize sent_date = _sent_date;
@synthesize created_date = _created_date;
@synthesize profile_url = _profile_url;

- (NSString *)screen_name
{
    NSDictionary *user = [self.tweet objectForKey:@"user"];
    return [user objectForKey:@"screen_name"];
}

- (NSString *)user_name
{
    NSDictionary *user = [self.tweet objectForKey:@"user"];
    return [user objectForKey:@"name"];
}

- (NSString *)text
{
    return [self.tweet objectForKey:@"text"];
}

- (NSString *)sent_date
{
    NSString *sentString = [self.tweet objectForKey:@"created_at"];
    NSDate *sentDate = [NSDate dateFromString:sentString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
    return [NSDate stringForDisplayFromDate:sentDate prefixed:YES alwaysDisplayTime:YES];
}

- (NSString *)profile_url
{
    NSDictionary *user = [self.tweet objectForKey:@"user"];
    NSString *url = [user objectForKey:@"profile_image_url"];
    return url;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView
{
    
    self.tweetTextView.text = self.text;
    self.senderNameLabel.text = self.user_name;
    self.tweetSentDateLabel.text = [NSString stringWithFormat:@"Sent: %@", self.sent_date];
    
    self.senderScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.screen_name];
    UIImage *profileThumb = [[ImageCache sharedStore] imageForKey:self.profile_url];
    self.profileImageView.image = [profileThumb thumbnailImage:48 transparentBorder:1 cornerRadius:5 interpolationQuality:kCGInterpolationDefault];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the background image
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    
    self.tableView.backgroundView = bgImageView;
    
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
    

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
    [self configureView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            // story path, calculate height of the story & resize everything
            NSString *storyText = self.text;
            UIFont *font = [UIFont systemFontOfSize:14.0];
            CGSize initialSize = CGSizeMake(320-40, MAXFLOAT);
            // -40 for cell padding
            CGSize sz = [storyText sizeWithFont:font constrainedToSize:initialSize];
            [self.tweetTextView setFrame:CGRectMake(10, 11, sz.width, sz.height+28)];
            
            // put the date "sent" time just below the tweet text
            [self.tweetSentDateLabel setFrame:CGRectMake(20, self.tweetTextView.bounds.origin.y+self.tweetTextView.bounds.size.height+14, self.tweetSentDateLabel.bounds.size.width, self.tweetSentDateLabel.bounds.size.height)];
            
            return sz.height+74;
        }
        else
        {
            return 91;
        }
    }
    else {
        // otherwise, we have a "regular" cell
        return 44;
    }
}


- (void)viewDidUnload {
    [self setProfileImageView:nil];
    [self setSenderNameLabel:nil];
    [self setSenderScreenNameLabel:nil];
    [self setTweetTextView:nil];
    [self setTweetSentDateLabel:nil];
    [self setTweetTextCell:nil];
    [super viewDidUnload];
}

- (IBAction)replyButtonPressed:(id)sender {
    [_tweetView setInitialText:[NSString stringWithFormat:@"@%@", self.screen_name]];
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)retweetButtonPressed:(id)sender {
    
    NSString *initialText = [NSString stringWithFormat:@"%@ %@",self.screen_name, self.text];
    
    if ([_tweetView setInitialText:initialText] == NO) {
        [_tweetView setInitialText:[initialText substringToIndex:120]];
    }
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)composeButtonPressed:(id)sender {
    [_tweetView setInitialText:@"#ia12"];
    [_tweetView addURL:[NSURL URLWithString:@"http://www.techcolumbusinnovationawards.com"]];
    [self presentModalViewController:_tweetView animated:YES];
    
}
@end
