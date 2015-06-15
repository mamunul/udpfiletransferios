//
//  MainViewController.m
//  iTransfer
//
//  Created by Mamunul on 5/21/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	userNameTextField.delegate = self;
}

-(IBAction)start:(id)sender{

	
	if(userNameTextField.text.length>0){
	
	
		TransferViewController *transferViewController = (TransferViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TransferVC"];
		
		transferViewController.userName = userNameTextField.text;
	
		
		[self presentViewController:transferViewController animated:YES completion:nil];
	
	}else{
	
	
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Enter a valid userName" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		
		[alertView  show];
	
	}



}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	
	return YES;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
