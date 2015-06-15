//
//  ViewController.h
//  iTransfer
//
//  Created by Mamunul on 5/20/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAsyncManager.h"
#import "StatusAsyncManager.h"
#import "UDPProtocol.h"
#import "DataProcessor.h"
#import "User.h"

@interface TransferViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,DataAsyncManagerProtocol,StatusAsyncManagerProtocol>
{

	
	IBOutlet UILabel *mynameLabel;
	
	IBOutlet UIButton *refreshButton;
	
	IBOutlet UIButton *sendButton;
	
	IBOutlet UILabel *sendStatusLabel;
	
	IBOutlet UIImageView *imageView;
	
	IBOutlet UITableView *usersTableView;

}


@property(readwrite) NSString *userName;

@end

