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
#import <SDWebImage/UIImageView+WebCache.h>

@interface TweetDetailsViewController ()


@end

@implementation TweetDetailsViewController

@synthesize tweet = _tweet;

- (NSString *)sent_date
{
    return [NSDate stringForDisplayFromDate:self.tweet.createdAt prefixed:YES alwaysDisplayTime:YES];
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
    
    self.tweetTextView.text = self.tweet.text;
    self.senderNameLabel.text = self.tweet.name;
    self.tweetSentDateLabel.text = [NSString stringWithFormat:@"Sent: %@", self.tweet.createdAtString];
    
    self.senderScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.screenName];

    NSString *url = self.tweet.normalProfileImageURL;
    __block UIActivityIndicatorView *activityIndicator = nil;
    if (nil != url)
    {
        [self.profileImageView addSubview:activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
        activityIndicator.center = self.profileImageView.center;
        [activityIndicator startAnimating];
        
        [self.profileImageView setImageWithURL:[NSURL URLWithString:url]
                placeholderImage:[UIImage imageNamed:@"twitter-bird-blue-on-white.png"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [activityIndicator removeFromSuperview];
             activityIndicator = nil;
         }];
    }
    
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the background image
    UIImage *bgImage = [UIImage imageNamed:@"mainBackground.png"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgImageView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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
            NSString *storyText = self.tweet.text;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}


#pragma mark -- UIActions

- (IBAction)replyButtonPressed:(id)sender 
{
    [_tweetView setInitialText:[NSString stringWithFormat:@"@%@", self.tweet.screenName]];
    [self presentModalViewController:_tweetView animated:YES];
}

- (IBAction)retweetButtonPressed:(id)sender {
    
    NSString *initialText = [NSString stringWithFormat:@"%@ %@",self.tweet.screenName, self.tweet.text];
    
    if ([_tweetView setInitialText:initialText] == NO) 
    {
        [_tweetView setInitialText:[initialText substringToIndex:MIN(120, [initialText length])]];
    }
    [self presentModalViewController:_tweetView animated:YES];
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
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"" 
                                                    delegate:self 
                                           cancelButtonTitle:@"Cancel" 
                                      destructiveButtonTitle:nil 
                                           otherButtonTitles:@"Open in Safari", @"Open in Twitter", nil];
    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [as showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex])
    {
        NSString *szUrl = nil;
        
        switch (buttonIndex)
        {
            case 0:
                // open twitter in safari
                szUrl = [NSString stringWithFormat:@"http://mobile.twitter.com"];
                break;
                
            case 1:
                // open in Twitter
                szUrl = [NSString stringWithFormat:@"twitter://status?id=%@", self.tweet.identifier];
                break;
                
            default:
                break;
        }
        
        if (nil != szUrl) 
        {
            NSURL *url = [NSURL URLWithString:szUrl];
            
            // check it's open-able and open it!
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
}

@end
