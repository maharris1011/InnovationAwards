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

    NSDictionary *user = [self.tweet objectForKey:@"user"];

    self.tweetText.text = [self.tweet objectForKey:@"text"];
    self.senderName.text = [user objectForKey:@"name"];
    
    NSString *sentString = [self.tweet objectForKey:@"created_at"];
    NSDate *sentDate = [NSDate dateFromString:sentString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
    self.tweetSent.text = [NSString stringWithFormat:@"Sent: %@", [NSDate stringForDisplayFromDate:sentDate prefixed:YES alwaysDisplayTime:YES]];
    
    self.senderScreenName.text = [NSString stringWithFormat:@"@%@", [user objectForKey:@"screen_name"]];
    
    NSString *url = [user objectForKey:@"profile_image_url"];
    UIImage *profileThumb = [[ImageCache sharedStore] imageForKey:url];
    self.profileImage.image = [profileThumb thumbnailImage:48 transparentBorder:1 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];
    
    
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)viewDidUnload {
    [self setProfileImage:nil];
    [self setSenderName:nil];
    [self setSenderScreenName:nil];
    [self setTweetText:nil];
    [self setTweetSent:nil];
    [super viewDidUnload];
}

- (IBAction)replyButtonPressed:(id)sender {
    [_tweetView setInitialText:[NSString stringWithFormat:@"%@", self.senderScreenName.text]];
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)retweetButtonPressed:(id)sender {
    [_tweetView setInitialText:[NSString stringWithFormat:@"\"%@%@\"", self.senderScreenName.text, self.tweetText.text]];
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)composeButtonPressed:(id)sender {
    [_tweetView setInitialText:@"#ia12"];
    [_tweetView addURL:[NSURL URLWithString:@"http://www.techcolumbusinnovationawards.com"]];
    [self presentModalViewController:_tweetView animated:YES];
    
}
@end
