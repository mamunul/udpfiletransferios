//
//  CommunicationManager.m
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "StatusAsyncManager.h"

@implementation StatusAsyncManager{


	UDPProtocol *udpProtocol;
	
	DataFormat *data;


}

@synthesize statusAsyncManagerProtocol;

-(instancetype)init{

	
	if(self != Nil){
	
		self = [super init];
	
	}
	
	udpProtocol = [[UDPProtocol alloc] init];
	
	udpProtocol.udpProtocolDelegate = self;


	return self;
}



-(void) activateStatusReceiver{

	
	
	udpProtocol.isReceiverActive = YES;
	
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .01 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			[udpProtocol receieveDataUDP:DefaultDataSize Port:StatusPort Timeout:-1];
			
		});


}

-(void) deactivateReceiver{
	
	
	[udpProtocol stopReceiver];

	

}

-(void) sendStatus:(DataFormat *) localdata{
	
	data = localdata;

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .01 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			
			[udpProtocol sendDataUDP:localdata ToIpAddress:localdata.receiverIp Port:StatusPort];
			
		});

}



-(void) onDataReceived:(DataFormat *) dataFormat{
	
	[statusAsyncManagerProtocol statusReceived:dataFormat];


}

-(void) onDataReceiveError{
	
	
	

}

-(void) onDataSentError{

		[statusAsyncManagerProtocol statusSentError];

}


-(void) dataSentSuccessfully{


	[statusAsyncManagerProtocol statusSentSuccessfully:data.statusType];
	
}

@end
