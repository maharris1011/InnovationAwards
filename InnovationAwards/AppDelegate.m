//
//  AppDelegate.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "AppDelegate.h"
#import "SemiFinalistDetailViewController.h"

@implementation AppDelegate

- (NSDictionary *)sharedCategoryData
{
    if (_categoryData == nil) {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"2011_semifinalists" ofType:@"json"];
        NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        _categoryData = [jsonData objectFromJSONString];

    }
    return _categoryData;
}

- (NSDictionary *)sharedSemifinalistDetail
{
    
    if (_semifinalistDetail == nil) {
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"2012_semifinalist_detail_mock" ofType:@"json"];
        NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        _semifinalistDetail = [jsonData objectFromJSONString];
        
    }
    return _semifinalistDetail;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Override point for customization after application launch.
    // Register for Apple Push Notification Service
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    [Socialize storeConsumerKey:@"2f3f47cd-14cb-40df-8d5e-136a5dd1cde7"];
    [Socialize storeConsumerSecret:@"d4fa492e-a2bf-4865-bcbf-2276b626ac3b"];
    [SZFacebookUtils setAppId:@"394489043966235"];
    [SZTwitterUtils setConsumerKey:@"wzsvqTEIx7W8Jb5bHbAYBA" consumerSecret:@"gdAQS4XSmvdS3pdvY4iqHgGAkB5lcinboVJdJcFJI"];
    

    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [self handleNotification:userInfo];
    }

#if 0
    // Specify a Socialize entity loader block
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        
        
        SemiFinalistDetailViewController *entityLoader = [[SemiFinalistDetailViewController alloc] initWithEntity:entity];
        
        if (navigationController == nil) {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entityLoader];
            [self.window.rootViewController presentModalViewController:navigationController animated:YES];
        } else {
            [navigationController pushViewController:entityLoader animated:YES];
        }
    }];
#endif
    
    [TestFlight takeOff:@"dc1a72e99768cf81ea352cc2fea4338e_MTQwNTA1MjAxMi0xMS0xMCAxNzowMDo0MS43MzE5NTc"];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
{
    // If you are testing development (sandbox) notifications, you should instead pass development:YES
    
    //Removing the brackets from the device token
    NSString *tokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSLog(@"Push Notification tokenstring is %@",tokenString);

#if DEBUG
    [SZSmartAlertUtils registerDeviceToken:deviceToken development:YES];
#else
    [SZSmartAlertUtils registerDeviceToken:deviceToken development:NO];
#endif
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [Socialize handleOpenURL:url];
}

- (void)handleNotification:(NSDictionary*)userInfo {
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        if ([SZSmartAlertUtils openNotification:userInfo]) {
            NSLog(@"Socialize handled the notification (background).");
            
        } else {
            NSLog(@"Socialize did not handle the notification (background).");
            
        }
    } else {
        
        NSLog(@"Notification received in foreground");
        
        // You may want to display an alert or other popup instead of immediately opening the notification here.
        
        if ([SZSmartAlertUtils openNotification:userInfo]) {
            NSLog(@"Socialize handled the notification (foreground).");
        } else {
            NSLog(@"Socialize did not handle the notification (foreground).");
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Handle Socialize notification at foreground
    [self handleNotification:userInfo];
}




@end
