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

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) PullToRefreshView *pull;

- (IBAction)composeButtonPressed:(id)sender;
- (IBAction)actionButtonPressed:(id)sender;

@end
