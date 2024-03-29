//
//  SemifinalistDetailTableViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Socialize/Socialize.h>
#import "IACategory.h"
#import "IASemifinalist.h"

@interface SemifinalistDetailTableViewController : UITableViewController

// data properties
@property IACategory *category;
@property NSInteger semifinalist;

// UI properties
@property (nonatomic, strong) SZActionBar *actionBar;
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *representativeNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *companyUrlLabel;
@property (strong, nonatomic) IBOutlet UILabel *storyTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *awardWinnerLabel;

- (IBAction)nextPrevPressed:(id)sender;
@end
