//
//  AppDelegate.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSDictionary *_semifinalistDetail;
    NSDictionary *_categoryData;
}

@property (nonatomic, readonly, strong) NSDictionary *sharedCategoryData;
@property (nonatomic, readonly, strong) NSDictionary *sharedSemifinalistDetail;

// Implementation
- (NSDictionary *)sharedCategoryData;
- (NSDictionary *)sharedSemifinalistDetail;


@property (strong, nonatomic) UIWindow *window;

@end
