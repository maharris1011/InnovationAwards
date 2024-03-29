//
//  AppDelegate.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import "AppDelegate.h"
#import "SemifinalistDetailTableViewController.h"
#import "IACategory.h"

@implementation AppDelegate

- (NSArray *)sharedCategories
{
    if (_categories == nil)
    {
        NSMutableArray *catlist = [[NSMutableArray alloc] initWithCapacity:0];
        NSString *fileName = [[NSBundle mainBundle] pathForResource:@"2012_categories" ofType:@"json"];
        NSString *jsonData = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
        NSArray *categories_raw = [jsonData objectFromJSONString];
        
        // create our list of category objects to use
        for (NSDictionary *dict in categories_raw) {
            // initialize a category object from the dictionary data
            IACategory *category = [[IACategory alloc] init];
            category.name = [dict objectForKey:@"category"];
            category.abbrev = [dict objectForKey:@"abbrev"];
            
            NSMutableArray *semifinalists = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *json_semifinalists = [dict objectForKey:@"semifinalists"];
            for (NSDictionary *dict in json_semifinalists) {
                // create a semifinalist
                IASemifinalist *sf = [[IASemifinalist alloc] initWithDictionary:dict];
                
                // add them to the list
                [semifinalists addObject:sf];
            }

            category.semifinalists = semifinalists;
        
            // add the category to our list
            [catlist addObject:category];
        }
        
        _categories = catlist;
    }
    return _categories;
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
    
    [self setUpSocialize];
    

    // Handle Socialize notification at launch
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        [self handleNotification:userInfo];
    }

    
    [TestFlight takeOff:@"dc1a72e99768cf81ea352cc2fea4338e_MTQwNTA1MjAxMi0xMS0xMCAxNzowMDo0MS43MzE5NTc"];
    
    // customize appearance
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:IA_Font800 size:0.0],
      UITextAttributeFont,
      nil]];
    
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

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to register for remote notification. Error: %d: %@, %@", error.code, error.localizedDescription, error.localizedFailureReason);
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
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

- (void)setUpSocialize {
    [Socialize storeConsumerKey:@"2f3f47cd-14cb-40df-8d5e-136a5dd1cde7"];
    [Socialize storeConsumerSecret:@"d4fa492e-a2bf-4865-bcbf-2276b626ac3b"];
    
    [self linkToFacebook];
    [self linkToTwitter];
    

    // Specify a Socialize entity loader block, for the HandleOpenURL message we
    // get when a user clicks on an entity shared on the web.
    [Socialize setEntityLoaderBlock:^(UINavigationController *navigationController, id<SocializeEntity>entity) {
        
        IASemifinalist *sf = [IASemifinalist semifinalistFromEntity:entity];
        IACategory *cat = [IACategory categoryFromEntity:entity];
        NSInteger index = [cat indexOfSemifinalistWithCompany:sf.company];
        if (!sf || !cat || (index < 0)) {
            NSLog(@"sf = %@, cat = %@, index = %d", sf, cat, index);
            // put up a popup saying "sorry, cant find them"
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unknown Semifinalist" message:[NSString stringWithFormat:@"Sorry, we were unable to find the semifinalist %@.", sf.company] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else {
            SemifinalistDetailTableViewController *sfDetailView = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"semifinalistDetailView"];
            sfDetailView.category = cat;
            sfDetailView.semifinalist = index;
            if (navigationController == nil)
            {
                UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
                [navigationController pushViewController:sfDetailView animated:YES];
            }
            else
            {
                [navigationController pushViewController:sfDetailView animated:YES];
            }
        }
    }];
}


- (void)linkToTwitter {
    [SZTwitterUtils setConsumerKey:@"wzsvqTEIx7W8Jb5bHbAYBA" consumerSecret:@"gdAQS4XSmvdS3pdvY4iqHgGAkB5lcinboVJdJcFJI"];
}

- (void)linkToFacebook {
    [SZFacebookUtils setAppId:@"394489043966235"];
}




@end
