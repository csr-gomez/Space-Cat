//
//  ScoreboardTableViewController.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-12.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ScoreboardTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *scoresArray;

- (IBAction)backToGame:(id)sender;

@end
