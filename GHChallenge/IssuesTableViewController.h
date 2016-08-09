//
//  IssuesTableViewController.h
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Repository.h"

@interface IssuesTableViewController : UITableViewController

/**
 *  Repository for which Issues are going to be presented
 */
@property (nonatomic, strong) Repository *repository;

@end
