//
//  LoginViewController.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-12.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)login:(id)sender;

@end
