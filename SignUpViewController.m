//
//  SignUpViewController.m
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-12.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController () {
    NSArray *arrayOfNames;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayOfNames = [NSArray arrayWithObjects:@"Pro", @"Casual", @"Easy", nil];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sign Up
- (IBAction)signup:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *selectedName = [arrayOfNames objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    
    if ([username length]==0 || [password length]==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a valid username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser[@"playerType"] = selectedName;
        
        //create a new user and save it in the backend
        //in block so sign up is done asynchronously - parse background operation
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now - go back to Inbox Page
                //                [self.navigationController popToRootViewControllerAnimated:YES];
                [self dismissSelf];
                
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }];
    }
    
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDataSource

// number of "wheels" in the picker view
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// number of rows in a given "wheel"
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark - UIPickerViewDelegate

// display string for each row (model) in a given "wheel"
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    
    return [arrayOfNames objectAtIndex:row];
}



@end
