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

@synthesize originalProfileImage = _originalProfileImage;
@synthesize profileImageURL = _profileImageURL;
@synthesize text = _text;
@synthesize screenName = _screenName;
@synthesize createdAt = _createdAt;
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize createdAtString = _createdAtString;
@synthesize normalProfileImage = _normalProfileImage;
@synthesize normalProfileImageURL = _normalProfileImageURL;


static UIImage *defaultImage = nil;

- (UIImage *)getFromCacheImageNamed:(NSString *)key
{
    UIImage *image = defaultImage;
    UIImage *profileImage = [[ImageCache sharedStore] imageForKey:self.profileImageURL];
    
    if (profileImage != nil)
    {
        image = profileImage;
    }
    
    return image;
}

- (id)init {
    self = [super init];
    if (self)
    {
        // custom initialization
        if (defaultImage == nil)
        {
            defaultImage = [UIImage imageNamed:@"twitter-bird-blue-on-white.png"];
        }
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
    NSString *imageURL = [self.profileImageURL stringByReplacingOccurrencesOfString:@".png" withString:@"_normal.png"];
    return imageURL;
}

- (UIImage *)normalProfileImage
{
    // get that image
    return [self getFromCacheImageNamed:self.normalProfileImageURL];
}

- (UIImage *)originalProfileImage
{
    UIImage *image = defaultImage;
    if (self.profileImageURL)
    {
        image = [self getFromCacheImageNamed:self.profileImageURL];
    }
    return image;
}

- (void)setOriginalProfileImage:(UIImage *)i
{
    if (i != nil)
    {
        [[ImageCache sharedStore] setImage:i forKey:self.profileImageURL];
    }
    _originalProfileImage = i;
}

- (NSString *)createdAtString
{
    return [NSDate stringForDisplayFromDate:self.createdAt prefixed:YES alwaysDisplayTime:YES];
}

@end
