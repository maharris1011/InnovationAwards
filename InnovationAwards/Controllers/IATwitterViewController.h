//
//  IATwitterViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh/PullToRefreshView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface IATwitterViewController : UITableViewController<PullToRefreshViewDelegate, UIActionSheetDelegate>

- (IBAction)composeButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@end
