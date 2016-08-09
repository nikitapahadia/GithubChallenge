//
//  Issue.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Issue : NSObject

/**
 *  ID of the Issue
 */
@property (nonatomic, assign) NSNumber *issueID;

/**
 *  Number of the Issue
 */
@property (nonatomic, assign) NSNumber *issueNumber;

/**
 *  Title of the Issue
 */
@property (nonatomic, copy) NSString *issueTitle;

@end
