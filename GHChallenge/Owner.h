//
//  Owner.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Owner : NSObject

/**
 *  ID of the Owner of a repository
 */
@property (nonatomic, assign) NSNumber *ownerID;

/**
 *  Name of the owner
 */
@property (nonatomic, copy) NSString *ownerName;

@end
