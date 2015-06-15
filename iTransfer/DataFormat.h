//
//  DataFormat.h
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum{
	
	OnlineAcivity = 0, FileInfo = 1, File = 2, FileReceiverReady = 3
	
}StatusType;

typedef enum {
	
	Online = 0, Offline = 1
	
}OnlineStatus;

static int DefaultDataSize = 124;
static int AppIdPosition = 0;
static int SenderIpPosition = 12;
static int SenderNamePosition = 26;
static int ReceiverIpPosition = 56;
static int ReceiverNamePosition = 70;
static int StatusTypePosition = 100;
static int StatusPosition = 101;
static NSString *appId = @"RingTransfer";

@interface DataFormat : NSObject{


	
}

@property(readwrite) NSString *senderIp;


@property(readwrite) NSString *senderName;
@property(readwrite) NSString *receiverIp;
@property(readwrite) NSString *receiverName;
@property(readwrite) StatusType statusType;
@property(readwrite) NSString *status;
@property(readwrite) char *file;
@property(readwrite) NSData *fileData;
@property(readwrite) int bufferSize;

-(char *) toByte ;
//-(void) toObject:(char *) data FileSize: (int) fileSize;
-(void) toObject:(NSData *) data FileSize: (int) fileSize;



@end
