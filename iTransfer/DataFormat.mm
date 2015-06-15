//
//  DataFormat.m
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "DataFormat.h"

@implementation DataFormat

@synthesize receiverIp,receiverName,senderIp,senderName,status,statusType,file,fileData,bufferSize;



-(char *) toByte {
	
	char *data;
 
	if (statusType == File) {
		
		data = (char*) malloc(DefaultDataSize +[fileData length]);
		memset (data,' ',DefaultDataSize +[fileData length]);
		
		bufferSize = DefaultDataSize +[fileData length];
		
	}else{
	
		data = (char*) malloc(DefaultDataSize);
		memset (data,' ',DefaultDataSize);
	
		bufferSize = DefaultDataSize;
		
	}
	
	
	
	NSString *statusTypeStrring = [NSString stringWithFormat:@"%@", [[NSNumber alloc] initWithInt:statusType]];
	
	const char *receiverNameBytes = receiverName.UTF8String;

	const char *receiverIpBytes = receiverIp.UTF8String;

	
	const char *senderNameBytes = senderName.UTF8String;


	const char *senderIpBytes =  senderIp.UTF8String;

	
	const char *AppIdBytes = appId.UTF8String;

	
	const char *statusBytes = status.UTF8String;

	
	const char *statusTypeBytes = statusTypeStrring.UTF8String;

	
	[self arraycopySrc:AppIdBytes srcPos:0 DestData:data DestPos:AppIdPosition SrcLength:(int)strlen(AppIdBytes)];
	[self arraycopySrc:senderIpBytes srcPos:0 DestData:data DestPos:SenderIpPosition SrcLength:(int)strlen(senderIpBytes)];
	[self arraycopySrc:senderNameBytes srcPos:0 DestData:data DestPos:SenderNamePosition SrcLength:(int)strlen(senderNameBytes)];
	[self arraycopySrc:receiverIpBytes srcPos:0 DestData:data DestPos:ReceiverIpPosition SrcLength:(int)strlen(receiverIpBytes)];
	[self arraycopySrc:receiverNameBytes srcPos:0 DestData:data DestPos:ReceiverNamePosition SrcLength:(int)strlen(receiverNameBytes)];
	
	[self arraycopySrc:statusTypeBytes srcPos:0 DestData:data DestPos:StatusTypePosition SrcLength:(int)strlen(statusTypeBytes)];

	NSData *d = NULL;
	if (statusType == File) {
		file = (char*) [fileData bytes];
		
		NSLog(@"file Data:%d", [fileData length]);
		[self arraycopySrc:file srcPos:0 DestData:data DestPos:StatusPosition SrcLength:[fileData length]];

		d = [[NSData alloc] initWithBytes:data length:DefaultDataSize +[fileData length]];
//
		
		
	}else{
		[self arraycopySrc:statusBytes srcPos:0 DestData:data DestPos:StatusPosition SrcLength:(int)strlen(statusBytes)];
		d = [[NSData alloc] initWithBytes:data length:DefaultDataSize];
	
	}
	NSLog(@"file in format::%@", d);

	return data;

}
-(void) toObject:(NSData *) data FileSize: (int) fileSize{
	

	NSData *AppIdData = [data subdataWithRange:NSMakeRange(0,SenderIpPosition)];
	
	appId = [[NSString alloc] initWithData:AppIdData encoding:NSUTF8StringEncoding];
	
	
	NSData *senderIpData = [data subdataWithRange:NSMakeRange(SenderIpPosition, SenderNamePosition - SenderIpPosition)];
	
	senderIp = [[NSString alloc] initWithData:senderIpData encoding:NSUTF8StringEncoding];
	
	
	NSData *senderNameData = [data subdataWithRange:NSMakeRange(SenderNamePosition,ReceiverIpPosition- SenderNamePosition)];
	
	senderName = [[NSString alloc] initWithData:senderNameData encoding:NSUTF8StringEncoding];
	
	
	NSData *receiverIpData = [data subdataWithRange:NSMakeRange(ReceiverIpPosition,ReceiverNamePosition
																				  - ReceiverIpPosition)];
	
	receiverIp = [[NSString alloc] initWithData:receiverIpData encoding:NSUTF8StringEncoding];
	
	NSData *receiverNameData = [data subdataWithRange:NSMakeRange(ReceiverNamePosition,StatusTypePosition
																 							- ReceiverNamePosition)];
	
	receiverName = [[NSString alloc] initWithData:receiverNameData encoding:NSUTF8StringEncoding];
	

	NSData *statusTypeData = [data subdataWithRange:NSMakeRange(StatusTypePosition,StatusPosition - StatusTypePosition)];
	

	
	NSData *statusData = [data subdataWithRange:NSMakeRange(StatusPosition,DefaultDataSize - StatusPosition)];
	
	status = [[NSString alloc] initWithData:statusData encoding:NSUTF8StringEncoding];
	

	
	NSString *statusTypeString = [[NSString alloc] initWithData:statusTypeData encoding:NSUTF8StringEncoding];
	
	int s = [statusTypeString intValue];
	
	switch (s) {
		case 0:
			statusType =  OnlineAcivity;
			break;
			
		case 1:
			statusType = FileInfo ;
			break;
			
		case 2:
			statusType =  File;
			break;
			
		case 3:
			statusType = FileReceiverReady ;
			break;
			
		default:
			break;
	}

	if (statusType == File) {
	
		fileData = [data subdataWithRange:NSMakeRange(StatusPosition,[data length] - StatusPosition)];
	
	}

}


-(void)arraycopySrc:(const char *) src srcPos:(int) spos DestData:(char *)data DestPos:(int) dpos SrcLength:(int) length{
	
	memcpy( &data[dpos], &src[spos], length );
	
}


@end
