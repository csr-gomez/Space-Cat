//
//  ScoreboardTableViewController.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-12.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "ScoreboardTableViewController.h"
#import "ScoreCell.h"
#import "AppDelegate.h"

@interface ScoreboardTableViewController ()

@end

@implementation ScoreboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoresArray = nil;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //*****have to add any changes to viewWillAppear - viewDidLoad never gets called if you log out and log in as a different person.
    //also have to reset currentUser within viewWillAppear, otherwise self.currentUser will be the previously logged out user.
//    self.currentUser = [PFUser currentUser];
//    NSLog(@"Current user in ScoreBoard-ViewWillAppear: %@", self.currentUser.username);
    
    [self.tableView reloadData];
    
    //need to make a call to the backend to get the data for the relation
    PFQuery *query = [PFQuery queryWithClassName:@"Scores"];
    [query orderByDescending:@"score"];
    [query includeKey:@"player"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error){
            
            NSLog(@"%@", error);
        }
        else {
            self.scoresArray = objects;
//            [self.tableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scoresArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScoreCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PFObject *score = [self.scoresArray objectAtIndex:indexPath.row];
    PFUser *player = score[@"player"];
    NSNumber *myScore = score[@"score"];
    NSString *myScoreString = [myScore stringValue];
    NSString *playerName = player[@"username"];
    cell.scoreLabel.text = myScoreString;
    cell.playerLabel.text = playerName;

    return cell;
}

- (IBAction)backToGame:(id)sender {
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
