//
//  IATwitterViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/10/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh/PullToRefreshView.h"

@interface IATwitterViewController : UITableViewController<PullToRefreshViewDelegate>

- (IBAction)composeButtonPressed:(id)sender;
@end
