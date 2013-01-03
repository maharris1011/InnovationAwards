//
//  IASemifinalist.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/3/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface IASemifinalist : NSObject
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *contact;
@property (nonatomic, strong) NSString *site_url;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *linkedin;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *twitter;
@property (nonatomic, strong) NSString *image_path;

- (id)initWithFake:(int)n;
- (id)initWithHTML:(TFHppleElement *)e;
- (id)initWithDictionary:(NSDictionary *)d;

@end
