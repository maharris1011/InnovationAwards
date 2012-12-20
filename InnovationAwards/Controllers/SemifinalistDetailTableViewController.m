//
//  SemifinalistDetailTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemifinalistDetailTableViewController.h"

@interface SemifinalistDetailTableViewController ()

@end

@implementation SemifinalistDetailTableViewController

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
    // set the labels accordingly
    self.categoryNameLabel.text = self.categoryName;
    if (self.semifinalistData) {
        NSLog(@"%@", self.semifinalistData);
            
        self.companyNameLabel.text = [self.semifinalistData objectForKey:@"name"];
        self.representativeNameLabel.text = [self.semifinalistData objectForKey:@"rep_name"];
        self.companyNameLabel.text = [self.semifinalistData objectForKey:@"url"];
        self.storyText.text = [self.semifinalistData objectForKey:@"story"];
        
        self.twitterButton.enabled = [self.semifinalistData objectForKey:@"company_twitter"] != nil;
        self.facebookButton.enabled = [self.semifinalistData objectForKey:@"company_facebook"] != nil;
        self.linkedInButton.enabled = [self.semifinalistData objectForKey:@"personal_linkedin"] != nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
    [self setCompanyNameLabel:nil];
    [self setRepresentativeNameLabel:nil];
    [self setCompanyUrlLabel:nil];
    [self setStoryText:nil];
    [self setTwitterButton:nil];
    [self setLinkedInButton:nil];
    [self setFacebookButton:nil];
    [self setCategoryNameLabel:nil];
    [super viewDidUnload];
}

- (IBAction)followOnTwitterPressed:(id)sender {
    // open up the twitter app if we can
}

- (IBAction)connectOnLinkedInPressed:(id)sender {
    // open up the linkedin app to the user's page
}

- (IBAction)likeOnFacebookPressed:(id)sender {
    // open up facebook app to the user's facebook page
}
@end
