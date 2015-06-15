//
//  ViewController.m
//  iTransfer
//
//  Created by Mamunul on 5/20/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "TransferViewController.h"


@interface TransferViewController ()
{
	UDPProtocol *udpProtocol;
	
	StatusAsyncManager *statusAsyncManager;
	
	DataAsyncManager *dataAsyncManager;
	
	DataProcessor *dataProcessor;
	
	Boolean isSender;
	
	NSMutableArray *usersArray;
	
	DataFormat *dataFormat;
	
	UIImage *image;
	
	User *selectedUser;
	
	NSData *filedata ;
	
}

@end

@implementation TransferViewController

@synthesize userName;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	udpProtocol = [[UDPProtocol alloc] init];
	
	statusAsyncManager = [[StatusAsyncManager alloc] init];
	
	dataAsyncManager = [[DataAsyncManager alloc] init];
	
	
	dataProcessor = [[DataProcessor alloc] init];
	
	usersArray = [[NSMutableArray alloc] init];
	
	usersTableView.delegate = self;
	
	
	statusAsyncManager.statusAsyncManagerProtocol = self;
	
	dataAsyncManager.dataAsyncManagerProtocol = self;
	isSender = NO;
	
	mynameLabel.text = [NSString stringWithFormat:@"MyName: %@",userName];
	
	

}

-(void)viewDidAppear:(BOOL)animated{


	[super viewDidAppear:animated];


	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self sendStatus:[dataProcessor createOnlineStatusDataFromUserName:userName]];
	});

	

}

-(void)viewWillDisappear:(BOOL)animated{

	[super viewWillDisappear:animated];
	
	[self deactivateDataReceiverThread];
	[self deactivateStatusReceiverThread];

}

-(IBAction)refreshButtonEvent:(id)sender{

		[self sendStatus:[dataProcessor createOnlineStatusDataFromUserName:userName]];
}

-(IBAction)fileButtonEvent:(id)sender{

	UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
	
	pickerController.allowsEditing = YES;
	pickerController.delegate = self;
	
	pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

	[self presentViewController:pickerController animated:YES completion:Nil];
	

}



-(void)sendData:(NSData *)byteArray{
	
	
	[statusAsyncManager deactivateReceiver];
	
	[dataAsyncManager deactivateReceiver];
	
	[dataAsyncManager sendData:[dataProcessor createFileData:userName ToUserIp:selectedUser.ipAddress Data:byteArray] User:selectedUser];
	

}

-(void) loadUsersListView{

	dispatch_async(dispatch_get_main_queue(), ^{
		[usersTableView reloadData];
	});
	


}

-(void) sendStatus:(DataFormat *) data{
	
	[self deactivateStatusReceiverThread];


	[statusAsyncManager sendStatus:data];

}

-(void) deactivateStatusReceiverThread{

	
	[statusAsyncManager deactivateReceiver];

}

-(void) deactivateDataReceiverThread{

	[dataAsyncManager deactivateReceiver];

}


-(void) activateDataReceiveThread:(int) fileSize{


	[dataAsyncManager activateDataReceiverWithFileSize:fileSize];

}

-(void) activateStatusReceiverThread{

	[statusAsyncManager activateStatusReceiver];

}


-(void) sendFile{
	
	filedata = UIImageJPEGRepresentation(image, 0.2);

	NSLog(@"image:%d", [filedata length]);
	
	[self sendStatus:[dataProcessor createFileInfoStatus:userName ToUserIp:selectedUser.ipAddress FileFormat:@"jpg" FileSize:[filedata length]]];


}


#pragma mark TableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if(image != Nil){

		selectedUser = [usersArray objectAtIndex:indexPath.row];
	
		[self sendFile];
		
	}
	
}

#pragma mark TableView DataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

	
	return [usersArray count];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


	
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"usercell" forIndexPath:indexPath];
	
	UILabel *label = (UILabel *) [tableView viewWithTag:101];
	
	
	label.text = ((User *)[usersArray objectAtIndex:indexPath.row]).userName;

	return tableViewCell;
}

#pragma mark Status Tranceiver Delegate Methods

-(void) statusReceived:(DataFormat *) localDataFormat{
	if (localDataFormat.statusType == OnlineAcivity) {
		
		User *user = [[User alloc] init];
		
		user.ipAddress = localDataFormat.senderIp;
		user.userName = localDataFormat.senderName;
		
		NSString *sdf = [localDataFormat.status stringByTrimmingCharactersInSet:
		[NSCharacterSet whitespaceCharacterSet]];
		
		int a = [sdf intValue];
		
		if (a == 0) {
			
			BOOL present = false;
			
			
			for (User *exuser in usersArray) {
				
				if ([exuser.ipAddress containsString:user.ipAddress]) {
					present = true;
				}
				
			}
			
			if(!present){
			
				[usersArray addObject:user];
				
				[self sendStatus:[dataProcessor createOnlineStatusDataFromUserName:userName]];
			
			}
				
		}else{
		
			for (User *exuser in usersArray) {
				
				if ([exuser.ipAddress containsString:user.ipAddress]) {
				
					[usersArray removeObject:exuser];
				}
				
			}
		
		
		}
	
	
		
	} else if (localDataFormat.statusType == FileInfo) {
		
	
		dataFormat = localDataFormat;
		
		NSLog(@"ip:%@",localDataFormat.status);
		

		[self sendStatus:[dataProcessor createFileReceiveReadyStatus:userName ToUserIp:dataFormat.senderIp]];

		
	} else if (localDataFormat.statusType == FileReceiverReady
			   && isSender) {
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[sendStatusLabel setText:@"File is sending to"];
			
		});
		

		
		[self sendData:filedata];
	}
	
	[self loadUsersListView];

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	//UIGraphicsBeginImageContext(newSize);
	// In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
	// Pass 1.0 to force exact pixel size.
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
	[image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

-(void) statusSentSuccessfully:(StatusType )statusType{

	if (statusType == FileReceiverReady) {
		
		NSArray *array = [dataFormat.status componentsSeparatedByString:@":"];
		
		
		int byteSize = [[array objectAtIndex:1] intValue];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[sendStatusLabel setText:@"File is receiving from"];
			
		});
		
		[self deactivateStatusReceiverThread];
		[self activateDataReceiveThread:(byteSize + DefaultDataSize)];
		
		
	} else if (statusType == FileInfo) {
		
				isSender = YES;
		
		[self activateStatusReceiverThread];

	} else {
		
		[self activateStatusReceiverThread];

	}

}

-(void) statusSentError{

	[self activateStatusReceiverThread];

}

#pragma mark File Tranceiver Delegate Methods

-(void) fileReceived:(DataFormat *) dataFormat{
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[sendStatusLabel setText:@"File received successfully"];
	
		imageView.image = [UIImage imageWithData:dataFormat.fileData];
		
	});
	
	[self deactivateDataReceiverThread];
	[self activateStatusReceiverThread];

}

-(void) fileReceivedError{
	

	dispatch_async(dispatch_get_main_queue(), ^{
		
		[sendStatusLabel setText:@"File receiving error"];
		
	});

	[self deactivateDataReceiverThread];
	[self activateStatusReceiverThread];

}

-(void) fileSentSuccessfully{
	isSender = NO;
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[sendStatusLabel setText:@"File sending complete"];
		
	});
	
	[self deactivateDataReceiverThread];
	
	[self activateStatusReceiverThread];

}

-(void) fileSentError{
 	isSender = NO;
	dispatch_async(dispatch_get_main_queue(), ^{
		
		[sendStatusLabel setText:@"File sending error"];
		
	});
	
	[self deactivateDataReceiverThread];
	[self activateStatusReceiverThread];

}
#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	image = [self imageWithImage: info[UIImagePickerControllerEditedImage] scaledToSize:CGSizeMake(50, 50)];
	imageView.image = image;
	
	
	[picker dismissViewControllerAnimated:NO completion:NULL];
	
	
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
	
	[picker dismissViewControllerAnimated:YES completion:NULL];
	
	
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.

}



@end;
