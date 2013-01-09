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
    NSMutableDictionary *dictionary;
}

@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSDate *createdAt;

- initFromDictionary:(NSDictionary *)dictionary;


@end
