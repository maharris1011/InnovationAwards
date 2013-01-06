//
//  IACategory.h
//  InnovationAwards
//
//  Created by Mark Harris on 1/3/13.
//  Copyright (c) 2013 TechColumbus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IASemifinalist.h"

@interface IACategory : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic, readonly) NSString *url;
@property (strong, nonatomic) NSString *abbrev;
@property (strong, nonatomic) NSArray *semifinalists;

+ (IACategory *)categoryFromEntity:(id<SocializeEntity>)url;

-(IASemifinalist *) findSemifinalistWithCompany:(NSString *)company;
-(NSInteger) indexOfSemifinalistWithCompany:(NSString *)company;

@end
