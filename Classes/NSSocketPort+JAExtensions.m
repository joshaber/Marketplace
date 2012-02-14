//
//  NSSocketPort+JAExtensions.m
//  DandyRemoteServer
//
//  Created by Josh Abernathy on 2/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSSocketPort+JAExtensions.h"

#import <netinet/in.h>


@implementation NSSocketPort (JAExtensions)

- (int)port {
	struct sockaddr_in serverAddress;
	socklen_t namelen = sizeof(serverAddress);
	
	getsockname(self.socket, (struct sockaddr *)&serverAddress, &namelen);
	
	return ntohs(serverAddress.sin_port);
}

@end
