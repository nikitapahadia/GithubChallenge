//
//  RepositoryParser.m
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import "RepositoryParser.h"

@interface RepositoryParser ()

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
 *  @return An array with all the parsed repositories
 */
- (NSArray *)parseRepositories:(id)rootObject;

/**
 *  Parses a single repository
 *
 *  @param result :JSON dictionary of the repository
 *
 *  @return Repository object parsed from the given dictionary
 */
- (Repository *)parseRepository:(NSDictionary *)result;

@end

@implementation RepositoryParser

#pragma mark - ParseData

- (void)parseWithData:(NSData *)data withCompletionHandler:(RepositoryParserCompletion)completion;
{
    id rootObject = [self serializeJSONWithData:data];
    
    NSArray *results = [self parseRepositories:rootObject];
    
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

- (NSArray *)parseRepositories:(id)rootObject
{
    NSMutableArray *repositoryArray = [[NSMutableArray alloc] init];
    
    if (rootObject &&
        [rootObject isKindOfClass:[NSArray class]])
    {
        NSArray *resultsArray = (NSArray *)rootObject;

        for (NSDictionary *result in resultsArray)
        {
            Repository *repository = [self parseRepository:result];
            
            [repositoryArray addObject:repository];
        }
    }
    
    return repositoryArray;
}

- (Repository *)parseRepository:(NSDictionary *)result
{
    Owner *owner = [[Owner alloc] init];
    Repository *repository = [[Repository alloc] init];
    
    repository.repositoryID = [result objectForKey:@"id"];
    repository.repositoryName = [result objectForKey:@"name"];
    
    NSDictionary *ownerDictionary = [result objectForKey:@"owner"];
    owner.ownerID = [ownerDictionary objectForKey:@"id"];
    owner.ownerName = [ownerDictionary objectForKey:@"login"];
    
    repository.owner = owner;
    
    return repository;
}

@end
