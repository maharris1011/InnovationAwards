//
//  NSString+SocialMediaParsers.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/8/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import "NSString+SocialMediaParsers.h"

@implementation NSString (SocialMediaParsers)

+ (NSString *)fbProfileFromString:(NSString *)facebookWebURL
{
    NSString *prototol = @"http";
    NSRange r = [facebookWebURL rangeOfString:@"https"];
    if (r.location != NSNotFound)
    {
        prototol = @"https";
    }
    NSString *replacementString = [NSString stringWithFormat:@"%@://www.facebook.com/", prototol];
    return [facebookWebURL stringByReplacingOccurrencesOfString:replacementString withString:@"fb://profile/"];
}

+ (NSString *) twitterURLFromString:(NSString *)twitterWebURL
{
    return [twitterWebURL stringByReplacingOccurrencesOfString:@"http://twitter.com/" withString:@"twitter://user?screen_name="];
}

@end
