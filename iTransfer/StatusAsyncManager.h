//
//  CommunicationManager.h
//  iTransfer
//
//  Created by Mamunul on 5/23/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFormat.h"
#import "UDPProtocol.h"


@protocol StatusAsyncManagerProtocol <NSObject>


-(void) statusReceived:(DataFormat *) dataFormat;

-(void) statusSentSuccessfully:(StatusType )statusType;

-(void) statusSentError;

@end


@interface StatusAsyncManager : NSObject<UDPProtocolDelegate>

@property(readwrite,weak) id<StatusAsyncManagerProtocol> statusAsyncManagerProtocol;


-(void) activateStatusReceiver;

-(void) deactivateReceiver;

-(void) sendStatus:(DataFormat *) data;

@end
