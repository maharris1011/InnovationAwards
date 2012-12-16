//
//  AppDelegate.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSDictionary *sharedCategoryData = nil;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Implementation
- (NSDictionary *)sharedCategoryData;


@property (strong, nonatomic) UIWindow *window;

@end
