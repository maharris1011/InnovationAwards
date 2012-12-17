//
//  TweetDetailsViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/16/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>

@interface TweetDetailsViewController : UITableViewController {
    TWTweetComposeViewController *_tweetView;
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *senderName;
@property (strong, nonatomic) IBOutlet UILabel *senderScreenName;
@property (strong, nonatomic) IBOutlet UITextView *tweetText;
@property (strong, nonatomic) IBOutlet UILabel *tweetSent;

@property (strong, nonatomic) NSDictionary *tweet;
- (IBAction)replyButtonPressed:(id)sender;
- (IBAction)retweetButtonPressed:(id)sender;
- (IBAction)composeButtonPressed:(id)sender;

@end
