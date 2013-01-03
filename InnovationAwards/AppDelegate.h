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
    NSArray *_categories;
}

@property (nonatomic, readonly, strong) NSArray *sharedCategories;
@property (strong, nonatomic) UIWindow *window;


@end
