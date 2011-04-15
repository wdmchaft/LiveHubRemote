//
//  NetworkController.h
//  LiveHubRemote
//
//  Created by Christopher Baltzer on 11-04-12.
//  Copyright 2011 Christopher Baltzer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkController : NSObject {
    NSDictionary *commands;
    NSString *hostname;
}

@property (nonatomic, retain) NSDictionary *commands;
@property (nonatomic, retain) NSString *hostname;

-(id) initWithHostname:(NSString*)host;
-(void) sendCommand:(NSString*)commandString;

@end
