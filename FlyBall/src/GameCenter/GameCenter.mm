//
//  GameCenter.mm
//  Torque2D
//
//  Created by Justin Mosiman on 10/29/10.
//  Copyright 2010 Opsive, LLC. All rights reserved.
//
#import "GameCenter.h"
#import "cocos2d.h"
#import "AnalyticsData.h"
#import "FlurryAnalytics.h"
#import "AppDelegate.h"

@implementation GameCenter

@synthesize isAvailable;
@synthesize match;
@synthesize delegate;
@synthesize playersDict;
@synthesize pendingInvite;
@synthesize pendingPlayersToInvite;
//@synthesize gameCenterViewController;

static GameCenter *instance_;

static void GameCenter_remover() {
	[instance_ release];
}

+ (GameCenter*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}

- (id)init {
	self = [super init];
	instance_ = self;
    
	atexit(GameCenter_remover);
    
    isAuthenticated = NO;
	
	return self;
}

- (void)dealloc {
    //[gameCenterViewController release];
	[super dealloc];
}

//--------------------------------------------------------
// Static functions/variables
//--------------------------------------------------------

static NSString *getGameCenterSavePath()
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [NSString stringWithFormat:@"%@/GameCenterSave.txt",[paths objectAtIndex:0]];
}

static NSString *scoresArchiveKey = @"Scores";

static NSString *achievementsArchiveKey = @"Achievements";

//--------------------------------------------------------
// Authentication
//--------------------------------------------------------

- (void) checkGameCenterAvailable {
    //Check for presence of GKLoccalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running iOs 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    isAvailable = (gcClass && osVersionSupported);
    
    if (isAvailable) CCLOG(@"[ENGINE MSG] - GameCenter is AVAILABLE");
    else CCLOG(@"[ENGINE MSG] - GameCenter is NOT AVAILABLE");
}

- (void)authenticateLocalPlayer {
    [self checkGameCenterAvailable];
	
	if(!isAvailable){
		return;
	}
	
    [self registerForAuthenticationNotification];
	
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {		
		if (error == nil){
			// Insert code here to handle a successful authentication.
			
			// report any unreported scores or achievements
			[self retrieveScoresFromDevice];
			[self retrieveAchievementsFromDevice];
			
            CCLOG(@"[ENGINE MSG] - GameCenter - is ready!");
		}else{
            CCLOG(@"[ENGINE MSG] - GameCenter - not ready!");
		}
	}];
}

- (void)authenticationChanged
{
	CCLOG(@"[ENGINE MSG] - GameCenter - authenticationChanged");
	if(!isAvailable) return;
	
    if ([GKLocalPlayer localPlayer].isAuthenticated && !isAuthenticated){
        NSLog(@"[ENGINE MSG] - GameCenter - Authentication changed: player authenticated.");
        
		isAuthenticated = YES;
        
        [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
            
            NSLog(@"[ENGINE MSG] - GameCenter - Received invite");
            self.pendingInvite = acceptedInvite;
            self.pendingPlayersToInvite = playersToInvite;
            [delegate inviteReceived];
            
        };
	}else
    if (![GKLocalPlayer localPlayer].isAuthenticated && isAuthenticated) {
        isAuthenticated = NO;
		NSLog(@"[ENGINE MSG] - GameCenter - Authentication changed: player not authenticated");
	}
}

- (void)registerForAuthenticationNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
}

- (BOOL)getAuthenticated
{
	return isAvailable && isAuthenticated;
}

- (void) hideGameCenterWindow {
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [[app navController] dismissModalViewControllerAnimated:NO];
    //[self dismissModalViewControllerAnimated:NO];
    //[self.view removeFromSuperview];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}

//--------------------------------------------------------
// Leaderboard
//--------------------------------------------------------

- (void)reportScore:(int)score forCategory:(NSString*)category
{
	if(!isAvailable)
		return;
	
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	if(scoreReporter){
		scoreReporter.value = score;	
		
        CCLOG(@"save score to Game Center = %d",score);
        
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {	
			if (error != nil){
				// handle the reporting error
				[self saveScoreToDevice:scoreReporter];
			} else {
            }
		}];	
	}
}

- (void)reportScore:(GKScore *)scoreReporter
{
	if(!isAvailable)
		return;
	
	if(scoreReporter){
		[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {	
			if (error != nil){
				// handle the reporting error
				[self saveScoreToDevice:scoreReporter];
			}
		}];	
	}
}

- (void)saveScoreToDevice:(GKScore *)score
{
	NSString *savePath = getGameCenterSavePath();
	
	// If scores already exist, append the new score.
	NSMutableArray *scores = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];
		
		NSData *data = [dict objectForKey:scoresArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:scoresArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	[scores addObject:score];
	
	// The score has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:scores forKey:scoresArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];
}

- (void)retrieveScoresFromDevice
{
	NSString *savePath = getGameCenterSavePath();
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		return;
	}
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:scoresArchiveKey];
	
	// A file exists, but it isn't for the scores key so return
	if(!data){
		return;
	}
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *scores = [unarchiver decodeObjectForKey:scoresArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the scores key and save the dictionary back again
	[dict removeObjectForKey:scoresArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	
	
	// Since the scores key was removed, we can go ahead and report the scores again
	for(GKScore *score in scores){
		[self reportScore:score];
	}
}

- (void)showLeaderboard
{
	if(!isAuthenticated)
		return;
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];	
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
		
        [[CCDirector sharedDirector] pause];
        [[CCDirector sharedDirector] stopAnimation];
        
		//UIWindow* window = [UIApplication sharedApplication].keyWindow;
        //[window addSubview: self.view];
        AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
        
        [[app navController] presentModalViewController: leaderboardController animated: YES];
        [FlurryAnalytics logEvent:ANALYTICS_LEADERBOARD_SCREEN_OPENED];
    }	
    [leaderboardController release];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    //[gameCenterViewController dismissModalViewControllerAnimated:NO];
	//[gameCenterViewController.view removeFromSuperview];
	
    //[gameCenterViewController release];
    
    [self hideGameCenterWindow];
}

//--------------------------------------------------------
// Achievements
//--------------------------------------------------------

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent
{
	if(!isAvailable)
		return;
	
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];	
    if (achievement){		
		achievement.percentComplete = percent;		
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
			if (error != nil){
				[self saveAchievementToDevice:achievement];
			}		 
		}];
    }
}

- (void)reportAchievementIdentifier:(GKAchievement *)achievement
{	
	if(!isAvailable)
		return;
	
    if (achievement){		
		[achievement reportAchievementWithCompletionHandler:^(NSError *error){
			if (error != nil){
				[self saveAchievementToDevice:achievement];
			}		 
		}];
    }
}

- (void)saveAchievementToDevice:(GKAchievement *)achievement
{
	
	NSString *savePath = getGameCenterSavePath();
	
	// If achievements already exist, append the new achievement.
	NSMutableArray *achievements = [[[NSMutableArray alloc] init] autorelease];
	NSMutableDictionary *dict;
	if([[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		dict = [[[NSMutableDictionary alloc] initWithContentsOfFile:savePath] autorelease];
		
		NSData *data = [dict objectForKey:achievementsArchiveKey];
		if(data) {
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
			[unarchiver finishDecoding];
			[unarchiver release];
			[dict removeObjectForKey:achievementsArchiveKey]; // remove it so we can add it back again later
		}
	}else{
		dict = [[[NSMutableDictionary alloc] init] autorelease];
	}
	
	
	[achievements addObject:achievement];
	
	// The achievement has been added, now save the file again
	NSMutableData *data = [NSMutableData data];	
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:achievements forKey:achievementsArchiveKey];
	[archiver finishEncoding];
	[dict setObject:data forKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	[archiver release];	
}

- (void)retrieveAchievementsFromDevice
{
	NSString *savePath = getGameCenterSavePath();
	
	// If there are no files saved, return
	if(![[NSFileManager defaultManager] fileExistsAtPath:savePath]){
		return;
	}
	
	// First get the data
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
	NSData *data = [dict objectForKey:achievementsArchiveKey];
	
	// A file exists, but it isn't for the achievements key so return
	if(!data){
		return;
	}
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	NSArray *achievements = [unarchiver decodeObjectForKey:achievementsArchiveKey];
	[unarchiver finishDecoding];
	[unarchiver release];
	
	// remove the achievements key and save the dictionary back again
	[dict removeObjectForKey:achievementsArchiveKey];
	[dict writeToFile:savePath atomically:YES];
	
	// Since the key file was removed, we can go ahead and try to report the achievements again
	for(GKAchievement *achievement in achievements){
		[self reportAchievementIdentifier:achievement];
	}
}

- (void)showAchievements
{	
	if(!isAuthenticated)
		return;
	
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];	
    if (achievements != nil){
        achievements.achievementDelegate = self;
		
        [[CCDirector sharedDirector] pause];
        [[CCDirector sharedDirector] stopAnimation];
        
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		//[[app navController] addSubview: self.view];
        [[app navController] presentModalViewController: achievements animated: YES];
        [FlurryAnalytics logEvent:ANALYTICS_ACHIEVEMENTS_SCREEN_OPENED];
    }	
    [achievements release];
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    //[gameCenterViewController dismissModalViewControllerAnimated:NO];
	//[gameCenterViewController.view removeFromSuperview];
    
    [self hideGameCenterWindow];
    
	//[gameCenterViewController release];
}

- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                       delegate:(id<GCHelperDelegate>)theDelegate {
    
    if (!isAvailable) return;
    
    matchStarted = NO;
    self.match = nil;
    //self.presentingViewController = viewController;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview: self.view];
    
    [[CCDirector sharedDirector] pause];
    [[CCDirector sharedDirector] stopAnimation];
    
    delegate = theDelegate;
    AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [[app navController] dismissModalViewControllerAnimated:NO];
    //[self dismissModalViewControllerAnimated:NO];
    
    if (pendingInvite != nil) {
        GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithInvite:pendingInvite] autorelease];
        mmvc.matchmakerDelegate = self;
        [self presentModalViewController:mmvc animated:NO];
        
        self.pendingInvite = nil;
        self.pendingPlayersToInvite = nil;
        
    } else {
        GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease];
        request.minPlayers = minPlayers;
        request.maxPlayers = maxPlayers;
        request.playersToInvite = pendingPlayersToInvite;
        
        GKMatchmakerViewController *mmvc = [[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];
        mmvc.matchmakerDelegate = self;
        
        [self presentModalViewController:mmvc animated:NO];
        
        self.pendingInvite = nil;
        self.pendingPlayersToInvite = nil;
        
    }
    
}

- (void)lookupPlayers {
    
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
            
            // Populate players dict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }
            
            // Notify delegate match can begin
            matchStarted = YES;
            [delegate matchStarted];
            
        }
    }];
    
}

#pragma mark GKMatchmakerViewControllerDelegate

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [self hideGameCenterWindow];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [self hideGameCenterWindow];
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [self hideGameCenterWindow];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}

#pragma mark GKMatchDelegate

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (match != theMatch) return;
    
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    if (match != theMatch) return;
    
    switch (state) {
        case GKPlayerStateConnected:
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
            
            break;
        case GKPlayerStateDisconnected:
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
    
    if (match != theMatch) return;
    
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

@end