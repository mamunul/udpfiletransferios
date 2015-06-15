//
//  DataProcessor.h
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ifaddrs.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "DataFormat.h"

typedef enum {
	
	Activate, Send, Receive, Inactive
	
}CommStatus;

@interface DataProcessor : NSObject



-(DataFormat *)createOfflineStatusDataFromUserName:(NSString *)userName;
-(DataFormat *)createOnlineStatusDataFromUserName:(NSString *)userName;
-(DataFormat *)createFileInfoStatus:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp  FileFormat:(NSString *) fileFormat FileSize:(int) fileSize;
-(DataFormat *)createFileReceiveReadyStatus:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp;
-(DataFormat *)createFileData:(NSString *) fromUserName  ToUserIp:(NSString *) toUserIp Data:(NSData *) data;


@end
