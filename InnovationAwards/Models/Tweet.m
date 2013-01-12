//
//  Tweet.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/9/2013
//  Copyright (c) 2012 Sandlot Software, LLC. All rights reserved.
//

#import "Tweet.h"
#import "NSDate+Helper.h"
#import "NSDate-Utilities.h"
#import "ASIHTTPRequest.h"

@implementation Tweet

@synthesize profileImageURL = _profileImageURL;
@synthesize text = _text;
@synthesize screenName = _screenName;
@synthesize createdAt = _createdAt;
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize createdAtString = _createdAtString;
@synthesize normalProfileImageURL = _normalProfileImageURL;



- (id)init {
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dictionary
{
    if (self = [self init])
    {
        if (dictionary)
        {
            NSDictionary *user = [dictionary objectForKey:@"user"];

            self.name = [user objectForKey:@"name"];
            self.profileImageURL = [user objectForKey:@"profile_image_url"];
            self.text = [dictionary objectForKey:@"text"];
            self.screenName = [user objectForKey:@"screen_name"];
            NSString *createdAtString = [dictionary objectForKey:@"created_at"];
            self.createdAt = [NSDate dateFromString:createdAtString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
            self.identifier = [dictionary objectForKey:@"id_str"];
        }
    }
    return self;
}

- (NSString *)normalProfileImageURL
{
    // append "_normal" onto the profile url basename
    if (_normalProfileImageURL == nil)
    {
        NSRange r = [self.profileImageURL rangeOfString:@"_normal.png"];
        if (r.location == NSNotFound)
        {
            _normalProfileImageURL = [self.profileImageURL stringByReplacingOccurrencesOfString:@".png" withString:@"_normal.png"];
        }
        else
        {
            _normalProfileImageURL = self.profileImageURL;
        }
    }
    NSLog(@"%@'s picture: %@", self.name, _normalProfileImageURL);
    return _normalProfileImageURL;
}

- (NSString *)createdAtString
{
    return [NSDate stringForDisplayFromDate:self.createdAt prefixed:YES alwaysDisplayTime:YES];
}

@end
