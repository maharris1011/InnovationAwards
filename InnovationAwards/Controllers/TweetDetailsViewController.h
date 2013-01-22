//
//  TweetDetailsViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/16/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailsViewController : UITableViewController<UIActionSheetDelegate> {
}
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *senderScreenNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong, nonatomic) IBOutlet UILabel *tweetSentDateLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *tweetTextCell;

@property (strong, nonatomic) Tweet *tweet;

- (IBAction)replyButtonPressed:(id)sender;
- (IBAction)retweetButtonPressed:(id)sender;
- (IBAction)composeButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@end
