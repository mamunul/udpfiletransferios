//
//  DataAsyncManager.h
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFormat.h"
#import "UDPProtocol.h"
#import "User.h"

@protocol DataAsyncManagerProtocol <NSObject>

-(void) fileReceived:(DataFormat *) dataFormat;

-(void) fileReceivedError;

-(void) fileSentSuccessfully;

-(void) fileSentError;

@end

@interface DataAsyncManager : NSObject<UDPProtocolDelegate>

@property(readwrite,weak) id<DataAsyncManagerProtocol> dataAsyncManagerProtocol;




-(void) activateDataReceiverWithFileSize:(int) fileSize;

-(void) deactivateReceiver;

-(void) sendData:(DataFormat *) data User:(User *) user;

@end
