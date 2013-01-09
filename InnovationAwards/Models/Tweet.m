//
//  Tweet.m
//  InnovationAwards
//
//  Created by Mark Harris on 1/9/2013
//  Copyright (c) 2012 Sandlot Software, LLC. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

@synthesize profileImage = _profileImage;
@synthesize profileImageURL = _profileImageURL;
@synthesize text = _text;
@synthesize screenName = _screenName;
@synthesize createdAt = _createdAt;
@synthesize identifier = _identifier;

- (void)asynchronousGetImageAtUrl:(NSString *)url onComplete:(void(^)(UIImage *image))complete
{
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:[request responseData]];
            if (complete) {
                complete(image);
            }
        });
    }];
    [request startAsynchronous];
}

- (id)init {
    self = [super init];
    if (self) 
    {
        dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- initFromDictionary:(NSDictionary *)dictionary
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
            NSString *createdAtString = [tweet objectForKey:@"created_at"];
            self.createdAt = [NSDate dateFromString:createdAtString withFormat:@"EEE LLL d HH:mm:ss Z yyyy"];
            self.identifier = [dictionary objectForKey:@"id_str"];
        }
    }
    return self;
}


- (void)setProfileImage:(UIImage *)i
{
    [ImageCache sharedImageCache] setImage:i forKey:self.profileImageURL];
    _profileImage = i;
}

- (void)setProfileImageURL:(NSString *)profileImageURL
{
    // get the photo from the web
    [self asynchronousGetImageAtUrl:url onComplete:^(UIImage *image) {
       if (image != nil) 
       {
          // stuff it in the cache for when we need it next
          self.profileImage = image;
       }
    }];
}

@end
