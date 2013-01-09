//
//  NSString+SocialMediaParsers.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/8/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SocialMediaParsers)

+ (NSString *) fbProfileFromString:(NSString *)facebookWebURL;
+ (NSString *) twitterURLFromString:(NSString *)twitterWebURL;

@end
