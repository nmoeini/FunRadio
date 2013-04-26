//
//  YourFunRadioRootTableViewController.m
//  yourFunRadio
//
//  Created by Navid on 4/25/13.
//  Copyright (c) 2013 Navid. All rights reserved.
//

#import "YourFunRadioRootTableViewController.h"

@interface YourFunRadioRootTableViewController ()

@end

@implementation YourFunRadioRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
        if (buttonIndex == 0) {
            
            NSLog(@"%@", [alertView textFieldAtIndex:0]);
            NSLog(@"%@", [alertView textFieldAtIndex:1]);
        }
        
}


- (IBAction)LogIn
{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log in" message:@"Please enter your username and password" delegate:self cancelButtonTitle:@"Log in" otherButtonTitles:@"Cancel", nil];
        [alert setAlertViewStyle: UIAlertViewStyleLoginAndPasswordInput];
    
        UITextField *userName = [alert textFieldAtIndex:0];
        userName.clearButtonMode = UITextFieldViewModeWhileEditing;
        userName.keyboardType = UIKeyboardTypeAlphabet;
        userName.keyboardAppearance = UIKeyboardAppearanceAlert;
        userName.autocapitalizationType = UITextAutocapitalizationTypeWords;
        userName.autocapitalizationType = UITextAutocorrectionTypeNo;
        
        UITextField *passWord = [alert textFieldAtIndex:1];
        passWord.clearButtonMode = UITextFieldViewModeWhileEditing;
        passWord.keyboardType = UIKeyboardTypeURL;
        passWord.keyboardAppearance = UIKeyboardAppearanceAlert;
        passWord.autocapitalizationType = UITextAutocapitalizationTypeNone;
        passWord.autocapitalizationType = UITextAutocorrectionTypeNo;
        
        [alert show]; 
}


@end
