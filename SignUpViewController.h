//
//  SignUpViewController.h
//  Space Cat
//
//  Created by Audrey Jun on 2014-11-12.
//  Copyright (c) 2014 com.lighthouselabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

- (IBAction)signup:(id)sender;

@end
