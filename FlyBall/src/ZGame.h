//
//  game.h
//  Beltality
//
//  Created by Mac Mini on 30.10.10.
//  Copyright 2010 JoyPeople. All rights reserved.
//

#import "cocos2d.h"
#import "LevelFinishScreen.h"
#import "GUILabelTTF.h"
#import "ActorPlayer.h"
#import "CellsBackground.h"
#import "SpeedWall.h"
#import "ActorActiveBombObject.h"
#import "ParalaxBackground.h"

@interface ZGame : CCNode {	
	BOOL isVisible;
	
	BOOL isPause;
	
	int scoreLevel;
	
	float levelTime;
    
    GUILabelTTF *scoreStr;
    CGPoint scoreStrPos;
    BOOL isNewScoreSound;
    
    float timerAddBall;
    float timerDelayAddBall;
    
    GUILabelTTF *labelScoreStr1;
    GUILabelTTF *labelScoreStr2;
    GUILabelTTF *labelScoreStr3;
    
    CellsBackground *cells;
    ParalaxBackground* paralaxBackground;
    SpeedWall *speedWall;
    
    int collectedCoins;
}

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int oldState;
@property (nonatomic, retain) ActorPlayer *player;

// button actions
- (void) buttonPauseAction;
- (void) buttonLevelRestartAction;
- (void) retartGameProcess;

- (id) init;
- (void) update;
- (void) setPause:(BOOL)_flag;
- (void) levelStart;
- (void) levelRestart;
- (void) prepareToHideGameScreen;
- (void) bombExplosion:(ActorActiveBombObject*)_tempActor;
- (void) doBonusEffect:(int)_bonusID;
- (void) bonusTouchReaction:(int)_bonusID;
- (BOOL) ccTouchBegan:(CGPoint)_touchPos;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) show:(BOOL)_flag;
- (void) dealloc;
@end
