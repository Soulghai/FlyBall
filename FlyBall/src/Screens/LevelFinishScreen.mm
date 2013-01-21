//
//  LevelFinishScreen.m
//  Expand_It
//
//  Created by Mac Mini on 21.03.11.
//  Copyright 2011 JoyPeople. All rights reserved.
//

#import "LevelFinishScreen.h"
#import "MainScene.h"
#import	"globalParam.h"
#import "Defs.h"
#import "GUIButtonDef.h"
#import "SimpleAudioEngine.h"
#import "Utils.h"
#import "GUIPanelDef.h"
#import "GameStandartFunctions.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"
#import "MyData.h"
#import "GameCenter.h"

@implementation LevelFinishScreen

/*- (void) buttonLevelRestartClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:2];
    [FlurryAnalytics logEvent:ANALYTICS_LEVELEND_SCREEN_BUTTON_REPLAY_CLICKED];
}

- (void) buttonLevelRestartAction {
    [self show:NO];
    [[MainScene instance].game levelRestart];
        
    [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_RESTART_LEVEL_CLICKED];
}*/

- (void) buttonLevelsClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:1];
    [FlurryAnalytics logEvent:ANALYTICS_LEVELEND_SCREEN_BUTTON_REPLAY_CLICKED];
}

- (void) buttonLevelsAction {
    [self show:NO];
    [[MainScene instance] showMenu];
    [FlurryAnalytics logEvent:ANALYTICS_PAUSE_SCREEN_BUTTON_LEVELS_CLICKED];
}

- (void) buttonMarketAction {
	[[MainScene instance] showMarketScreen:GAME_STATE_LEVELFINISH];
    [FlurryAnalytics logEvent:ANALYTICS_PAUSE_SCREEN_BUTTON_MARKET_CLICKED];
}

- (void) checkAvailableUpdates {
    if ([[MainScene instance].marketScreen calcAvailableUpdatesCount] > 0) {
        //[labelMarketUpdateAvailableCounter setText:[NSString stringWithFormat:@"%i",_marketUpdateCounter]];
        //[labelMarketUpdateAvailableCounter show:YES];
        [panelExclamationMark show:YES];
    }
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_LEVELFINISH;
        _labelTTFOutlinedDef.text = [NSString stringWithFormat:@"%i", [Defs instance].coinsCount];
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 0);
        scoreTotalStrPos = ccp(SCREEN_WIDTH_HALF, 300);
        levelNumber =[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:scoreTotalStrPos];
        
        scoreStrPos = ccp(SCREEN_WIDTH_HALF, 240);
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 255);
        scoreStr =[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:scoreStrPos];
        
        collectedCoinsStrPos = ccp(SCREEN_WIDTH_HALF, 188);
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 0);
        collectedCoinsStr =[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:collectedCoinsStrPos];
		
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnBack.png";
		btnDef.sprDownName = @"btnBackDown.png";
		btnDef.group = GAME_STATE_LEVELFINISH;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonLevelsClick);
		btnDef.sound = @"button_click.wav";
        [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF-40,40)];
        
        /*btnDef.sprName = @"btnRestart.png";
		btnDef.sprDownName = @"btnRestartDown.png";
		btnDef.group = GAME_STATE_LEVELFINISH;
		btnDef.func = @selector(buttonLevelRestartClick);
        [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF+40,40)];*/
        
        btnDef.sprName = @"btnShop.png";
        btnDef.sprDownName = @"btnShopDown.png";
        btnDef.func = @selector(buttonMarketAction);
        
        GUIButton* _btnShop = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF - 75,100)];
        
        GUIPanelDef *panelDef = [GUIPanelDef node];
        
        panelDef.group = GAME_STATE_NONE;
        panelDef.parentFrame = _btnShop.spr;
        panelDef.sprName = @"exclamation_mark.png";
        panelExclamationMark = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(43, 43)];
        
        panelDef.parentFrame = [MainScene instance].gui;
        //panelDef.parentFrame = [Defs];
        panelDef.group = GAME_STATE_LEVELFINISH;
        /*panelDef.sprName = @"star_menu.png";
        panelDef.zIndex = 10;
		panelHighlight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,200)];
        [panelHighlight.spr setScaleX:3.5f];
        [panelHighlight.spr setScaleY:3.5f];*/
        
        panelDef.sprName = @"levelFinishScreenTable.png";
        panelDef.zIndex = 11;
		[[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,235)];
        
        panelDef.group = GAME_STATE_NONE;
        panelDef.zIndex = 12;
        panelDef.sprName = @"improved_score.png";
        if ([Defs instance].iPhone5)
            panelImproved = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(170, 400)];
        else
            panelImproved = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(150, 400)];
		
        panelImprovedGrowSpeedAcc = 0.01f;
        
        panelDef.group = GAME_STATE_LEVELFINISH;
        
        /*panelDef.sprName = @"levelFinishScreenLeftPalm.png";
        panelDef.zIndex = 15;
		panelPalmLeft = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(-30,130)];
        [panelPalmLeft.spr setAnchorPoint:CGPointMake(0.1f,0.1f)];
        isPalmLeftGoUp = YES;
        
        panelDef.sprName = @"levelFinishScreenRightPalm.png";
        panelDef.zIndex = 16;
		panelPalmRight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH+30,80)];
        [panelPalmRight.spr setAnchorPoint:CGPointMake(1.0f,0.1f)];
        isPalmGoUp = NO;
        
        panelDef.sprName = @"levelFinishScreenBushRight.png";
        panelDef.zIndex = 17;
		panelBushRight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH,0)];
        [panelBushRight.spr setAnchorPoint:CGPointMake(0.7f,0.2f)];
        isBushGoUp = NO;
        
        panelDef.sprName = @"levelFinishScreenPalmDown.png";
        panelDef.zIndex = 17;
		panelBushLeft = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(0,-10)];
        [panelBushLeft.spr setAnchorPoint:CGPointMake(0.1f,0.0f)];
        isBushLeftGoUp = NO;*/
            
        soundScoreDelay = 0.5f;
        timeCoinsAdd = 0;
        delayCoinsAdd = 0.5f;
        
        waitAddScoreTime = 0;
        waitAddScoreDelay = 1.3f;
        
        scoreCurrValueAddDelay = FRAME_RATE*0.8f;
	}
	return self;
}

- (void) setCollectedCoins:(int) _value {
    timeCoinsAdd = 0;
    scoreTotalCurrValue = [Defs instance].coinsCount;
    delayCoinsAdd = 0.2f;
    
    collectedCoinsValue = _value;
    collectedCoinsCurrValue = 0;
    soundScoreTime = soundScoreDelay;
    
    timeCollectedCoinsAdd = 0;
    [Defs instance].coinsCount += _value;
    delayCollectedCoinsAdd = 0.2f;
}

- (void) setScore:(int) _value {
    scoreValue = _value;
    scoreCurrValue = 0;
    scoreCurrValueKoeff = scoreValue/scoreCurrValueAddDelay;
    soundScoreTime = soundScoreDelay;
    
    if (_value > [Defs instance].bestScore) {
        [Defs instance].bestScore = _value;
        [MyData setStoreValue:@"bestScore" value:[NSString stringWithFormat:@"%i",[Defs instance].bestScore]];
        //[[GameCenter instance] reportScore:[Defs instance].bestScore forCategory:@"ExpandIt_TotalLeaderboard"];
        [self showPanelImproved:YES];
    }

    /*int _newCoinsCount = int(scoreValue/10000);
    CCLOG(@"_Score = %i , _newCoinsCount = %i",scoreValue, _newCoinsCount);
    
    timeCoinsAdd = 0;
    scoreTotalCurrValue = [Defs instance].coinsCount;
    delayCoinsAdd = 0.2f;
    
    [Defs instance].coinsCount += _newCoinsCount;*/
    //[[Defs instance].userSettings setInteger:[Statistics instance].totalLevelsComplite forKey:@"totalLevelsComplite"];
    [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
}

- (void) showPanelImproved:(BOOL)_flag {
    isPanelImprovedShowing = YES;
    panelImprovedGrowSpeed = panelImprovedGrowSpeedAcc;
    
    [panelImproved.spr setScale:0.1f];
    [panelImproved show:_flag];
    
    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"record_achieved.wav"];
}

- (void) show:(BOOL)_flag{
	if (isVisible == _flag) return;
	
	isVisible = _flag;
	// Тут происходит (CCSpriteBatchNode: resizing TextureAtlas capacity from [0] to [9].)
	
	if (isVisible){
        [[GameStandartFunctions instance] playOpenScreenAnimation];
        
        waitAddScoreTime = 0;
        [collectedCoinsStr setText:@"0"];
        [scoreStr setText:@"0"];
        [levelNumber setText:[NSString stringWithFormat:@"%i",scoreTotalCurrValue]];
        
        [self checkAvailableUpdates];
	} else { 
        
	}
}

- (void) update {
    if (isVisible) {
        
        if ([Defs instance].isOpenScreenAnimation) {
            if ([Defs instance].closeAnimationPanel.spr.opacity >= 25) [Defs instance].closeAnimationPanel.spr.opacity -= 25; else {
                [[Defs instance].closeAnimationPanel.spr setOpacity:0];
                [[Defs instance].closeAnimationPanel show:NO];
                [Defs instance].isOpenScreenAnimation = NO;
            }
        } else    
            if ([Defs instance].isCloseScreenAnimation) {
                if ([Defs instance].closeAnimationPanel.spr.opacity <= 225) [Defs instance].closeAnimationPanel.spr.opacity += 25; else {
                    [Defs instance].isCloseScreenAnimation = NO;
                    [[Defs instance].closeAnimationPanel.spr setOpacity:255];
                    if ([Defs instance].afterCloseAnimationScreenType == 0) {
                        
                    } else
                        if ([Defs instance].afterCloseAnimationScreenType == 1) {
                            [self buttonLevelsAction];
                        } else
                            if ([Defs instance].afterCloseAnimationScreenType == 2) {
                                //[self buttonLevelRestartAction];
                            }
                        
                    return;
                }
            }
        
        //if (panelHighlight.spr.rotation < 360) panelHighlight.spr.rotation += 1; else panelHighlight.spr.rotation = 1;
        
        
        /*if (isBushGoUp) {
            if (panelBushRight.spr.rotation < 7) panelBushRight.spr.rotation += 0.2f; else isBushGoUp = NO;
        } else {
            if (panelBushRight.spr.rotation > -10) panelBushRight.spr.rotation -= 0.2f; else isBushGoUp = YES;
        }
        
        if (isBushLeftGoUp) {
            if (panelBushLeft.spr.rotation < 2) panelBushLeft.spr.rotation += 0.25f; else isBushLeftGoUp = NO;
        } else {
            if (panelBushLeft.spr.rotation > -3) panelBushLeft.spr.rotation -= 0.25f; else isBushLeftGoUp = YES;
        }
        
        if (isPalmGoUp) {
            if (panelPalmRight.spr.rotation < 3) panelPalmRight.spr.rotation += 0.05f; else isPalmGoUp = NO;
        } else {
            if (panelPalmRight.spr.rotation > -6) panelPalmRight.spr.rotation -= 0.05f; else isPalmGoUp = YES;
        }
        
        if (isPalmLeftGoUp) {
            if (panelPalmLeft.spr.rotation < 4) panelPalmLeft.spr.rotation += 0.04f; else isPalmLeftGoUp = NO;
        } else {
            if (panelPalmLeft.spr.rotation > -1) panelPalmLeft.spr.rotation -= 0.03f; else isPalmLeftGoUp = YES;
        }*/
        
        if (collectedCoinsCurrValue < collectedCoinsValue) {
            timeCollectedCoinsAdd += TIME_STEP;
            if (timeCollectedCoinsAdd >= delayCollectedCoinsAdd) {
                ++collectedCoinsCurrValue;
                [collectedCoinsStr setPosition:ccp(collectedCoinsStrPos.x + [[Utils instance] myRandom2F]*2, collectedCoinsStrPos.y + [[Utils instance] myRandom2F]*2)];
                [collectedCoinsStr setText:[NSString stringWithFormat:@"%i",collectedCoinsCurrValue]];
                if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                timeCoinsAdd = 0;
            }
        } else
        
        if (scoreCurrValue < scoreValue) {
            scoreCurrValue += scoreCurrValueKoeff;
            [scoreStr setPosition:ccp(scoreStrPos.x + [[Utils instance] myRandom2F]*2, scoreStrPos.y + [[Utils instance] myRandom2F]*2)];
            if (scoreCurrValue > scoreValue) {
                [scoreStr setText:[NSString stringWithFormat:@"%i",scoreValue]];
            } else {
                [scoreStr setText:[NSString stringWithFormat:@"%d",(int)round(scoreCurrValue)]];
                soundScoreTime += TIME_STEP;
                if (soundScoreTime >= soundScoreDelay) {
                    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"points_count.wav"];  
                    soundScoreTime = 0;
                }
            }
        } else
        {
            if (scoreTotalCurrValue < [Defs instance].coinsCount) {
                timeCoinsAdd += TIME_STEP;
                if (timeCoinsAdd >= delayCoinsAdd) {
                    ++scoreTotalCurrValue;
                    [levelNumber setPosition:ccp(scoreTotalStrPos.x + [[Utils instance] myRandom2F]*2, scoreTotalStrPos.y + [[Utils instance] myRandom2F]*2)];
                    [levelNumber setText:[NSString stringWithFormat:@"%i",scoreTotalCurrValue]];
                    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    
                    timeCoinsAdd = 0;
                }
            }
        }
       // }
        if ((isPanelImprovedShowing)&&(panelImprovedGrowSpeed > 0)) {
            if (panelImproved.spr.scale < 1) {
                panelImprovedGrowSpeed += panelImprovedGrowSpeedAcc;
                [panelImproved.spr setScale:panelImproved.spr.scale + panelImprovedGrowSpeed];
            } else
                if (panelImprovedGrowSpeed <= 0.1f) {
                    isPanelImprovedShowing = NO;
                    [panelImproved.spr setScale:1];
                } else panelImprovedGrowSpeed *= -0.5;
            
            if (panelImprovedGrowSpeed < 0) {
                [panelImproved.spr setScale:panelImproved.spr.scale + panelImprovedGrowSpeed];
                panelImprovedGrowSpeed += panelImprovedGrowSpeedAcc;
            }
        }
    }
}

- (void) dealloc{
	[super dealloc];
}

@end
