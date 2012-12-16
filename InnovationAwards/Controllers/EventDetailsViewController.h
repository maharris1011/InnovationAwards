//
//  EventDetailsViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailsViewController : UITableViewController
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonDone;

@end
