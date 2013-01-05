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
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderScreenNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong, nonatomic) IBOutlet UILabel *tweetSentDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *tweetTextCell;

@property (strong, nonatomic) NSDictionary *tweet;

@property (strong, nonatomic, readonly) NSString *screen_name;
@property (strong, nonatomic, readonly) NSString *user_name;
@property (strong, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) NSString *sent_date;
@property (strong, nonatomic, readonly) NSString *created_date;
@property (strong, nonatomic, readonly) NSString *profile_url;

- (IBAction)replyButtonPressed:(id)sender;
- (IBAction)retweetButtonPressed:(id)sender;
- (IBAction)composeButtonPressed:(id)sender;

@end
