//
//  LiveHubRemoteViewController.h
//  LiveHubRemote
//
//  Created by Christopher Baltzer on 11-04-11.
//  Copyright 2011 Christopher Baltzer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NetworkController.h"


@interface LiveHubRemoteViewController : UIViewController {
    // Toolbar controls
    IBOutlet UIView *toolbar;
    IBOutlet UIButton *toolbarUpArrow;
    IBOutlet UIButton *toolbarDownArrow;
    
    // Primary controls
    IBOutlet UIButton *playButton;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIView *swipeArea;
    
    // Secondary controls
    IBOutlet UIButton *homeButton;
    IBOutlet UIButton *muteButton;
    IBOutlet UIButton *optionsButton;
    IBOutlet UIButton *powerButton;

    
    NetworkController *net;
    NSUserDefaults *settings;
    AVAudioSession *audioSession;
    AVAudioPlayer *audioPlayer;
    
}

// UI
@property (nonatomic, retain) IBOutlet UIView *toolbar;
@property (nonatomic, retain) IBOutlet UIButton *toolbarUpArrow;
@property (nonatomic, retain) IBOutlet UIButton *toolbarDownArrow;

// Primary controls
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIView *swipeArea;

// Secondary controls
@property (nonatomic, retain) IBOutlet UIButton *homeButton;
@property (nonatomic, retain) IBOutlet UIButton *muteButton;
@property (nonatomic, retain) IBOutlet UIButton *optionsButton;
@property (nonatomic, retain) IBOutlet UIButton *powerButton;


// Network & Data
@property (nonatomic, retain) NetworkController *net;
@property (nonatomic, retain) NSUserDefaults *settings;
@property (nonatomic, retain) IBOutlet AVAudioSession *audioSession;
@property (nonatomic, retain) IBOutlet AVAudioPlayer *audioPlayer;

// Setup
-(void) setupAudioPlayer;

// Animations
-(IBAction) slideToolbarUp;
-(IBAction) slideToolbarDown;

// Primary control methods
-(IBAction) sendPlay;
-(IBAction) sendPrev;
-(IBAction) sendNext;
-(IBAction) sendBack;

// Seconary control methods
-(IBAction) sendHome;
-(IBAction) sendMute;
-(IBAction) sendOptions;
-(IBAction) sendPower;

// Swipe control methods
-(void) registerGestureRecognizers;
-(void) doubleTap:(UITapGestureRecognizer *)recognizer;
-(void) swipeUp:(UITapGestureRecognizer *)recognizer;
-(void) swipeDown:(UITapGestureRecognizer *)recognizer;
-(void) swipeLeft:(UITapGestureRecognizer *)recognizer;
-(void) swipeRight:(UITapGestureRecognizer *)recognizer;


@end
