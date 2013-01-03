    //
//  SemifinalistDetailTableViewController.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/19/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "SemifinalistDetailTableViewController.h"
#import "AppDelegate.h"

@interface SemifinalistDetailTableViewController ()
- (void)setupSocializeEntity;
@end

@implementation SemifinalistDetailTableViewController
@synthesize entity = _entity;
@synthesize actionBar = _actionBar;

- (void)setupSocializeEntity
{
    NSString *key = [NSString stringWithFormat:@"%@#%@", self.categoryURL, self.semifinalistData.company];
    self.entity = [SZEntity entityWithKey:key name:self.semifinalistData.company];
    
    self.actionBar = [SZActionBarUtils showActionBarWithViewController:self.parentViewController entity:self.entity options:nil];
    
    SZShareOptions *shareOptions = [SZShareUtils userShareOptions];
    shareOptions.dontShareLocation = NO;
    self.actionBar.shareOptions = shareOptions;
    NSString *title = self.semifinalistData.company;
    NSString *description = [NSString stringWithFormat:@"Nominated for IA12: %@ ", self.categoryName];
    NSString *thumb = self.semifinalistData.image_path;
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
    // set up the instance data
    // by parsing the entity key.  the entity is:
    // http://www.techcolumbusinnovationawards.org/<category>.html#semifinalistname
    NSLog(@"key = %@", [entity key]);
    
    // split the entity into URL and company
    NSArray *urlAndCompany = [[entity key] componentsSeparatedByString:@"#"];
    NSString *url = [urlAndCompany objectAtIndex:0];
    NSString *company = [urlAndCompany objectAtIndex:1];
    
    // find the semifinalist we're looking for
    AppDelegate *app = [[UIApplication sharedApplication] delegate];

    // first locate the category
    IACategory *category = nil;
    for (IACategory *cat in [app sharedCategories])
    {
        if ([[cat url] isEqualToString:url]) {
            category = cat;
        }
    }
    
    if (category)
    {
        _categoryURL = category.url;
        _categoryName = category.name;

        for (IASemifinalist *sfi in category.semifinalists)
        {
            if ([sfi.company isEqualToString:company])
            {
                _semifinalistData = sfi;
            }
        }
            
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // set the labels accordingly
    self.categoryNameLabel.text = self.categoryName;
    if (self.semifinalistData)
    {
        self.companyNameLabel.text = self.semifinalistData.company;
        self.representativeNameLabel.text = self.semifinalistData.contact;
        self.companyUrlLabel.text = self.semifinalistData.site_url;
        self.storyTextLabel.text = self.semifinalistData.bio;
        self.navigationItem.title = self.semifinalistData.company;
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
- (void)openURLifAble:(NSString *)url
{
    
    if (url && [url length] > 0)
    {
        NSURL *urlToStart = [NSURL URLWithString:url];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        // social buttons
        if (indexPath.row == 0)
        {
            // facebook
            [self openURLifAble:self.semifinalistData.facebook];
        }
        else if (indexPath.row == 1)
        {
            // linkedin
            [self openURLifAble:self.semifinalistData.linkedin];
        }
        else if (indexPath.row == 2)
        {
            // twitter
            [self openURLifAble:self.semifinalistData.twitter];
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
            NSString *storyText = self.semifinalistData.bio;
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
