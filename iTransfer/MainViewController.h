//
//  MainViewController.h
//  iTransfer
//
//  Created by Mamunul on 5/21/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferViewController.h"

@interface MainViewController : UIViewController<UITextFieldDelegate>


{

	IBOutlet UITextField *userNameTextField;
	IBOutlet UIButton *startButton;

}

@end
