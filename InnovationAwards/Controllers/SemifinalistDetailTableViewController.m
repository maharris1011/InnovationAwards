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
            
        self.companyNameLabel.text = [self.semifinalistData objectForKey:@"name"];
        self.representativeNameLabel.text = [self.semifinalistData objectForKey:@"rep_name"];
        self.companyUrlLabel.text = [self.semifinalistData objectForKey:@"url"];
        self.storyTextLabel.text = [self.semifinalistData objectForKey:@"story"];
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

- (void)viewDidUnload {
    [self setCompanyNameLabel:nil];
    [self setRepresentativeNameLabel:nil];
    [self setCompanyUrlLabel:nil];
    [self setCategoryNameLabel:nil];
    [self setStoryTextLabel:nil];
    [super viewDidUnload];
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
