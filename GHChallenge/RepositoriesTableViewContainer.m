//
//  RepositoriesTableViewContainer.m
//  MatchChallenge
//
//  Created by Nikita Pahadia on 30/03/2016.
//  Copyright © 2016 Nikita. All rights reserved.
//

#import "RepositoriesTableViewContainer.h"

#import "NetworkManager.h"
#import "RepositoryParser.h"
#import "IssuesTableViewController.h"

@interface RepositoriesTableViewContainer () <UISearchBarDelegate>

/**
 *  Array with the repository data
 */
@property (nonatomic, strong) NSMutableArray *repositoriesArray;

/**
 *  Page Number keeping the count of data retrieved
 */
@property (nonatomic, assign) int pageNumber;

@end

@implementation RepositoriesTableViewContainer

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.repositoriesArray = [[NSMutableArray alloc] init];
    self.pageNumber = 1;
    
    //Set the initial title for this view
    self.title = @"Github";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepositoryCell"];
    
    Repository *repository = self.repositoriesArray[indexPath.row];
    cell.textLabel.text = repository.repositoryName;
    
    return cell;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"IssuesSegue"])
    {
        //Get the repository object for the cell which triggered this action
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Repository *repository = self.repositoriesArray[indexPath.row];
        
        // Get reference to the destination view controller and set the repository object
        IssuesTableViewController *issuesViewController = [segue destinationViewController];
        issuesViewController.repository = repository;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Hide the keyboard
    [searchBar resignFirstResponder];
    
    //Set the title of the view with username
    self.title = searchBar.text;
    
    //reset the values for a new search
    [self.repositoriesArray removeAllObjects];
    self.pageNumber = 1;
    [self.tableView reloadData];
    
    [self requestForRepositoriesWithUsername:searchBar.text];
}

#pragma mark - GetData

- (void)requestForRepositoriesWithUsername:(NSString *)username
{
    __weak typeof(self) weakSelf = self;
    [NetworkManager requestRepositoriesForUserName:username
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
             RepositoryParser *parser = [[RepositoryParser alloc] init];
             
             [parser parseWithData:data
             withCompletionHandler:^(NSArray *repositories)
              {
                  //Note: For the purpose of this exercise, we paginate all the data beforehand, without using information from the response parameter, by creating a check on the parsed data.
                  //If we have repositories in the data, update the UI and check if you have more data
                  if (repositories.count > 0)
                  {
                      [weakSelf.repositoriesArray addObjectsFromArray:repositories];
                      [weakSelf.tableView reloadData];
                      
                      //keep asking for data until the end of data
                      weakSelf.pageNumber++;
                      [weakSelf requestForRepositoriesWithUsername:username];
                  }
              }];
             
             [weakSelf checkAndHandleNoData];
         }
     }];
}

#pragma mark - NoData

- (void)checkAndHandleNoData
{
    if (self.repositoriesArray.count == 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Repositories found"
                                                                                 message:@"There were no repositories found for this username"
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
