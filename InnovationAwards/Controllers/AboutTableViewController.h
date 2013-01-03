//
//  AboutTableViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutTableViewController : UITableViewController
- (IBAction)done:(id)sender;

@property (strong, nonatomic) IBOutlet UITableViewCell *versionCell;
@end
