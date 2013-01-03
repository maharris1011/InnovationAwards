//
//  SemifinalistListViewController.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/16/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//
//  Shows a list of semifinalists for a given category

#import <UIKit/UIKit.h>
#import "IACategory.h"

@interface SemifinalistListViewController : UITableViewController

@property (nonatomic, strong) IACategory *category;

@end
