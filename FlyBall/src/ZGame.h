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
#import "GUILabelTTFOutlined.h"
#import "ActorCircle.h"
#import "CellsBackground.h"

@interface ZGame : CCNode {	
	BOOL isVisible;
	
	BOOL isPause;
	
	int scoreLevel;
	
	float levelTime;
    
    GUILabelTTFOutlined *scoreStr;
    CGPoint scoreStrPos;
    
    ActorCircle *player;
    float timerAddBall;
    float timerDelayAddBall;
    
    GUILabelTTF *labelScoreStr1;
    GUILabelTTF *labelScoreStr2;
    GUILabelTTF *labelScoreStr3;
    
    CellsBackground *cells;
}

@property (nonatomic, assign) int state;
@property (nonatomic, assign) int oldState;

// button actions
- (void) buttonPauseAction;
- (void) buttonLevelRestartAction;

- (id) init;
- (void) update;
- (void) setPause:(BOOL)_flag;
- (void) levelStart;
- (void) levelRestart;
- (void) prepareToHideGameScreen;
- (void) bonusTouchReaction:(int)_bonusID;
- (BOOL) ccTouchBegan:(CGPoint)_touchPos;
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration;
- (void) show:(BOOL)_flag;
- (void) dealloc;
@end
