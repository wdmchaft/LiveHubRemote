//
//  NetworkController.m
//  LiveHubRemote
//
//  Created by Christopher Baltzer on 11-04-12.
//  Copyright 2011 Christopher Baltzer. All rights reserved.
//

#import "NetworkController.h"


@implementation NetworkController

@synthesize commands, hostname;

-(id) initWithHostname:(NSString*)host {
    self = [super init];
    if (self) {
        NSString *commandsFile = [[NSBundle mainBundle] pathForResource:@"Commands" ofType:@"plist"];
        self.commands = [[NSDictionary alloc] initWithContentsOfFile:commandsFile];
        
        self.hostname = host;
    }
    return self;
}

-(void) sendCommand:(NSString *)commandString {
    NSString *cmd = [commands valueForKey:commandString];
    NSLog(@"%@ - %@", commandString, cmd);
    
    NSString *host = [NSString stringWithFormat:@"http://%@/cgi-bin/toServerValue.cgi", self.hostname];
	NSURL *url = [NSURL URLWithString:host];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSString *str = [NSString stringWithFormat:@"{'remote':'%@'}", cmd];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void) dealloc {
    [self.commands release];
    [super dealloc];
}

@end
