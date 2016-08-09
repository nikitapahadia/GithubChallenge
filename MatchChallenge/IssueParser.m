//
//  IssueParser.m
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import "IssueParser.h"

#import "Issue.h"

@interface IssueParser ()

/**
 *  Serializes the given JSON data
 *
 *  @param data :The data to be serialized
 *
 *  @return An object with the serialized JSON data
 */
- (id)serializeJSONWithData:(NSData *)data;

/**
 *  Parses the serialized data
 *
 *  @param rootObject :The serialized data
 *
 *  @return An array with all the parsed issues
 */
- (NSArray *)parseIssues:(id)rootObject;

/**
 *  Parses a single Issue
 *
 *  @param result :JSON dictionary of the Issue
 *
 *  @return Issue object parsed from the given dictionary
 */
- (Issue *)parseIssue:(NSDictionary *)result;

@end

@implementation IssueParser

#pragma mark - ParseData

- (void)parseWithData:(NSData *)data withCompletionHandler:(IssueParserCompletion)completion;
{
    id rootObject = [self serializeJSONWithData:data];
    
    NSArray *results = [self parseIssues:rootObject];
    
    if (completion)
    {
        completion(results);
    }
}

#pragma mark - Serialization

- (id)serializeJSONWithData:(NSData *)data
{
    //JSON Serialization
    NSError *error;
    id rootObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    return rootObject;
}

#pragma mark - Parsing

- (NSArray *)parseIssues:(id)rootObject
{
    NSMutableArray *issuesArray = [[NSMutableArray alloc] init];
    
    if (rootObject &&
        [rootObject isKindOfClass:[NSArray class]])
    {
        NSArray *resultsArray = (NSArray *)rootObject;
        
        for (NSDictionary *result in resultsArray)
        {
            Issue *issue = [self parseIssue:result];
            
            [issuesArray addObject:issue];
        }
    }
    
    return issuesArray;
}

- (Issue *)parseIssue:(NSDictionary *)result
{
    Issue *issue = [[Issue alloc] init];
    
    issue.issueID = [result objectForKey:@"id"];
    issue.issueNumber = [result objectForKey:@"number"];
    issue.issueTitle = [result objectForKey:@"title"];
    
    return issue;
}

@end
