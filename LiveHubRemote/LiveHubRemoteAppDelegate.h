//
//  LiveHubRemoteAppDelegate.h
//  LiveHubRemote
//
//  Created by Christopher Baltzer on 11-04-11.
//  Copyright 2011 Christopher Baltzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveHubRemoteViewController;

@interface LiveHubRemoteAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet LiveHubRemoteViewController *viewController;

@end
