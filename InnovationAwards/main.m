//
//  main.m
//  InnovationAwards
//
//  Created by Mark Harris on 12/9/12.
//  Copyright (c) 2012 TechColumbus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    int retval = 0;
    @autoreleasepool {
        @try {
            retval =  UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"Exception - %@",[exception description]);
            exit(EXIT_FAILURE);
        }
    }
    return retval;
}
