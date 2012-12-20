//
//  SemifinalistDetailTableViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SemifinalistDetailTableViewController : UITableViewController

@property NSDictionary *semifinalistData;
@property NSString *categoryName;

@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *representativeNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *companyUrlLabel;
@property (strong, nonatomic) IBOutlet UITextView *storyText;

- (IBAction)followOnTwitterPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;

- (IBAction)connectOnLinkedInPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *linkedInButton;

- (IBAction)likeOnFacebookPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;

@end
