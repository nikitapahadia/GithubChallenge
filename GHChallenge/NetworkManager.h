//
//  NetworkManager.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Completion handler for the request
 *
 *  @param NSData  Data returned from the request
 *  @param NSError Error returned from the request
 */
typedef void (^RequestCompletionHandler) (NSData *, NSError *);

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

/**
 *  Creates and starts a network request for all repositories of the user with given username
 *
 *  @param userName   :Username of the user whose repositories we need
 *  @param pageNumber :Page Number for the request
 *  @param completion :Completion block to be called on completion of the network operation
 */
+ (void)requestRepositoriesForUserName:(NSString *)userName
                               forPage:(NSNumber *)pageNumber
                   withCompletionBlock:(RequestCompletionHandler)completion;

/**
 *  Creates and starts a network request for all issues for a given repository
 *
 *  @param repositoryName   :Name of the repository
 *  @param ownerName        :Name of the owner of the repository
 *  @param pageNumber       :Page Number for the request
 *  @param completion       :Completion block to be called on completion of the network operation
 */
+ (void)requestIssuesForRepository:(NSString *)repositoryName
                         withOwner:(NSString *)ownerName
                           forPage:(NSNumber *)pageNumber
               withCompletionBlock:(RequestCompletionHandler)completion;

@end
