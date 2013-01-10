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

@synthesize profileImage = _profileImage;
@synthesize profileImageURL = _profileImageURL;
@synthesize text = _text;
@synthesize screenName = _screenName;
@synthesize createdAt = _createdAt;
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize createdAtString = _createdAtString;

- (id)init {
    self = [super init];
    if (self) {
        // custom initialization
    }
    return self;
}

- (id)initFromDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
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


- (UIImage *)profileImage
{
    if (self.profileImageURL)
    {
        return [[ImageCache sharedStore] imageForKey:self.profileImageURL];
    }
    else
    {
        return [UIImage imageNamed:@"twitter-bird-blue-on-white.png"];
    }
}

- (void)setProfileImage:(UIImage *)i
{
    if (i != nil) {
        [[ImageCache sharedStore] setImage:i forKey:self.profileImageURL];
    }
    _profileImage = i;
}

- (void)setProfileImageURL:(NSString *)profileImageURL
{
    // get the photo from the web
    _profileImageURL = profileImageURL;
}

- (NSString *)createdAtString
{
    return [NSDate stringForDisplayFromDate:self.createdAt prefixed:YES alwaysDisplayTime:YES];
}

@end
