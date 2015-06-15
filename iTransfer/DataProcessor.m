//
//  DataProcessor.m
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "DataProcessor.h"

@implementation DataProcessor

-(DataFormat *)createOfflineStatusDataFromUserName:(NSString *)userName{

 return [self createStatusDataFromUserName:userName Status:Offline];
}

-(DataFormat *)createOnlineStatusDataFromUserName:(NSString *)userName{

	 return [self createStatusDataFromUserName:userName Status:Online];
}


-(DataFormat *)createStatusDataFromUserName:(NSString *)userName Status:(OnlineStatus) onlineStatus{
	
	DataFormat *dataFormat = [[DataFormat alloc] init];
	
	
	dataFormat.senderName = userName;
	dataFormat.senderIp = [self getIPAddress];
	dataFormat.receiverIp = [self getBroadcastAddress];
	dataFormat.receiverName = @"All";
	
	dataFormat.statusType = OnlineAcivity;
	dataFormat.status =  [NSString stringWithFormat:@"%@", [[NSNumber alloc] initWithInt:onlineStatus]];
	
 return dataFormat;
}

-(DataFormat *)createFileInfoStatus:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp  FileFormat:(NSString *) fileFormat FileSize:(int) fileSize{
	
	DataFormat *dataFormat = [[DataFormat alloc] init];
	
	
	dataFormat.senderName = fromUserName;
	dataFormat.senderIp = [self getIPAddress];
	dataFormat.receiverIp = toUserIp;
	dataFormat.receiverName = @"All";
	dataFormat.statusType = FileInfo;
	dataFormat.status = [NSString stringWithFormat:@"%@:%d",fileFormat,fileSize];

	 return dataFormat;

}

-(DataFormat *)createFileReceiveReadyStatus:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp{
	
	DataFormat *dataFormat = [[DataFormat alloc] init];
	
	
	dataFormat.senderName = fromUserName;
	dataFormat.senderIp = [self getIPAddress];
	dataFormat.receiverIp = [self getBroadcastAddress];
	dataFormat.receiverName = @"All";
	dataFormat.statusType = FileReceiverReady ;
	dataFormat.status = @"9";

	 return dataFormat;

}

-(DataFormat *)createFileData:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp Data:(NSData *) data{
	DataFormat *dataFormat = [[DataFormat alloc] init];
	
	
	dataFormat.senderName = fromUserName;
	dataFormat.senderIp = [self getIPAddress];
	dataFormat.receiverIp = toUserIp;
	dataFormat.receiverName = @"All";
	dataFormat.statusType = File;
	
//	memcpy(dataFormat.file, data, (int) strlen(data));
	
	dataFormat.fileData = data;
//	dataFormat.file = data;

	 return dataFormat;

}


-(NSString *)getBroadcastAddress{
	NSString * broadcastAddr= @"Error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	
	if (success == 0)
	{
		temp_addr = interfaces;
		
		while(temp_addr != NULL)
		{
			// check if interface is en0 which is the wifi connection on the iPhone
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					broadcastAddr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
					
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	freeifaddrs(interfaces);
	return broadcastAddr;

}


- (NSString *)getIPAddress {
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0) {
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL) {
			if(temp_addr->ifa_addr->sa_family == AF_INET) {
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
					// Get NSString from C String
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
				}
			}
			temp_addr = temp_addr->ifa_next;
		}
	}
	// Free memory
	freeifaddrs(interfaces);
	return address;
	
}
@end
