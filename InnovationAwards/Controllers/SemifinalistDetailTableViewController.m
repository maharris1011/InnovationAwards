//
//  SemifinalistDetailTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemifinalistDetailTableViewController.h"

@interface SemifinalistDetailTableViewController ()
- (void)setupSocializeEntity;
@end

@implementation SemifinalistDetailTableViewController
@synthesize entity = _entity;
@synthesize actionBar = _actionBar;

- (void)setupSocializeEntity
{
    NSString *key = [NSString stringWithFormat:@"%@#%@", self.categoryURL, [self.semifinalistData objectForKey:@"name"]];
    self.entity = [SZEntity entityWithKey:key name:[self.semifinalistData objectForKey:@"name"]];
    
    self.actionBar = [SZActionBarUtils showActionBarWithViewController:self entity:self.entity options:nil];
    
    SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
    shareOptions.dontShareLocation = NO;
    self.actionBar.shareOptions = shareOptions;
    NSString *title = [NSString stringWithFormat:@"%@", [self.semifinalistData objectForKey:@"name"]];
    NSString *description = [NSString stringWithFormat:@"Nominated for IA12: %@ ", self.categoryName];
    NSString *thumb = [NSString stringWithFormat:@"%@", [self.semifinalistData objectForKey:@"thumbnail"]];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            title, @"szsd_title",
                            description, @"szsd_description",
                            thumb, @"szsd_thumb",
                            nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSAssert(error == nil, @"Error writing json: %@", [error localizedDescription]);
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    self.entity.meta = jsonString;
    
    [SZEntityUtils addEntity:self.entity success:^(id<SZEntity> serverEntity) {
        NSLog(@"Successfully updated entity meta: %@", [serverEntity meta]);
    } failure:^(NSError *error) {
        NSLog(@"Failure: %@", [error localizedDescription]);
    }];
    
}


- (void)initWithEntity:(id<SocializeEntity>)entity
{
    NSLog(@"Init with Entity Called with entity %@", entity);
    // set up the instance data
    // by parsing the entity key.  the entity is:
    // http://www.techcolumbusinnovationawards.org/<category>.html#semifinalistname
    NSLog(@"key = %@", [entity key]);
    
    NSURL *urlEntity = [NSURL URLWithString:[entity key]];
    NSArray *urlPathComps = [urlEntity pathComponents];
    NSInteger numComps = [urlPathComps count];
    for (NSString *str in urlPathComps) {
        NSLog(@"pathComps = %@", str);
    }
    
    
    // create the semifinalist data JSON object
    _semifinalistData = [NSDictionary dictionaryWithObjectsAndKeys:@"test data", @"name", @"test url", @"url", @"test rep name", @"rep_name", @"test story", @"story", nil];
    
    _categoryName = @"Test Category";
    _categoryURL = @"http://www.techcolumbusinnovationawards/test_category";
}




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
            
        self.companyNameLabel.text = [self.semifinalistData objectForKey:@"name"];
        self.representativeNameLabel.text = [self.semifinalistData objectForKey:@"rep_name"];
        self.companyUrlLabel.text = [self.semifinalistData objectForKey:@"url"];
        self.storyTextLabel.text = [self.semifinalistData objectForKey:@"story"];
    }
    [self setupSocializeEntity];
    
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
    if (self.actionBar == nil) {
        [self setupSocializeEntity];
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        NSString *strUrlToStart = nil;
        // social buttons
        if (indexPath.row == 0)
        {
            // facebook
            NSString *fbPage = [self.semifinalistData objectForKey:@"fb"];
            if (fbPage && [fbPage length] > 0) {
                strUrlToStart = [NSString stringWithFormat:@"http://www.facebook.com/%@", fbPage];
            }
        }
        else if (indexPath.row == 1)
        {
            // linkedin
            NSString *liPage = [self.semifinalistData objectForKey:@"li"];
            if (liPage && [liPage length] > 0) {
                strUrlToStart = [NSString stringWithFormat:@"http://www.linkedin.com/%@", liPage];
            }
        }
        else if (indexPath.row == 2)
        {
            // twitter
            NSString *twPage = [self.semifinalistData objectForKey:@"tw"];
            if (twPage && [twPage length] > 0) {
                strUrlToStart = [NSString stringWithFormat:@"http://www.twitter.com/%@", twPage];
            }
        }
        
        if (strUrlToStart != nil)
        {
            NSURL *urlToStart = [NSURL URLWithString:strUrlToStart];
            [[UIApplication sharedApplication] openURL:urlToStart];
        }
        else
        {
            // alert that there's no link given
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Social Media Info"
                                                            message:[NSString stringWithFormat:@"I'm sorry, we do not have that social media information for this semifinalist"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            // story path, calculate height of the story & resize everything
            NSString *storyText = [self.semifinalistData objectForKey:@"story"];
            UIFont *font = [UIFont systemFontOfSize:14.0];
            CGSize initialSize = CGSizeMake(self.view.bounds.size.width - 40, MAXFLOAT); // -40 for cell padding
            CGSize sz = [storyText sizeWithFont:font constrainedToSize:initialSize];
            [self.storyTextLabel setFrame:CGRectMake(0, 0, sz.width, sz.height)];
            return sz.height+40;
        }
        else
        {
            return 117;
        }
    }
    else {
        // otherwise, we have a "regular" cell
        return 44;
    }
}

@end
