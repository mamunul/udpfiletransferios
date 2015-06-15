//
//  DataAsyncManager.m
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "DataAsyncManager.h"

@implementation DataAsyncManager{


	UDPProtocol *udpProtocol;

}

@synthesize dataAsyncManagerProtocol;

-(instancetype)init{


	if(self == Nil){
	
		self = [super init];
	
	}
	
	udpProtocol = [[UDPProtocol alloc] init];

	udpProtocol.udpProtocolDelegate = self;

	return self;
}



-(void) activateDataReceiverWithFileSize:(int) fileSize{
	udpProtocol.isReceiverActive = YES;
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .01 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			[udpProtocol receieveDataUDP:fileSize Port:DataPort Timeout:5];
			
		});
}

-(void) deactivateReceiver{

	[udpProtocol stopReceiver];

}

-(void) sendData:(DataFormat *) data User:(User *) user{
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .05 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		[udpProtocol sendDataUDP:data ToIpAddress:user.ipAddress Port:DataPort];
		
	});

}


-(void) onDataReceived:(DataFormat *) dataFormat{


	[dataAsyncManagerProtocol fileReceived:dataFormat];

}

-(void) onDataReceiveError{


	[dataAsyncManagerProtocol fileReceivedError];

}

-(void) onDataSentError{

	[dataAsyncManagerProtocol fileSentError];

}


-(void) dataSentSuccessfully{


	[dataAsyncManagerProtocol fileSentSuccessfully];

}

@end
