//
//  NetworkManager.m
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import "NetworkManager.h"


#define GITHUB_URL @"https://api.github.com"
#define GITHUB_USER_REPOSITORIES_URL @"users/%@/repos?page=%@"
#define GITHUB_REPOSITORIES_ISSUES_URL @"repos/%@/%@/issues?page=%@"

@implementation NetworkManager

+ (NetworkManager *)sharedInstance
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[NetworkManager alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark - RepositoryRequest

+ (void)requestRepositoriesForUserName:(NSString *)userName
                               forPage:(NSNumber *)pageNumber
                   withCompletionBlock:(RequestCompletionHandler)completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:(id<NSURLSessionDelegate>)self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSString *url = [NSString stringWithFormat:[GITHUB_URL stringByAppendingPathComponent:GITHUB_USER_REPOSITORIES_URL], userName, pageNumber];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:[NSURL URLWithString:url]
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (completion)
                                          {
                                              completion(data, error);
                                          }
                                      }];
    
    [dataTask resume];
}

#pragma mark - IssueRequest

+ (void)requestIssuesForRepository:(NSString *)repositoryName
                         withOwner:(NSString *)ownerName
                           forPage:(NSNumber *)pageNumber
               withCompletionBlock:(RequestCompletionHandler)completion
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:(id<NSURLSessionDelegate>)self
                                                            delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *url = [NSString stringWithFormat:[GITHUB_URL stringByAppendingPathComponent:GITHUB_REPOSITORIES_ISSUES_URL], ownerName, repositoryName, pageNumber];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:[NSURL URLWithString:url]
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (completion)
                                          {
                                              completion(data, error);
                                          }
                                      }];
    
    [dataTask resume];
}

@end
