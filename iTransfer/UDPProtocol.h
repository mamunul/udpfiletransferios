//
//  UDPProtocol.h
//  iTransfer
//
//  Created by Mamunul on 5/20/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreFoundation/CFSocket.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import "DataFormat.h"

  static int StatusPort = 8887;
  static int DataPort = 8888;

@protocol UDPProtocolDelegate <NSObject>

-(void) onDataReceived:(DataFormat *) dataFormat;

-(void) onDataReceiveError;

-(void) onDataSentError;


-(void) dataSentSuccessfully;


@end

@interface UDPProtocol : NSObject



@property(weak) id<UDPProtocolDelegate> udpProtocolDelegate;

@property(readwrite) BOOL isReceiverActive;


-(bool) sendDataUDP:(DataFormat *) data ToIpAddress:(NSString*) ip Port:(int) p;

-(void) receieveDataUDP:(int) bufferSize Port:(int) port Timeout:(int) timeout ;

-(void)stopReceiver;

@end
