//
//  LiveHubRemoteViewController.m
//  LiveHubRemote
//
//  Created by Christopher Baltzer on 11-04-11.
//  Copyright 2011 Christopher Baltzer. All rights reserved.
//

#import "LiveHubRemoteViewController.h"

@implementation LiveHubRemoteViewController

// Toolbar
@synthesize toolbar, toolbarUpArrow, toolbarDownArrow;

// Buttons
@synthesize playButton, prevButton, nextButton;
@synthesize homeButton, muteButton, optionsButton, powerButton;
@synthesize backButton;

// Swipe
@synthesize swipeArea;

// Network & Data
@synthesize net, settings;
@synthesize audioSession, audioPlayer;

#pragma mark
#pragma mark iPod controls
-(void) setupAudioPlayer {
    NSLog(@"%s", __func__);
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error: &activationErr];
    
    if (setCategoryErr) {
        NSLog(@"%@", [setCategoryErr localizedDescription]);
    }
    if (activationErr) {
        NSLog(@"%@", [activationErr localizedDescription]);
    }
    
    // If for some reason this doesn't work, it's likely because silence.wav is corrupted or something? replace it
    NSURL *audioURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"silence" ofType:@"wav"]];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
    self.audioPlayer.numberOfLoops = -1;
        
    if (audioPlayer == nil) {
        NSLog(@"Audio player error");
    } else {
        [self.audioPlayer play];
        [self.audioPlayer stop];
    }
    
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    NSLog(@"%s", __func__);
    
    switch (receivedEvent.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self sendPlay];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self sendPlay]; 
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            if ([settings boolForKey:@"ipod_nav_preference"]) {
                [net sendCommand:@"Up"]; // swipe up
            } else {
                [self sendPrev]; // previous
            }
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            if ([settings boolForKey:@"ipod_nav_preference"]) {
                [net sendCommand:@"Down"]; // swipe down
            } else {
                [self sendNext]; // next
            }
            break;
        default:
            break;
    }
}


#pragma mark 
#pragma mark Button controls
// Primary control methods
-(IBAction) sendPlay {
    [net sendCommand:@"Play"];
}

-(IBAction) sendPrev {
    [net sendCommand:@"Previous"];
}

-(IBAction) sendNext {
    [net sendCommand:@"Next"];
}

-(IBAction) sendBack {
    [net sendCommand:@"Back"];
}

// Seconary control methods
-(IBAction) sendHome {
    if (audioPlayer == nil) {
        [self setupAudioPlayer];
    } else {
        [audioPlayer play];
        [audioPlayer stop];
    }
    [net sendCommand:@"Home"];
}

-(IBAction) sendMute {
    [net sendCommand:@"Mute"];
}

-(IBAction) sendOptions {
    [net sendCommand:@"Options"];
}

-(IBAction) sendPower {
    [net sendCommand:@"Power"];
}

#pragma mark
#pragma mark Swipe controls

-(void) registerGestureRecognizers {
	// Add tap recognizer
	UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] 
                                    initWithTarget:self action:@selector(doubleTap:)] autorelease];
	tap.numberOfTapsRequired = 2;
	[self.swipeArea addGestureRecognizer:tap];
    
    
	// Up
	UISwipeGestureRecognizer *su = [[[UISwipeGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(swipeUp:)] autorelease];
	su.direction = UISwipeGestureRecognizerDirectionUp;
	[self.swipeArea addGestureRecognizer:su];
    
	// Down
	UISwipeGestureRecognizer *sd = [[[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipeDown:)] autorelease];
	sd.direction = UISwipeGestureRecognizerDirectionDown;
	[self.swipeArea addGestureRecognizer:sd];
	// Left
	UISwipeGestureRecognizer *sl = [[[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(swipeLeft:)] autorelease];
	sl.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.swipeArea addGestureRecognizer:sl];
	// Right
	UISwipeGestureRecognizer *sr = [[[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(swipeRight:)] autorelease];
	sr.direction = UISwipeGestureRecognizerDirectionRight;
	[self.swipeArea addGestureRecognizer:sr];
}

-(void) doubleTap:(UITapGestureRecognizer *)recognizer {
    [net sendCommand:@"OK"];
}

-(void) swipeUp:(UITapGestureRecognizer *)recognizer {
    [net sendCommand:@"Up"];
}

-(void) swipeDown:(UITapGestureRecognizer *)recognizer {
    [net sendCommand:@"Down"];
}

-(void) swipeLeft:(UITapGestureRecognizer *)recognizer {
    [net sendCommand:@"Left"];
}

-(void) swipeRight:(UITapGestureRecognizer *)recognizer {
    [net sendCommand:@"Right"];
}

#pragma mark
#pragma mark Animations
-(IBAction) slideToolbarUp {
    [UIView beginAnimations:@"UIBase Hide" context:nil];
    [UIView setAnimationDuration:0.35]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.toolbar.transform = CGAffineTransformMakeTranslation(0,0);
    [UIView commitAnimations];
}

-(IBAction) slideToolbarDown {
    [UIView beginAnimations:@"UIBase Show" context:nil];
    [UIView setAnimationDuration:0.35]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.toolbar.transform = CGAffineTransformMakeTranslation(0,60);
    [UIView commitAnimations];
}



#pragma mark 
#pragma mark View controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [self registerGestureRecognizers];
    
    self.settings = [NSUserDefaults standardUserDefaults];
    self.net = [[NetworkController alloc] initWithHostname:[settings stringForKey:@"hostname_preference"]];
    
    NSLog(@"Initializing with hostname: %@", [self.settings stringForKey:@"hostname_preference"]);
    NSLog(@"Use iPod for nav: %d", [self.settings boolForKey:@"ipod_nav_preference"]);

}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"%s", __func__);
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    [self setupAudioPlayer];
    
    
        
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
	[super viewWillDisappear:animated];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [net release];
    [audioPlayer release];
    [audioSession release];
    [super dealloc];
}

@end
