//
//  Repository.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Owner.h"

@interface Repository : NSObject

/**
 *  ID of the repository
 */
@property (nonatomic, assign) NSNumber *repositoryID;

/**
 *  Name of the repository
 */
@property (nonatomic, copy) NSString *repositoryName;

/**
 *  Owner object for this repository
 */
@property (nonatomic, strong) Owner *owner;

@end
