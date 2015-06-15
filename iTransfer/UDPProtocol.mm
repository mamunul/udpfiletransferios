//
//  UDPProtocol.m
//  iTransfer
//
//  Created by Mamunul on 5/20/15.
//  Copyright (c) 2015 Mamunul. All rights reserved.
//

#import "UDPProtocol.h"
#import <ifaddrs.h>

@interface UDPProtocol ()
{

	int sock;
	
}

@end


@implementation UDPProtocol

@synthesize udpProtocolDelegate,isReceiverActive;

-(void)stopReceiver{

	isReceiverActive = NO;
	close(sock);
	

}


-(void) startReceiver{
	isReceiverActive = YES;
	
//	[self receieveDataUDP:nullptr Port:8887 Timeout:100];

}

-(bool) sendDataUDP:(DataFormat *) data ToIpAddress:(NSString*) ip Port:(int) p
{
	
//	NSLog(@"ip:%@",[self getIPAddress]);
//	int sock;
	struct sockaddr_in destination;
	unsigned int echolen;
	int broadcast = 1;
	// if that doesn't work, try this
	//char broadcast = '1';
 
//	NSString *msg = @"msg";
	
	
	if (ip == nil)
	{
		printf("Message and/or ip address is null\n");
		return false;
	}
 
	/* Create the UDP socket */
	if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
	{
		printf("Failed to create socket\n");      return false;
	}
 
	/* Construct the server sockaddr_in structure */
	memset(&destination, 0, sizeof(destination));
 
	/* Clear struct */
	destination.sin_family = AF_INET;
 
	/* Internet/IP */
	destination.sin_addr.s_addr = inet_addr([ip UTF8String]);
 
	/* IP address */
	destination.sin_port = htons(p);
 
	/* server port */
	setsockopt(sock,
      IPPROTO_IP,
      IP_MULTICAST_IF,
      &destination,
      sizeof(destination));
	const char *cmsg = [data toByte];
	echolen = [data bufferSize];
	
	
//	NSData *byteArray = [data toByte];
	
//	 char *cmsg = (char *)[byteArray bytes];
	
	
	NSData *d = [[NSData alloc] initWithBytes:cmsg length:echolen];
//
	NSLog(@"file::%d,%@",echolen, d);
 
	// this call is what allows broadcast packets to be sent:
	if (setsockopt(sock,
				   SOL_SOCKET,
				   SO_BROADCAST,
				   &broadcast,
				   sizeof broadcast) == -1)
	{
		perror("setsockopt (SO_BROADCAST)");
		exit(1);
	}
	if (sendto(sock,
      cmsg,
      echolen,
      0,
      (struct sockaddr *) &destination,
      sizeof(destination)) != echolen)
	{
		printf("Mismatch in number of sent bytes\n");
		return false;
	}
	else
	{
		
		[udpProtocolDelegate dataSentSuccessfully];
		
		return true;
	}
	destination =  {0};
	close(sock);
}



-(void) receieveDataUDP:(int) bufferSize Port:(int) port Timeout:(int) timeout {
	NSLog(@"UDP Server started...");
//	int
	sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
	struct sockaddr_in sa;
	
	char *recvBuf = (char*) malloc(bufferSize);// new char[DefaultDataSize];
		
	memset (recvBuf,' ',bufferSize);
 
	memset(&sa, 0, sizeof(sa));
	sa.sin_family = AF_INET;
	sa.sin_addr.s_addr = INADDR_ANY;
	sa.sin_port = htons(port);
 
	// bind the socket to our address
	if (-1 == bind(sock,(struct sockaddr *)&sa, sizeof(struct sockaddr)))
	{
		perror("error bind failed");
		close(sock);
		exit(EXIT_FAILURE);
	}
	
	socklen_t socklen;
	struct timeval timeoutValue;
	timeoutValue.tv_sec = timeout;
	timeoutValue.tv_usec = 0;
	
	if(timeout >0){
	
		if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeoutValue,
					sizeof(timeoutValue)) < 0)
			perror("setsockopt failed\n");
	}
	
	NSLog(@"buffer size:%d",bufferSize);

	while (isReceiverActive)
	{
		
		int recsize = recvfrom(sock,(void *)recvBuf,bufferSize,0,(struct sockaddr *)&sa,&socklen);
		
		if (recsize < 0){
//			fprintf(stderr, "%s\n", strerror(errno));
			[udpProtocolDelegate onDataReceiveError];
		}else{
			
			NSData* data = [NSData dataWithBytes:(const void *)recvBuf length:bufferSize];
			
			NSData *senderIp = [data subdataWithRange:NSMakeRange(SenderIpPosition, SenderNamePosition - SenderIpPosition)];
			
			NSString* newStr = [[NSString alloc] initWithData:senderIp encoding:NSUTF8StringEncoding];
	
			DataFormat *dataFormat = [[DataFormat alloc] init];
			
			
			[dataFormat toObject:data FileSize:-1];
			
			[udpProtocolDelegate onDataReceived:dataFormat];

		}

	}
	sa =  {0};
	close(sock);
	sock = 0;


}


@end
