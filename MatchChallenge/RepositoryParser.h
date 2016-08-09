//
//  RepositoryParser.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Repository.h"

/**
 *  Completion block definition
 *
 *  @param repositories :An array with parsed repositories
 */
typedef void (^RepositoryParserCompletion) (NSArray *repositories);

@interface RepositoryParser : NSObject

/**
 *  Parses the given data for repositories
 *
 *  @param data       :The data to be parsed
 *  @param completion :The completion block returning an array of respositories after the parsing is completed
 */
- (void)parseWithData:(NSData *)data withCompletionHandler:(RepositoryParserCompletion)completion;

@end
