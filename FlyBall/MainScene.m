//
//  MainScene.m
//  FlyBall
//
//  Created by Zakhar Gadzhiev on 14.11.12.
//  Copyright Zakhar Gadzhiev 2012. All rights reserved.
//


// Import the interfaces
#import "MainScene.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SimpleAudioEngine.h"
#import "globalParam.h"
#import "Defs.h"
#import	"ZMenu.h"
#import "ZGame.h"
#import "AboutScreen.h"
#import "GameStandartFunctions.h"
#import "AnalyticsData.h"
#import "FlurryAnalytics.h"
#import "MyData.h"


#pragma mark - MainScene

@implementation MainScene

@synthesize marketScreen;
@synthesize game;
@synthesize pauseScreen;
@synthesize gui;


static MainScene *instance_;
static void MainScene_remover() {
	[instance_ release];
}

+ (MainScene*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainScene *layer = [MainScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
        instance_ = self;
		
		atexit(MainScene_remover);
		
		srandom(time(NULL));
		// enable touches
		self.touchEnabled = YES;
        
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
        
        SCREEN_WIDTH = screenSize.width;
        SCREEN_HEIGHT = screenSize.height;
        
        SCREEN_WIDTH_HALF = SCREEN_WIDTH * 0.5;
        SCREEN_HEIGHT_HALF = SCREEN_HEIGHT * 0.5;
		
		[self gameLoaded];
        
        [self scheduleUpdate];
        
		
	}
	return self;
}

- (void) gameLoaded {
	
	[Defs instance].objectFrontLayer = [CCNode node];
	
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    [Defs instance].spriteSheetChars = [CCSpriteBatchNode batchNodeWithFile: @"gfx_chars.pvr.ccz" capacity: 100];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gfx_chars.plist" texture:[Defs instance].spriteSheetChars.texture];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    [Defs instance].spriteSheetCells = [CCSpriteBatchNode batchNodeWithFile: @"gfx_cells.jpg" capacity: 100];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gfx_cells.plist" texture:[Defs instance].spriteSheetCells.texture];
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
    //[MyData decodeDict];
    
    [Defs instance].startGameNotFirstTime = [[NSUserDefaults standardUserDefaults] boolForKey:@"startGameNotFirstTime"];
    
    //[Defs instance].startGameNotFirstTime = [[MyData getStoreValue:@"startGameNotFirstTime"] boolValue];
    
    if ([Defs instance].startGameNotFirstTime) {
        //[Defs instance].isSoundMute = [[Defs instance].userSettings boolForKey:@"isSoundMute"];
        [Defs instance].isSoundMute = [[MyData getStoreValue:@"isSoundMute"] boolValue];
        //[Defs instance].isMusicMute = [[Defs instance].userSettings boolForKey:@"isMusicMute"];
        [Defs instance].isMusicMute = [[MyData getStoreValue:@"isMusicMute"] boolValue];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"startGameNotFirstTime"];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary * dict = [prefs dictionaryRepresentation];
        //NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObject:@"a" forKey:@"b"];
        [MyData encodeDict:dict];
        [MyData getDictForSaveData];
        
        [Defs instance].isSoundMute = NO;
        [Defs instance].isMusicMute = NO;
        [MyData setStoreValue:@"isSoundMute" value:@"NO"];
        [MyData setStoreValue:@"isMusicMute" value:@"NO"];
    }
    
    [Defs instance].isPlayGameBefore = [[MyData getStoreValue:@"isPlayGameBefore"] boolValue];
	
    [Defs instance].currentMusicTheme = 0;
    
    [Defs instance].isMusicMute = YES;
    
	[[GameStandartFunctions instance] playCurrentBackgroundMusicTrack];
	
    // Init area
	[Defs instance].actorManager = [[ActorManager alloc] init];
	
	gui = [GUIInterface batchNodeWithFile: @"gfx_gui.png" capacity: 100];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gfx_gui.plist" texture:gui.texture];
    
	aboutScreen = [AboutScreen node];
	menu = [ZMenu node];
	marketScreen = [MarketScreen node];
	game = [ZGame node];
	pauseScreen = [PauseScreen node];
    levelFinishScreen = [LevelFinishScreen node];
	
	[self addChild:aboutScreen];
	[self addChild:menu];
	[self addChild:game];
    //[game addChild:[Defs instance].objectBackLayer];
    [game addChild:[Defs instance].objectFrontLayer];
    [[Defs instance].objectFrontLayer addChild:[Defs instance].spriteSheetCells z:0];
    [[Defs instance].objectFrontLayer addChild:[Defs instance].spriteSheetChars z:100];
    [self addChild:levelFinishScreen];
	[self addChild:pauseScreen];
    [self addChild:marketScreen];
	[self addChild:gui];
    
    // load area
    [pauseScreen load];
	
	[[[CCDirector sharedDirector] touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
	
	//[_progress removeFromParentAndCleanup:YES];
	
	//[[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
	
	[self showMenu];
}

-(void) dealloc
{
	[super dealloc];
}

-(void) update:(ccTime)dt{
	[gui update];
	
	if ((game.state	& (GAME_STATE_GAME|GAME_STATE_GAMEPAUSE|GAME_STATE_LEVELFINISH)) != 0){
		[game update];
	}
    
    if ((game.state & (GAME_STATE_GAMEPAUSE))!= 0) {
        [pauseScreen update];
    }
    
    if ((game.state & GAME_STATE_LEVELFINISH) != 0) [levelFinishScreen update];
	
	if (game.state == GAME_STATE_MENU) {
		[menu update];
	}
    
    if (game.state == GAME_STATE_MARKETSCREEN) {
		[marketScreen update];
	}
    
    if (game.state == GAME_STATE_CREDITS) {
		[aboutScreen update];
	}
}

- (void) showCredits{
	game.state = GAME_STATE_CREDITS;
	[gui show:game.state];
	[game show:NO];
	[menu show:NO];
	[aboutScreen show:YES];
	self.accelerometerEnabled = NO;
    [FlurryAnalytics logEvent:ANALYTICS_CREITS_SCREEN_OPENED];
}

- (void) showMoreGamesScreen {
    game.state = GAME_STATE_MOREGAMES;
    [gui showOnly:game.state];
    [game show:NO];
    [menu show:NO];
    [aboutScreen show:NO];
    self.accelerometerEnabled = NO;
    [FlurryAnalytics logEvent:ANALYTICS_MOREGAMES_SCREEN_OPENED];
}


- (void) showMenu{
	game.state = GAME_STATE_MENU;
	[gui show:game.state];
    [aboutScreen show:NO];
	[game show:NO];
	[menu show:YES];
	self.accelerometerEnabled = YES;
    
    if ([Defs instance].currentMusicTheme != 0) {
        [Defs instance].currentMusicTheme = 0;
        [[GameStandartFunctions instance] playCurrentBackgroundMusicTrack];
    }
    
    [FlurryAnalytics logEvent:ANALYTICS_MAIN_MENU_SCREEN_OPENED];
}

- (void) showMarketScreen:(int)_state {
    game.oldState = _state;
	game.state = GAME_STATE_MARKETSCREEN;
	[gui show:game.state];
	//[game show:NO];
	[menu show:NO];
	[marketScreen show:YES];
	self.accelerometerEnabled = NO;
    [FlurryAnalytics logEvent:ANALYTICS_MARKET_SCREEN_OPENED];
}

- (void) showGamePause{
	game.state = GAME_STATE_GAMEPAUSE;
	[gui show:game.state];
	//[game show:NO];
    [marketScreen show:NO];
	[pauseScreen show:YES];
}

- (void) showLevelDinishScreenAndSetScore:(BOOL)_flag
                                   _score:(int)_score
                               _starCount:(int)_starScore {
    if (_score < 0) _score = 0;
    [levelFinishScreen setScore:_score];
	[levelFinishScreen show:_flag];
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	if (game.state == GAME_STATE_MENU) {
		[menu accelerometer:accelerometer didAccelerate:acceleration];
	} else
        if (game.state == GAME_STATE_GAME) {
            //[game accelerometer:accelerometer didAccelerate:acceleration];
        }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	
	if (![gui touchReaction:convertedLocation]) {
        
        if ((game.state & (GAME_STATE_GAME|GAME_STATE_GAMEPAUSE)) != 0) {
            return [game ccTouchBegan:convertedLocation];
        }
	}
    
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
    
	[gui ccTouchEnded:convertedLocation];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    //CGPoint location = [touch locationInView: [touch view]];
	//CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
} 

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];
	
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	prevLocation = [[CCDirector sharedDirector] convertToGL: prevLocation];
	
	CGPoint diff = ccpSub(touchLocation,prevLocation);
	
	[gui ccTouchMoved:touchLocation _prevLocation:prevLocation _diff:diff];
    
    if (game.state == GAME_STATE_MENU) {
        //[menu ccTouchMoved:touchLocation _prevLocation:prevLocation _diff:diff];
    }
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end