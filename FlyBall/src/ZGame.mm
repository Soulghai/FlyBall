//
//  game.m
//  Beltality
//
//  Created by Mac Mini on 30.10.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "cocos2d.h"
#import "MainScene.h"
#import "Defs.h"
#import "globalParam.h"
#import "Utils.h"
#import "SimpleAudioEngine.h"
#import "ActorPlayer.h"
#import "MKStoreManager.h"
#import "GUIPanelDef.h"
#import "GameStandartFunctions.h"
#import "GUILabelTTFDef.h"
#import "GUILabelTTFOutlinedDef.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"
#import "MyData.h"
#import "ActorCircleBomb.h"
#import "ActorCircleBonus.h"
#import "CellsBackground.h"
#import "SpeedWall.h"

@implementation ZGame

@synthesize state;
@synthesize oldState;
@synthesize player;

- (void) levelFinishCloseAnimationStart {
    [[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonLevelRestartAction {
	[self levelRestart];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_RESTART_LEVEL_CLICKED];
}

- (void) buttonPauseAction {
    [self setPause:!isPause];
}

-(void) retartGameProcess {
    [Defs instance].bestScore = 0;
    [Defs instance].coinsCount = 0;
    
    //--------------------------------------
    // То, что можно прокачать
    //--------------------------------------
    [Defs instance].bonusAccelerationPower = BONUS_ACCELERATION_POWER_DEFAULT;
    [Defs instance].bonusAccelerationPowerLevel = 0;
    [Defs instance].bonusAccelerationDelay = BONUS_ACCELERATION_DELAY_DEFAULT;
    [Defs instance].bonusAccelerationDelayLevel = 0;
    [Defs instance].bonusGetChance = BONUS_GET_CHANCE_DEFAULT;
    [Defs instance].bonusGetChanceLevel = 0;
    [Defs instance].bonusGodModeTime = BONUS_GODMODE_TIME_DEFAULT;
    [Defs instance].bonusGodModeTimeLevel = 0;
    [Defs instance].gravitation = GRAVITATION_DEFAULT;
    [Defs instance].gravitationLevel = 0;
    [Defs instance].speedWallAccelerationCoeff = SPEEDWALL_ACCELERATION_DEFAULT;
    [Defs instance].speedWallAccelerationCoeffLevel = 0;
    [Defs instance].speedWallDeccelerationCoeff = SPEEDWALL_DECCELERARION_DEFAULT;
    [Defs instance].speedWallDeccelerationCoeffLevel = 0;
    [Defs instance].speedWallDelayShowingCoeff = SPEEDWALL_DELAYSHOWINGCOEFF_DEFAULT;
    [Defs instance].speedWallDelayShowingCoeffLevel = 0;
    [Defs instance].playerMagnetDistance = PLAYER_MAGNET_DISTANDE_DEFAULT;
    [Defs instance].playerMagnetDistanceLevel = 0;
    [Defs instance].playerMagnetPower = PLAYER_MAGNET_POWER_DEFAULT;
    [Defs instance].playerMagnetPowerLevel = 0;
    [Defs instance].playerGodModeAfterCrashTime = GODMODE_AFTERCRASH_TIME_DEFAULT;
    [Defs instance].playerGodModeAfterCrashTimeLevel = 0;
    
    [MyData setStoreValue:@"coinsCount" value:@"0"];
    [MyData setStoreValue:@"bestScore" value:@"0"];
    
    [MyData setStoreValue:@"bonusAccelerationPower" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationPower]];
    [MyData setStoreValue:@"bonusAccelerationPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationPowerLevel]];
    [MyData setStoreValue:@"bonusAccelerationDelay" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationDelay]];
    [MyData setStoreValue:@"bonusAccelerationDelayLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationDelayLevel]];
    [MyData setStoreValue:@"bonusGetChance" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGetChance]];
    [MyData setStoreValue:@"bonusGetChanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGetChanceLevel]];
    [MyData setStoreValue:@"bonusGodModeTime" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGodModeTime]];
    [MyData setStoreValue:@"bonusGodModeTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGodModeTimeLevel]];
    [MyData setStoreValue:@"gravitation" value:[NSString stringWithFormat:@"%f",[Defs instance].gravitation]];
    [MyData setStoreValue:@"gravitationLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].gravitationLevel]];
    [MyData setStoreValue:@"speedWallAccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallAccelerationCoeff]];
    [MyData setStoreValue:@"speedWallAccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallAccelerationCoeffLevel]];
    [MyData setStoreValue:@"speedWallDeccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallDeccelerationCoeff]];
    [MyData setStoreValue:@"speedWallDeccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallDeccelerationCoeffLevel]];
    [MyData setStoreValue:@"speedWallDelayShowingCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallDelayShowingCoeff]];
    [MyData setStoreValue:@"speedWallDelayShowingCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallDelayShowingCoeffLevel]];
    [MyData setStoreValue:@"playerMagnetDistance" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistance]];
    [MyData setStoreValue:@"playerMagnetDistanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistanceLevel]];
    [MyData setStoreValue:@"playerMagnetPower" value:[NSString stringWithFormat:@"%f",[Defs instance].playerMagnetPower]];
    [MyData setStoreValue:@"playerMagnetPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetPowerLevel]];
    [MyData setStoreValue:@"playerGodModeAfterCrashTime" value:[NSString stringWithFormat:@"%f",[Defs instance].playerGodModeAfterCrashTime]];
    [MyData setStoreValue:@"playerGodModeAfterCrashTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerGodModeAfterCrashTimeLevel]];
    
    [MyData encodeDict:[MyData getDictForSaveData]];
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
		
		isPause = NO;
        
        [Defs instance].prices = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
                                  [NSNumber numberWithInt:10],
                                  [NSNumber numberWithInt:20],
                                  [NSNumber numberWithInt:30],
                                  [NSNumber numberWithInt:40], nil];
        
		[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        //[Defs instance].startGameNotFirstTime = NO;
        
        if (![Defs instance].startGameNotFirstTime) {
            [Defs instance].gameSessionCounter = 0;
            [Defs instance].rateMeWindowShowValue = 0;
            [Defs instance].totalTouchBloxCounter = 0;
            [Defs instance].totalDeadBloxCounter = 0;
            [Defs instance].totalBombCounter = 0;
            
            [self retartGameProcess];
        } else {
            [Defs instance].gameSessionCounter = [[MyData getStoreValue:@"gameSessionCounter"] intValue];
            [Defs instance].rateMeWindowShowValue = [[MyData getStoreValue:@"rateMeWindowShowValue"] intValue];
            [Defs instance].coinsCount = [[MyData getStoreValue:@"coinsCount"] intValue];
            [Defs instance].bestScore = [[MyData getStoreValue:@"bestScore"] intValue];
            [Defs instance].totalTouchBloxCounter = [[MyData getStoreValue:@"totalTouchBloxCounter"] intValue];
            [Defs instance].totalDeadBloxCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
            [Defs instance].totalBombCounter = [[MyData getStoreValue:@"totalDeadBloxCounter"] intValue];
            
            [Defs instance].bonusAccelerationPower = [[MyData getStoreValue:@"bonusAccelerationPower"] floatValue];
            [Defs instance].bonusAccelerationPowerLevel  = [[MyData getStoreValue:@"bonusAccelerationPowerLevel"] intValue];
            [Defs instance].bonusAccelerationDelay = [[MyData getStoreValue:@"bonusAccelerationDelay"] floatValue];
            [Defs instance].bonusAccelerationDelayLevel  = [[MyData getStoreValue:@"bonusAccelerationDelayLevel"] intValue];
            [Defs instance].bonusGetChance = [[MyData getStoreValue:@"bonusGetChance"] floatValue];
            [Defs instance].bonusGetChanceLevel  = [[MyData getStoreValue:@"bonusGetChanceLevel"] intValue];
            [Defs instance].bonusGodModeTime = [[MyData getStoreValue:@"bonusGodModeTime"] floatValue];
            [Defs instance].bonusGodModeTimeLevel  = [[MyData getStoreValue:@"bonusGodModeTimeLevel"] intValue];
            [Defs instance].gravitation = [[MyData getStoreValue:@"gravitation"] floatValue];
            [Defs instance].gravitationLevel  = [[MyData getStoreValue:@"gravitationLevel"] intValue];
            [Defs instance].speedWallAccelerationCoeff = [[MyData getStoreValue:@"speedWallAccelerationCoeff"] floatValue];
            [Defs instance].speedWallAccelerationCoeffLevel  = [[MyData getStoreValue:@"speedWallAccelerationCoeffLevel"] intValue];
            [Defs instance].speedWallDeccelerationCoeff = [[MyData getStoreValue:@"speedWallDeccelerationCoeff"] floatValue];
            [Defs instance].speedWallDeccelerationCoeffLevel  = [[MyData getStoreValue:@"speedWallDeccelerationCoeffLevel"] intValue];
            [Defs instance].speedWallDelayShowingCoeff = [[MyData getStoreValue:@"speedWallDelayShowingCoeff"] floatValue];
            [Defs instance].speedWallDelayShowingCoeffLevel  = [[MyData getStoreValue:@"speedWallDelayShowingCoeffLevel"] intValue];
            [Defs instance].playerMagnetDistance = [[MyData getStoreValue:@"playerMagnetDistance"] intValue];
            [Defs instance].playerMagnetDistanceLevel  = [[MyData getStoreValue:@"playerMagnetDistanceLevel"] intValue];
            [Defs instance].playerMagnetPower = [[MyData getStoreValue:@"playerMagnetPower"] floatValue];
            [Defs instance].playerMagnetPowerLevel  = [[MyData getStoreValue:@"playerMagnetPowerLevel"] intValue];
            [Defs instance].playerGodModeAfterCrashTime = [[MyData getStoreValue:@"playerGodModeAfterCrashTime"] floatValue];
            [Defs instance].playerGodModeAfterCrashTimeLevel  = [[MyData getStoreValue:@"playerGodModeAfterCrashTimeLevel"] intValue];
        }
        
        //[self retartGameProcess];
        
        
        [Defs instance].coinsCount = 1000;
        //[Defs instance].bonusAccelerationPower = BONUS_ACCELERATION_POWER_DEFAULT;
        //[Defs instance].bonusAccelerationPowerLevel = 0;
        //[Defs instance].bonusAccelerationDelay = BONUS_ACCELERATION_DELAY_DEFAULT;
        //[Defs instance].bonusAccelerationDelayLevel = 0;
        //[Defs instance].bonusGetChance = BONUS_GET_CHANCE_DEFAULT;
        //[Defs instance].bonusGodModeTime = BONUS_GODMODE_TIME_DEFAULT;
        //[Defs instance].gravitation = GRAVITATION_DEFAULT;
        //[Defs instance].speedWallAccelerationCoeff = SPEEDWALL_ACCELERATION_DEFAULT;
        //[Defs instance].speedWallDeccelerationCoeff = SPEEDWALL_DECCELERARION_DEFAULT;
        //[Defs instance].speedWallDelayShowingCoeff = SPEEDWALL_DELAYSHOWINGCOEFF_DEFAULT;
        //[Defs instance].playerMagnetDistance = PLAYER_MAGNET_DISTANDE_DEFAULT;
        //[Defs instance].playerMagnetPower = PLAYER_MAGNET_POWER_DEFAULT;
        //[Defs instance].playerGodModeAfterCrashTime = BONUS_GODMODE_AFTERCRASH_TIME_DEFAULT;
		
        if (![Defs instance].isSoundMute) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"level_win.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"button_click.wav"]; 
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"star.wav"]; 
        }
            
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnPause.png";
		btnDef.sprDownName = @"btnPauseDown.png";
		btnDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPREPARE;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonPauseAction);
		btnDef.sound = @"button_click.wav";
		if ([Defs instance].iPhone5) {
            GUIButton *_btn = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 30)];
            [_btn.spr setScale:1.3f];
            _btn = nil;
        } else
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 20,SCREEN_HEIGHT-20)];    
		
		btnDef.sprName = @"btnRestart.png";
		btnDef.sprDownName = @"btnRestartDown.png";
		btnDef.group = GAME_STATE_GAMEPAUSE;
		btnDef.func = @selector(buttonLevelRestartAction);
        btnDef.isManyTouches = YES;
		if ([Defs instance].iPhone5) {
            GUIButton *_btnRestart = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, 30)];
            [_btnRestart.spr setScale:1.f];
            _btnRestart = nil;
        } else {
            GUIButton *_btnRestart = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(20,SCREEN_HEIGHT-20)];
            [_btnRestart.spr setScale:0.7f];
            _btnRestart = nil;
        }
        
        GUILabelTTFDef *_labelTTFDef = [GUILabelTTFDef node];
        _labelTTFDef.group = GAME_STATE_GAME|GAME_STATE_GAMEPREPARE|GAME_STATE_GAMEPAUSE;
        _labelTTFDef.text = @"0";
        scoreStrPos = ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT - 20);
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        scoreStr =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:scoreStrPos];
        
        _labelTTFDef.alignement = kCCTextAlignmentLeft;
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        _labelTTFDef.text = @"";
        labelScoreStr1 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1, SCREEN_HEIGHT_HALF - SCREEN_HEIGHT_HALF/1.5f)];
        
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        _labelTTFDef.text = @"0";
        labelScoreStr2 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1, SCREEN_HEIGHT_HALF)];
        
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        _labelTTFDef.text = @"160";
        labelScoreStr3 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(1,SCREEN_HEIGHT_HALF + SCREEN_HEIGHT_HALF/1.5f)];
        
        // hint for start game
        _labelTTFDef.group = GAME_STATE_GAMEPREPARE;
        _labelTTFDef.alignement = kCCTextAlignmentCenter;
        _labelTTFDef.textColor = ccc3(255, 255, 255);
        _labelTTFDef.text = NSLocalizedString(@"HINT:Tap to Bomb","");
        labelScoreStr3 =[[MainScene instance].gui addItem:(id)_labelTTFDef _pos:ccp(SCREEN_WIDTH_HALF, 100)];
        
        cells = [[CellsBackground alloc] init];
        [cells retain];
        
        player = [[ActorPlayer alloc] init:[Defs instance].spriteSheetChars _location:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF)];
        
        for (int i = 0; i < 15; i++)
        [[ActorCircleBomb alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        for (int i = 0; i < 10; i++)
            [[ActorCircleBonus alloc] init:[Defs instance].spriteSheetChars _location:CGPointZero];
        
        speedWall = [[SpeedWall alloc] init:[Defs instance].spriteSheetCells];
        [speedWall retain];
	}
	return (self);
}

- (void) deactivateAllActors {
	Actor *_a;
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        [_a deactivate];
    }
}

- (void) setCenterOfTheScreen:(CGPoint)_position {
    int x = MAX(_position.x, INTMAX_MIN);
    int y = MAX(_position.y, SCREEN_HEIGHT_HALF);
    
    x = MIN(x, INTMAX_MAX);
    y = MIN(y, INTMAX_MAX);
    
    [Defs instance].objectFrontLayer.position = ccpSub(ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF), ccp(x,y));
}

- (void) prepareToHideGameScreen {
    [self setCenterOfTheScreen:ccp(SCREEN_WIDTH_HALF, 0)];
	[self show:NO];
	//[self deactivateAllActors];
	GAME_IS_PLAYING = NO;
}

- (void) addBall:(CGPoint)_point
       _velocity:(CGPoint)_velocity
         _active:(BOOL)_active{
    
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    Actor *_a;
    ActorCircleBomb *_circleBombActor = nil;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        if (([_a isMemberOfClass:[ActorCircleBomb class]])&&(_a.isActive == NO)) {
            _circleBombActor = (ActorCircleBomb*)_a;
            break;
        }
    }
    
    if (_circleBombActor != nil)
        [_circleBombActor addToField:_point _velocity:_velocity];
    else {
        _circleBombActor = [[ActorCircleBomb alloc] init:[Defs instance].spriteSheetChars _location:_point];
        CCLOG(@"CREATE NEW BOMB");
    }

    
    _circleBombActor.isActive = _active;
    [_circleBombActor show:_active];
}

- (void) addBonus:(CGPoint)_point
       _velocity:(CGPoint)_velocity
         _active:(BOOL)_active{
    
    int _cnt = [Defs instance].actorManager.actorsAll.count;
    Actor *_a;
    ActorCircleBonus *_circleBombBonus = nil;
    for (int i = 0; i < _cnt; i++) {
        _a = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
        if (([_a isMemberOfClass:[ActorCircleBonus class]])&&(_a.isActive == NO)) {
            _circleBombBonus = (ActorCircleBonus*)_a;
            break;
        }
    }
    
    if (_circleBombBonus != nil)
        [_circleBombBonus addToField:_point _velocity:_velocity];
    else {
        _circleBombBonus = [[ActorCircleBonus alloc] init:[Defs instance].spriteSheetChars _location:_point];
        CCLOG(@"CREATE NEW BONUS");
    }
    if (_active) [_circleBombBonus setRandomBonus];
    
    _circleBombBonus.isActive = _active;
    [_circleBombBonus show:_active];
}

- (void) levelStart{
	GAME_STARTED = YES;
    isPause = NO;
	
	levelTime = 0;
	
	scoreLevel = 0;
    [scoreStr setColor:ccc3(255, 255, 255)];
    isNewScoreSound = NO;
    
    GAME_IS_PLAYING = NO;
    state = GAME_STATE_GAMEPREPARE;
    [[MainScene instance].gui show:state];
    
    [self deactivateAllActors];
    
    [player activate];
    [player addVelocity:ccp(0,1)];
    [self setCenterOfTheScreen:player.position];
    
    [self addBall:ccp(player.position.x, player.position.y - 70) _velocity:ccp(0,0) _active:YES];
    
    timerAddBall = 0.2f;
    timerDelayAddBall = 0.4f;
    
    [cells restartParameters];
    [speedWall deactivate];
    
    [self show:YES];
    
    ++[Defs instance].gameSessionCounter;
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_START];
}

- (void) startGameSession {
    GAME_IS_PLAYING = YES;
    state = GAME_STATE_GAME;
    [[MainScene instance].gui show:state];
}

- (void) levelRestart {
    [[GameStandartFunctions instance] hideScreenAnimation];
    [self levelStart];
}

- (void) setPause:(BOOL)_flag{
	isPause = _flag;
	[[MainScene instance].pauseScreen show:isPause];
	  
    if (isPause) {
        oldState = state;
		state = GAME_STATE_GAMEPAUSE;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_ON_CLICKED];
	} else {
		state = oldState;
        [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_PAUSE_OFF_CLICKED];
	}
	
	[[MainScene instance].gui show:state];
}

- (void) getAchievements {
}

- (void) levelFinishAction {
	if (state == GAME_STATE_LEVELFINISH) return;
    
	state = GAME_STATE_LEVELFINISH;
    [[MainScene instance].gui show:state];
    
    [FlurryAnalytics logEvent:ANALYTICS_GAME_LEVEL_FINISH];
    
    [self deactivateAllActors];
    
    // get Achievement
    [self getAchievements];
	
	GAME_IS_PLAYING = NO;
    
	if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"level_win.wav"]; 	
    
	[self prepareToHideGameScreen];
	
    [self show:NO];
    
    //[Defs instance].bestScore = 0;
    
    [[MainScene instance] showLevelFinishScreenAndSetScore:YES _score:scoreLevel _starCount:3];
    
    [MyData encodeDict:[MyData getDictForSaveData]];
}

- (void) labelScoreBarUpdate {
    [labelScoreStr1 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y - SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    [labelScoreStr2 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y) % SCREEN_HEIGHT)];
    [labelScoreStr3 setPosition:ccp(1, SCREEN_HEIGHT-(int)(player.position.y + SCREEN_HEIGHT_HALF/1.5f) % SCREEN_HEIGHT)];
    
    NSString *_strScoreValue;
    float _scoreValue = (int)(player.position.y + (labelScoreStr1.spr.position.y - SCREEN_HEIGHT));
        if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue >= 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.position.y  + (labelScoreStr1.spr.position.y - SCREEN_HEIGHT))];
            }
        }
    [labelScoreStr1 setText:_strScoreValue];
        
    
    _scoreValue = (int)(player.position.y + (labelScoreStr2.spr.position.y - SCREEN_HEIGHT));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue >= 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.position.y + (labelScoreStr2.spr.position.y - SCREEN_HEIGHT))];
            }
    }
    [labelScoreStr2 setText:_strScoreValue];
    
    _scoreValue = (int)(player.position.y + (labelScoreStr3.spr.position.y - SCREEN_HEIGHT));
    if (_scoreValue < 0) _strScoreValue = @""; else {
        if (_scoreValue >= 10000) {
            _strScoreValue = [NSString stringWithFormat:@"%3iK", (int)(_scoreValue/1000)];
        } else
            if (_scoreValue >= 1000) {
                _strScoreValue = [NSString stringWithFormat:@"%2.1fK", (float)(_scoreValue/1000)];
            } else {
                _strScoreValue = [NSString stringWithFormat:@"%i",(int)(player.position.y + (labelScoreStr3.spr.position.y - SCREEN_HEIGHT))];
            }
    }
    [labelScoreStr3 setText:_strScoreValue];
}

- (void) bombExplosion:(ActorActiveBombObject*)_tempActor {
    float _tempActorX = _tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x;
    float _tempActorY = _tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y;
    
    float _distance = [[Utils instance] distance:SCREEN_WIDTH_HALF _y1:SCREEN_HEIGHT_HALF _x2:_tempActorX _y2:_tempActorY];
    if (_distance < elementSize) _distance = elementSize;
    
    float _power = (1 - _distance/SCREEN_HEIGHT_HALF)*10.0f;
    
    float _angle = CC_DEGREES_TO_RADIANS([Utils GetAngleBetweenPt1:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF) andPt2:ccp(_tempActorX,_tempActorY)]);
    
    [player addVelocity:ccp(_power*cos(_angle),_power*sin(_angle))];
}

- (void) doBonusEffect:(int)_bonusID {
    switch (_bonusID) {
        case BONUS_ARMOR:

            break;
            
        case BONUS_ACCELERATION:

            break;
            
        case BONUS_APOCALYPSE: {
            Actor* _tempActor;
            int _count = [[Defs instance].actorManager.actorsAll count];
            for (int i = 0; i < _count; i++) {
                _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)) {
                    if (([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])){
                        [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                        [_tempActor touch];
                    }
                }
            }
        }
            break;
            
        case BONUS_GODMODE:

            break;
    }
}

- (void) bonusTouchReaction:(int)_bonusID {
    if (_bonusID <= BONUS_ARMOR) {
        // Включаем броню
        [player addArmor];
    } else
        if (_bonusID <= BONUS_ACCELERATION) {
            // Ускорение
            [player setSpeedBonus:[Defs instance].bonusAccelerationDelay];
        } else
            if (_bonusID <= BONUS_APOCALYPSE) {
                // Апокалипсис
                [player setBonusCell:BONUS_APOCALYPSE];
            } else
                if (_bonusID <= BONUS_GODMODE) {
                    // устанавливаем режим бога
                    [player setGodMode:[Defs instance].bonusGodModeTime];
                }
}

- (BOOL) checkIsOutOfScreen:(Actor*)_tempActor {
    if ((_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x <= -elementRadius)
        ||(_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x >= SCREEN_WIDTH+  elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y <= -elementRadius)
        ||(_tempActor.costume.position.y + [Defs instance].objectFrontLayer.position.y >= SCREEN_HEIGHT+elementRadius)) return YES;
    return NO;
}

- (void) update {
    if (state != GAME_STATE_LEVELFINISH) {
        // Пока делаем затемнение или наоборот, ф-цию update не выполняем
    if (([Defs instance].closeAnimationPanel) && ([Defs instance].isOpenScreenAnimation)) {
        if ([Defs instance].closeAnimationPanel.spr.opacity >= 25) [Defs instance].closeAnimationPanel.spr.opacity -= 25; else {
            [[Defs instance].closeAnimationPanel.spr setOpacity:0];
            [[Defs instance].closeAnimationPanel show:NO];
            [Defs instance].isOpenScreenAnimation = NO;
            return;
        }
    } else 
        if ([Defs instance].isCloseScreenAnimation) {
            if ([Defs instance].closeAnimationPanel.spr.opacity <= 225) [Defs instance].closeAnimationPanel.spr.opacity += 25; else {
                [Defs instance].isCloseScreenAnimation = NO;
                [[Defs instance].closeAnimationPanel.spr setOpacity:255];
                if ([Defs instance].afterCloseAnimationScreenType == 0) {
                    [self levelFinishAction];
                }
            }
            return;
        }
    }
	
	if ((GAME_IS_PLAYING)&&((state & (GAME_STATE_GAMEPAUSE)) == 0)) {
		
		levelTime += TIME_STEP;
        
        if (player.position.y < SCREEN_HEIGHT_HALF) {
            [self levelFinishCloseAnimationStart];
            return;
        }
        
        Actor *_tempActor;
        float _distanceToActor;
        float _minDistance = elementSize;
        int _count = [[Defs instance].actorManager.actorsAll count];
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)&&([_tempActor isKindOfClass:[ActorActiveObject class]])
                &&(![self checkIsOutOfScreen:_tempActor])) {
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.position.x _y2:player.position.y];
                if (_distanceToActor < _minDistance) {
                    if ([_tempActor isKindOfClass:[ActorActiveBombObject class]]) [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                    [(ActorActiveObject*)_tempActor touch];
                    if (player.velocity.y > - elementSize) {
                        if ([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                        {
                            [player eraserCollide];
                            if (!player.isActive) {
                                [self levelFinishCloseAnimationStart];
                                return;
                            }
                            break;
                        }
                    }
                }
            }
        }
        
        // Удаляем сильно отдалившиеся объекты
        _minDistance = 500;
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&(player.itemID != _tempActor.itemID)&&([_tempActor isKindOfClass:[ActorActiveObject class]])) {
                _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x _y1:_tempActor.costume.position.y _x2:player.position.x _y2:player.position.y];
                if (_distanceToActor > _minDistance) {
                    [(ActorActiveObject*)_tempActor deactivate];
                }
            }
        }
        
        // действуем магнитом на бонусы
        for (int i = 0; i < _count; i++) {
            _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
            if ((_tempActor.isActive)&&([_tempActor isMemberOfClass:[ActorCircleBonus class]])
                /*&&(![self checkIsOutOfScreen:_tempActor])*/) {
                _tempActor.costume.position = ccpAdd(_tempActor.costume.position, [player magnetReaction:_tempActor.costume.position]);
            }
        }
        
        [self labelScoreBarUpdate];
        
        timerAddBall += TIME_STEP;
        if (timerAddBall >= timerDelayAddBall - (player.position.y/4000000)) {
            float _playerVelocityX = player.velocity.x;
            float _playerVelocityY = player.velocity.y;
            if (player.isBonusSpeed) {
                _playerVelocityY -= [Defs instance].bonusAccelerationPowerLevel*2;
            }
            float _velocityXCoeff = 1 + fabsf(_playerVelocityX/10);
            float _velocityYCoeff = 1.f + (player.position.y/30000)+ CCRANDOM_0_1()*(player.position.y/120000);
            if (_velocityYCoeff < 4.5f) {
                _velocityYCoeff = 4.5f;
            }
            int _ballCount = round(CCRANDOM_0_1()*2);
            for (int i = 0; i < _ballCount; i++) {
                [self addBall:ccp(player.position.x + _playerVelocityX + SCREEN_WIDTH_HALF*CCRANDOM_MINUS1_1(), player.position.y - SCREEN_HEIGHT_HALF - elementRadius) _velocity:ccp(_playerVelocityX + CCRANDOM_MINUS1_1()*_velocityXCoeff, _playerVelocityY + _velocityYCoeff) _active:YES];
            }
            
            timerAddBall = 0;
        }
        
        if (scoreLevel < (int)(player.position.y - SCREEN_HEIGHT_HALF)) {
            scoreLevel = (int)(player.position.y - SCREEN_HEIGHT_HALF);
            [scoreStr setPosition:ccp(scoreStrPos.x + [[Utils instance] myRandom2F]*2, scoreStrPos.y + [[Utils instance] myRandom2F]*2)];
            
            if ((scoreLevel > [Defs instance].bestScore)&&([Defs instance].gameSessionCounter != 1)) {
                [scoreStr setColor:ccc3(50, 150, 255)];
                [scoreStr setText:[NSString stringWithFormat:@"Wooow %i !!!",scoreLevel]];
                if (!isNewScoreSound) {
                    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    isNewScoreSound = YES;
                }
            } else [scoreStr setText:[NSString stringWithFormat:@"%i",scoreLevel]];
        }
        
        [[Defs instance].actorManager update];
        [self setCenterOfTheScreen:player.position];
        
        // делаем апдейт относительно текущей позиции игрока
        [cells update];
        // стена скорости, которая действует на персонажа
        [speedWall update];
        player.velocity = ccpAdd(player.velocity, [speedWall checkToCollide:player.position]);
    }

}

- (void) show:(BOOL)_flag{
	if (isVisible != _flag) {
	
		isVisible = _flag;
	
		if (isVisible){
            [[GameStandartFunctions instance] playOpenScreenAnimation];
		}else {
            [speedWall show:NO];
		}
	}
    [cells show:_flag];
    [[Defs instance].actorManager show:_flag];
}

- (BOOL) ccTouchBegan:(CGPoint)_touchPos{
	if (!isPause) {
			
		if (state != GAME_STATE_LEVELFINISH) {
			if (GAME_IS_PLAYING) {
                
                Actor* _tempActor;
                float _distanceToActor = 0;
                //NSMutableArray *_actorArr = [NSMutableArray arrayWithCapacity:3];
                float _minDistance = 9999;
                int _actorWithMinDistanceID = -1;
                int _count = [[Defs instance].actorManager.actorsAll count];
                for (int i = 0; i < _count; i++) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                    if ((_tempActor.isActive)
                        &&([_tempActor isKindOfClass:[ActorActiveObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])) {
                        _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:_tempActor.costume.position.y+ [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                        if (_distanceToActor <= elementSize) {
                            if (_minDistance > _distanceToActor) {
                                _minDistance = _distanceToActor;
                                _actorWithMinDistanceID = i;
                            }
                        }
                    }
                }
                
                if (_actorWithMinDistanceID != -1) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:_actorWithMinDistanceID];
                    
                    if ([_tempActor isKindOfClass:[ActorActiveBombObject class]]) {
                        [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                        if (CCRANDOM_0_1() < [Defs instance].bonusGetChance) {
                            [self addBonus:_tempActor.costume.position _velocity:player.velocity _active:YES];
                        }
                    }
                    
                    [_tempActor touch];
                    
                    _tempActor = nil;
                    
                    return YES;
                }
                
			} else
            
            if (state == GAME_STATE_GAMEPREPARE) {
                
                Actor* _tempActor;
                float _distanceToActor = 0;
                int _actorWithMinDistanceID = -1;
                int _count = [[Defs instance].actorManager.actorsAll count];
                for (int i = 0; i < _count; i++) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:i];
                    if ((_tempActor.isActive)
                        &&([_tempActor isKindOfClass:[ActorActiveBombObject class]])
                        &&(![self checkIsOutOfScreen:_tempActor])) {
                        _distanceToActor = [[Utils instance] distance:_tempActor.costume.position.x + [Defs instance].objectFrontLayer.position.x _y1:_tempActor.costume.position.y+ [Defs instance].objectFrontLayer.position.y _x2:_touchPos.x _y2:_touchPos.y];
                        if (_distanceToActor <= elementSize) {
                            _actorWithMinDistanceID = i;
                            break;
                        }
                    }
                }
                
                if (_actorWithMinDistanceID != -1) {
                    _tempActor = [[Defs instance].actorManager.actorsAll objectAtIndex:_actorWithMinDistanceID];
                    [self bombExplosion:(ActorActiveBombObject*)_tempActor];
                    [_tempActor touch];
                    [self startGameSession];
                    
                    return YES;
                }
                
			}

		}
	}
	
	return NO;
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {

}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
