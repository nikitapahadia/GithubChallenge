//
//  IssueParser.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Completion block definition
 *
 *  @param issues :An array with parsed issues
 */
typedef void (^IssueParserCompletion) (NSArray *issues);

@interface IssueParser : NSObject

/**
 *  Parses the given data for issues
 *
 *  @param data       :The data to be parsed
 *  @param completion :The completion block returning an array of issues after the parsing is completed
 */
- (void)parseWithData:(NSData *)data withCompletionHandler:(IssueParserCompletion)completion;

@end
