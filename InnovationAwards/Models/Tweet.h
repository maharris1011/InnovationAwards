//
//  ImageCache.h
//  Pelotonia
//
//  Created by Mark Harris on 7/13/12.
//  Copyright (c) 2012 Sandlot Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
{
}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSString *createdAtString;

- initFromDictionary:(NSDictionary *)dictionary;


@end
