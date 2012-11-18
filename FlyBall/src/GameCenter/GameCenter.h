//
//  GameCenter.m
//  Torque2D
//
//  Created by Justin Mosiman on 10/29/10.
//  Copyright 2010 Opsive, LLC. All rights reserved.
//

#import <GameKit/GameKit.h>

@protocol GCHelperDelegate
    - (void)matchStarted;
    - (void)matchEnded;
    - (void)match:(GKMatch *)match didReceiveData:(NSData *)data
       fromPlayer:(NSString *)playerID;
    - (void)inviteReceived;
@end

@interface GameCenter : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate>
{
	BOOL isAuthenticated;
	BOOL isAvailable;
    
    GKMatch *match;
    BOOL matchStarted;
    id <GCHelperDelegate> delegate;
    
    NSMutableDictionary *playersDict;
    
    GKInvite *pendingInvite;
    NSArray *pendingPlayersToInvite;
    
	//UIViewController *gameCenterViewController;
}

@property (nonatomic, readonly) BOOL isAvailable;
//@property (nonatomic,retain) UIViewController *gameCenterViewController;
@property (retain) GKMatch *match;
@property (assign) id <GCHelperDelegate> delegate;
@property (retain) NSMutableDictionary *playersDict;
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;

+(GameCenter*) instance;

- (id) init;
- (void) dealloc;

- (void) checkGameCenterAvailable;

- (void)authenticateLocalPlayer;
- (void)registerForAuthenticationNotification;
- (void)authenticationChanged;
- (BOOL)getAuthenticated;

- (void)reportScore:(int)score forCategory:(NSString*)category;
- (void)reportScore:(GKScore *)scoreReporter;
- (void)saveScoreToDevice:(GKScore *)score;
- (void)retrieveScoresFromDevice;
- (void)showLeaderboard;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
- (void)reportAchievementIdentifier:(GKAchievement *)achievement;
- (void)saveAchievementToDevice:(GKAchievement *)achievement;
- (void)retrieveAchievementsFromDevice;
- (void)showAchievements;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                       delegate:(id<GCHelperDelegate>)theDelegate;

@end

/*static GameCenter *gameCenter;

namespace GameCenterWrapper {
	void authenticate();
	void reportScore(int score, int category);
	void reportAchievement(int achievement);
	bool isAuthenticated();
	void showLeaderboard();
	void showAchievements();
	void close();
}*/