    //
//  SemifinalistDetailTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemifinalistDetailTableViewController.h"
#import "AppDelegate.h"
#import "NSString+SocialMediaParsers.h"

@interface SemifinalistDetailTableViewController ()
@property IASemifinalist *sfCurrent;

- (void)setupSocializeEntity;
@end

@implementation SemifinalistDetailTableViewController
@synthesize actionBar = _actionBar;
@synthesize sfCurrent = _sfCurrent;

- (void)setSfCurrent:(IASemifinalist *)sfCurrent
{
    _sfCurrent = sfCurrent;
    [self configureView];
    [self.tableView reloadData];
    [self setupSocializeEntity];
}

- (IASemifinalist *)sfCurrent
{
    return _sfCurrent;
}

- (void)setupSocializeEntity
{
    NSString *key = [NSString stringWithFormat:@"%@#%@", self.category.url, self.sfCurrent.company];
    SZEntity *entity = [SZEntity entityWithKey:key name:self.sfCurrent.company];
    
    SZShareOptions *options = [SZShareUtils userShareOptions];
    options.dontShareLocation = NO;
    options.willAttemptPostingToSocialNetworkBlock = ^(SZSocialNetwork network, SZSocialNetworkPostData *postData)
    {
        NSString *displayName = [postData.entity displayName];
        
        if (network == SZSocialNetworkFacebook)
        {
            NSString *customStatus = [NSString stringWithFormat:@"%@ was nominated for a TechColumbus Innovation Award.", displayName];
            [postData.params setObject:customStatus forKey:@"message"];
        }
        if (network == SZSocialNetworkTwitter)
        {
            NSString *entityURL = [[postData.propagationInfo objectForKey:@"twitter"] objectForKey:@"entity_url"];
            NSString *customStatus = [NSString stringWithFormat:@"%@ was nominated for an Innovation Award %@", displayName, entityURL];
            
            [postData.params setObject:customStatus forKey:@"status"];
        }
    };
    
    if (self.actionBar == nil)
    {
        self.actionBar = [SZActionBarUtils showActionBarWithViewController:self.parentViewController entity:entity options:options];
    }
    else
    {
        self.actionBar.entity = entity;
    }
    self.actionBar.shareOptions = options;

    // set up the sharing meta-data
    [self setMetaData:entity];
    
    [SZEntityUtils addEntity:entity success:^(id<SZEntity> serverEntity) {
        NSLog(@"Successfully updated entity meta: %@", [serverEntity meta]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
    
}

- (void)setMetaData:(SZEntity *)entity
{
    // meta-data for when we share
    NSString *title = self.sfCurrent.company;
    NSString *description = [NSString stringWithFormat:@"Check out Innovation Awards, the easiest way to participate in the 2012 Innovation Awards now and through the year"];
    NSString *thumb = self.sfCurrent.image_path;
    NSDictionary *params;
    if (thumb == nil) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  title, @"szsd_title",
                  description, @"szsd_description",
                  nil];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  title, @"szsd_title",
                  description, @"szsd_description",
                  thumb, @"szsd_thumb",
                  nil];
    }
    
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    if (!error)
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        entity.meta = jsonString;
    }
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
    // set the labels accordingly
    
    // name label
    self.categoryNameLabel.text = self.category.name;
    self.companyNameLabel.text = self.sfCurrent.company;
    self.representativeNameLabel.text = self.sfCurrent.contact;
    self.companyUrlLabel.text = self.sfCurrent.site_url;

    // story row
    self.storyTextLabel.text = self.sfCurrent.bio;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sfCurrent = [self.category.semifinalists objectAtIndex:self.semifinalist];
    if (self.actionBar == nil) {
        [self setupSocializeEntity];
    }
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCompanyNameLabel:nil];
    [self setRepresentativeNameLabel:nil];
    [self setCompanyUrlLabel:nil];
    [self setCategoryNameLabel:nil];
    [self setStoryTextLabel:nil];
    [self setActionBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.actionBar setHidden:NO];
    [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.actionBar != nil) {
        [self.actionBar setHidden:YES];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}


-(NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Table view delegate
- (void)openNativeURL:(NSString *)nativeURL orWebURL:(NSString *)webURL
{
    if ([nativeURL length] > 0)
    {
        NSURL *nativeURLObject = [NSURL URLWithString:nativeURL];
        
        if ([[UIApplication sharedApplication] canOpenURL:nativeURLObject])
        {
            NSLog(@"opening native url '%@'", nativeURL);
            [[UIApplication sharedApplication] openURL:nativeURLObject];
        }
        else
        {
            if ([webURL length] > 0)
            {
                NSLog(@"Opening web url '%@'", webURL);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
        }
    }
    else if ([webURL length] > 0)
    {
        NSLog(@"Opening web url '%@'", webURL);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 1)
    {
        if (cell.tag == 500) // company site
        {
            [self openNativeURL:nil orWebURL:self.sfCurrent.site_url];
        }
        if (cell.tag == 502) // facebook
        {
            // we would open in the fb app, but the fb protocol requires the fb ID of the profile, not screen name
            [self openNativeURL:nil orWebURL:self.sfCurrent.facebook];
        }
        if (cell.tag == 501) // linkedIn
        {
            [self openNativeURL:nil orWebURL:self.sfCurrent.linkedin];
        }
        if (cell.tag == 503) // twitter
        {
            [self openNativeURL:[NSString twitterURLFromString:self.sfCurrent.twitter] orWebURL:self.sfCurrent.twitter];
        }
    }
}



-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3)
    {
        // story path, calculate height of the story & resize everything
        NSString *storyText = self.sfCurrent.bio;
        UIFont *font = [UIFont systemFontOfSize:14.0];
        CGSize initialSize = CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT); // -40 for cell padding
        CGSize sz = [storyText sizeWithFont:font constrainedToSize:initialSize];
        [self.storyTextLabel setFrame:CGRectMake(0, 0, sz.width, sz.height)];
        return sz.height+40;
    }
    else if (indexPath.section == 0)
    {
        if (indexPath.row == 2)
        {
            // "contact" row, could be empty
            if (self.sfCurrent.contact == nil || [self.sfCurrent.contact length] == 0)
            {
                return 0;
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // company link row
            if ([self.sfCurrent.site_url length] == 0)
            {
                return 0;
            }
        }
        if (indexPath.row == 1)
        {
            // linkedin row
            if ([self.sfCurrent.linkedin length] == 0)
            {
                return 0;
            }
        }
        if (indexPath.row == 2)
        {
            // facebook
            if ([self.sfCurrent.facebook length] == 0)
            {
                return 0;
            }
        }
        if (indexPath.row == 3)
        {
            // twitter
            if ([self.sfCurrent.twitter length] == 0)
            {
                return 0;
            }
        }
        
    }

    // otherwise, we have a "regular" cell
    // figure out how high it has to be to render the text
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (IBAction)nextPrevPressed:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if (control.selectedSegmentIndex == 0) {
        // up pressed - goto previous semifinalist
        if (self.semifinalist > 0) {
            self.sfCurrent = [self.category.semifinalists objectAtIndex:--self.semifinalist];
        }
    }
    else if (control.selectedSegmentIndex == 1) {
        // down pressed - goto next semifinalist
        if (self.semifinalist < [self.category.semifinalists count]-1) {
            self.sfCurrent = [self.category.semifinalists objectAtIndex:++self.semifinalist];
        }
    }
}

@end
