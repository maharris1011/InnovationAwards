//
//  AppDelegate.h
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSDictionary *_companyData;
    NSDictionary *_categoryData;
}

@property (nonatomic, readonly, strong) NSDictionary *sharedCategoryData;
@property (nonatomic, readonly, strong) NSDictionary *sharedCompanyData;

// Implementation
- (NSDictionary *)sharedCategoryData;
- (NSDictionary *)sharedCompanyData;


@property (strong, nonatomic) UIWindow *window;

@end
