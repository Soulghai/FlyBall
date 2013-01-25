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
#import "HeightLabels.h"
#import "ActorCircleLaunchBomb.h"

@interface ZGame : CCNode {	
	BOOL isVisible;
	
	BOOL isPause;
	
	int scoreLevel;
	
	float levelTime;
    
    CCLabelBMFont *scoreStr;
    CGPoint scoreStrPos;
    BOOL isNewScoreSound;
    
    float timerAddBall;
    float timerDelayAddBall;
    
    /*GUILabelTTF *labelScoreStr1;
    GUILabelTTF *labelScoreStr2;
    GUILabelTTF *labelScoreStr3;*/
    
    GUIPanel* panelSlowMotionLeft;
    GUIPanel* panelSlowMotionRight;
    GUIPanel* panelSlowMotionTop;
    GUIPanel* panelSlowMotionBottom;
    
    //CellsBackground *cells;
    ParalaxBackground* paralaxBackground;
    HeightLabels* heightLabels;
    SpeedWall *speedWall;
    
    CCSprite *startPlatform;
    
    ActorCircleLaunchBomb* firstBomb;
    
    int collectedCoins;
    
    BOOL isSlowMotion;
    float timeSlowMotion;
    float delaySlowMotion;
    float timeSlowMotionPause;
    
    int panelBonusFadeSpeed;
}

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int oldState;
@property (nonatomic, retain) ActorPlayer *player;

// button actions
- (void) buttonPauseAction;
- (void) buttonLevelRestartAction;
- (void) retartGameProcess;

- (id) init;
- (void) update:(ccTime)dt;
- (void) setPause:(BOOL)_flag;
- (void) levelStart;
- (void) levelRestart;
- (void) prepareToHideGameScreen;
- (void) bombExplosion:(ActorActiveBombObject*)_tempActor;
- (void) bonusSlowMotionActivate:(float)_time
                      _timeScale:(float)_timeScale;
- (void) doBonusEffect:(int)_bonusID;
- (void) bonusTouchReaction:(int)_bonusID;
- (BOOL) ccTouchBegan:(CGPoint)_touchPos;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) show:(BOOL)_flag;
- (void) dealloc;
@end
