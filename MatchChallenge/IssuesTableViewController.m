//
//  IssuesTableViewController.m
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import "IssuesTableViewController.h"

#import "NetworkManager.h"
#import "IssueParser.h"
#import "Issue.h"

@interface IssuesTableViewController ()

/**
 *  Array of Issues
 */
@property (nonatomic, strong) NSMutableArray *issuesArray;

/**
 *  Page Number handling Data retrieved
 */
@property (nonatomic, assign)int pageNumber;

@end

@implementation IssuesTableViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the view title as the Repository name
    self.title = self.repository.repositoryName;
    
    self.pageNumber = 1;
    self.issuesArray = [[NSMutableArray alloc] init];
    
    [self requestForIssues];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.issuesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssueCell" forIndexPath:indexPath];
    
    Issue *issue = self.issuesArray[indexPath.row];
    cell.textLabel.text = issue.issueTitle;
    
    return cell;
}

#pragma mark - GetData

- (void)requestForIssues
{
    __weak typeof(self) weakSelf = self;
    [NetworkManager requestIssuesForRepository:self.repository.repositoryName
                                     withOwner:self.repository.owner.ownerName
                                       forPage:[NSNumber numberWithInt:self.pageNumber]
                           withCompletionBlock:^(NSData *data, NSError *error)
     {
         if (error)
         {
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                      message:@"There was an error reaching the server!"
                                                                               preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:nil];
             [alertController addAction:okAction];
             [self presentViewController:alertController
                                animated:YES
                              completion:nil];
         }
         else
         {
             IssueParser *parser = [[IssueParser alloc] init];
             
             [parser parseWithData:data
             withCompletionHandler:^(NSArray *issues)
              {
                  //Note: For the purpose of this exercise, we paginate all the data beforehand, without using information from the response parameter, by creating a check on the parsed data.
                  //If we have issues in the data, update the UI and check if you have more data
                  if (issues.count > 0)
                  {
                      [weakSelf.issuesArray addObjectsFromArray:issues];
                      [weakSelf.tableView reloadData];
                      
                      //keep asking for data until the end of data
                      weakSelf.pageNumber++;
                      [weakSelf requestForIssues];
                  }
              }];
             
             [weakSelf checkAndHandleNoData];
         }
     }];
}

#pragma mark - NoData

- (void)checkAndHandleNoData
{
    if (self.issuesArray.count == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Issues found"
                                                                                 message:@"There were no issues found for this repository"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - MemoryManagement

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
