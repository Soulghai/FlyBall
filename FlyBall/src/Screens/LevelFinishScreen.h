//
//  LevelFinishScreen.h
//  Expand_It
//
//  Created by Mac Mini on 21.03.11.
//  Copyright 2011 JoyPeople. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIPanel.h"
#import "GUILabelTTFOutlined.h"

@interface LevelFinishScreen : CCNode {
	BOOL isVisible;
    
	GUILabelTTFOutlined* levelNumber;
	GUILabelTTFOutlined* scoreStr;
    CGPoint scoreStrPos;
    int scoreValue;
    float scoreCurrValue;
    float scoreCurrValueKoeff;
    float scoreCurrValueAddDelay;
    float waitAddScoreTime;
    float waitAddScoreDelay;    
    float soundScoreDelay;
    float soundScoreTime;
    float timeCoinsAdd;
    float delayCoinsAdd;
    
    CGPoint scoreTotalStrPos;
    int scoreTotalCurrValue;
    
    GUIPanel *panelImproved;
    BOOL isPanelImprovedShowing;
    float panelImprovedGrowSpeed;
    float panelImprovedGrowSpeedAcc;
    
    GUIPanel *panelHighlight;
    GUIPanel *panelBushRight;
    GUIPanel *panelBushLeft;
    GUIPanel *panelPalmRight;
    GUIPanel *panelPalmLeft;
    
    BOOL isBushGoUp;
    BOOL isBushLeftGoUp;
    BOOL isPalmGoUp;
    BOOL isPalmLeftGoUp;
}

- (id) init;
- (void) setScore:(int) _value;
- (void) showPanelImproved:(BOOL)_flag;
- (void) show:(BOOL)_flag;
- (void) update;
- (void) dealloc;
@end
