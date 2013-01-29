//
//  PauseScreen.mm
//  Expand_It
//
//  Created by Mac Mini on 10.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseScreen.h"
#import	"globalParam.h"
#import "Defs.h"
#import "MainScene.h"
#import "GUIButtonDef.h"
#import "GUICheckBoxDef.h"
#import "GUIPanelDef.h"
#import "GUILabelDef.h"
#import "SimpleAudioEngine.h"
#import "GameStandartFunctions.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"

@implementation PauseScreen

//@synthesize buttonPassLevel;
//@synthesize labelFeaturePassLevelCounterIcon;
//@synthesize panelFeaturePassLevelCounterIcon;

- (void) buttonPauseClick {
    isShadowAnimationClose = YES;
}

/*- (void) buttonLevelsClick {
    [[GameStandartFunctions instance] playCloseScreenAnimation:1];
}*/

- (void) buttonShowMenuAction {
	[[MainScene instance].game prepareToHideGameScreen];
    [[MainScene instance] showMenu];
    [FlurryAnalytics logEvent:ANALYTICS_PAUSE_SCREEN_BUTTON_LEVELS_CLICKED];
}

- (id) init {
	if ((self = [super init])) {
		isVisible = NO;
		
	}
	return self;
}

- (void) load {
    
    GUIButtonDef *btnDef = [GUIButtonDef node];
    btnDef.sprName = @"btnPlayPauseScreen.png";
    btnDef.sprDownName = @"btnPlayPauseScreenDown.png";
    btnDef.group = GAME_STATE_GAMEPAUSE;
    btnDef.objCreator = self;
    btnDef.func = @selector(buttonPauseClick);
    btnDef.sound = @"button_click.wav";
    
    if ([Defs instance].iPhone5) {
        GUIButton *_btn = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 40, SCREEN_HEIGHT - 30)];
        [_btn.spr setScale:1.3f];
        _btn = nil;
    } else
        [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH - 20,SCREEN_HEIGHT-20)];
    
    GUIPanelDef *panelDef = [GUIPanelDef node];
    panelDef.parentFrame = self;
    panelDef.group = GAME_STATE_GAMEPAUSE;
    panelDef.sprName = nil;
    panelDef.sprFileName = @"pauseScreen.jpg";
    panelDef.zIndex = 160;
    
    backgroundSpr = [[MainScene instance].gui addItem:panelDef _pos:ccp(0,0)];
    [backgroundSpr.spr setAnchorPoint:ccp(0, 0)];
    if ([Defs instance].screenHD) [backgroundSpr.spr setScale:2];
    
    panelDef.parentFrame = [MainScene instance].gui;
    panelDef.group = GAME_STATE_GAMEPAUSE;
    panelDef.sprName = @"sleep_pause.png";
    
    pauseHeroZZZ = [[MainScene instance].gui addItem:panelDef _pos:ccp(SCREEN_WIDTH_HALF,280)];
    
    panelDef.sprName = @"pause_zzz_1.png";
    
    pauseZZZSpr = [[MainScene instance].gui addItem:panelDef _pos:ccp(SCREEN_WIDTH_HALF - 70, SCREEN_HEIGHT_HALF+140)];
    
    panelDef.sprName = @"satelliteBomb.png";
    panelDef.zIndex = 1;
    panelBombDistance = 120;
    panelBombAngle = 0;
    panelBomb = [[MainScene instance].gui addItem:panelDef _pos:ccp(-100,-100)];
    [panelBomb.spr setOpacity:200];
    
    panelBombMagnetDistance = 160;
    panelBombMagnetAngle = 140;
    panelDef.sprName = @"satelliteBombmagnet.png";
    panelBombMagnet = [[MainScene instance].gui addItem:panelDef _pos:ccp(-100,-100)];
    [panelBombMagnet.spr setOpacity:200];
    
    panelBombTimeDistance = 250;
    panelBombTimeAngle = 310;
    panelDef.sprName = @"satelliteBombtime.png";
    panelBombTime = [[MainScene instance].gui addItem:panelDef _pos:ccp(-100,-100)];
    [panelBombTime.spr setOpacity:200];
    
    NSArray *animArr = [NSArray arrayWithObjects:
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pause_zzz_1.png"],
                        [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"pause_zzz_2.png"],
                        nil];
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animArr delay:0.2f];
    pauseAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [pauseAction retain];
    
    btnDef.sprName = @"btnBack.png";
    btnDef.sprDownName = @"btnBackDown.png";
    btnDef.group = GAME_STATE_GAMEPAUSE;
    btnDef.objCreator = self;
    btnDef.func = @selector(buttonShowMenuAction);
    btnDef.sound = @"button_click.wav";
    
    btnLevels = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF - 40, 40)];
    
    GUICheckBoxDef *checkBoxSoundDef = [GUICheckBoxDef node];
    checkBoxSoundDef.zIndex = 5;
    checkBoxSoundDef.sprName = @"btnMusicOn.png";
    checkBoxSoundDef.sprOneDownName = @"btnMusicOnDown.png";
    checkBoxSoundDef.sprTwoName = @"btnMusicOff.png";
    checkBoxSoundDef.sprTwoDownName = @"btnMusicOffDown.png";
    checkBoxSoundDef.group = GAME_STATE_GAMEPAUSE;
    checkBoxSoundDef.objCreator = [GameStandartFunctions instance];
    checkBoxSoundDef.func = @selector(checkBoxEnableMusicAction);
    checkBoxSoundDef.checked = [Defs instance].isMusicMute;
    checkBoxSoundDef.sound = @"button_click.wav";
    
    btnMusic = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(SCREEN_WIDTH - 30, 270)];
    
    checkBoxSoundDef.sprName = @"btnSound.png";
    checkBoxSoundDef.sprOneDownName = @"btnSoundDown.png";
    checkBoxSoundDef.sprTwoName = @"btnSoundOff.png";
    checkBoxSoundDef.sprTwoDownName = @"btnSoundOffDown.png";
    checkBoxSoundDef.func = @selector(checkBoxEnableSoundAction);
    checkBoxSoundDef.checked = [Defs instance].isSoundMute;
    
    btnSound = [[MainScene instance].gui addItem:(id)checkBoxSoundDef _pos:ccp(SCREEN_WIDTH - 30, 210)];
    
    isPauseHeroRotateRight = YES;
}

- (void) show:(BOOL)_flag {
	if (isVisible == _flag) return;
	
	isVisible = _flag;
	
	if (isVisible){
        isShadowAnimationClose = NO;
        
        [backgroundSpr.spr setOpacity:5];
        [btnLevels.spr setOpacity:5];
        [btnShop.spr setOpacity:5];
        [btnMusic.spr setOpacity:5];
        [btnSound.spr setOpacity:5];
        [pauseHeroZZZ.spr setOpacity:5];
        [pauseZZZSpr.spr setOpacity:5];
		[pauseZZZSpr.spr runAction:pauseAction];
		[btnSound setChecked:[Defs instance].isSoundMute];
        [btnMusic setChecked:[Defs instance].isMusicMute];
	} else {
		[pauseZZZSpr.spr stopAction:pauseAction];
	}
}

- (void) update {   
    if (isShadowAnimationClose) {
        if (btnLevels.spr.opacity > 25) btnLevels.spr.opacity -= 25; else btnLevels.spr.opacity = 0;
        if (btnShop.spr.opacity > 25) btnShop.spr.opacity -= 25; else btnShop.spr.opacity = 0;
        if (btnMusic.spr.opacity > 25) btnMusic.spr.opacity -= 25; else btnMusic.spr.opacity = 0;
        if (btnSound.spr.opacity > 25) btnSound.spr.opacity -= 25; else btnSound.spr.opacity = 0;
        if (pauseHeroZZZ.spr.opacity > 25) pauseHeroZZZ.spr.opacity -= 25; else pauseHeroZZZ.spr.opacity = 0;
        if (pauseZZZSpr.spr.opacity > 25) pauseZZZSpr.spr.opacity -= 25; else pauseZZZSpr.spr.opacity = 0;
        
        if (backgroundSpr.spr.opacity > 25) backgroundSpr.spr.opacity -= 25; else {
            backgroundSpr.spr.opacity = 0;
            isShadowAnimationClose = NO;
            [[MainScene instance].game buttonPauseAction];
        }
    } else {
        if (backgroundSpr.spr.opacity < 220) backgroundSpr.spr.opacity+= 22; else backgroundSpr.spr.opacity = 220;
        if (btnLevels.spr.opacity < 250) btnLevels.spr.opacity+= 25; else btnLevels.spr.opacity = 255;
        if (btnShop.spr.opacity < 250) btnShop.spr.opacity+= 25; else btnShop.spr.opacity = 255;
        if (btnMusic.spr.opacity < 250) btnMusic.spr.opacity+= 25; else btnMusic.spr.opacity = 255;
        if (btnSound.spr.opacity < 250) btnSound.spr.opacity+= 25; else btnSound.spr.opacity = 255;
        if (pauseHeroZZZ.spr.opacity < 250) pauseHeroZZZ.spr.opacity+= 25; else pauseHeroZZZ.spr.opacity = 255;
        if (pauseZZZSpr.spr.opacity < 250) pauseZZZSpr.spr.opacity+= 25; else pauseZZZSpr.spr.opacity = 255;
    }
    
    if (isPauseHeroRotateRight) {
        [pauseHeroZZZ.spr setRotation:pauseHeroZZZ.spr.rotation + 0.1f];
        if (pauseHeroZZZ.spr.rotation >= 4) isPauseHeroRotateRight = NO;
    } else {
        [pauseHeroZZZ.spr setRotation:pauseHeroZZZ.spr.rotation - 0.1f];
        if (pauseHeroZZZ.spr.rotation <= -4) isPauseHeroRotateRight = YES;
    }
    
    panelBombAngle += 0.8f;
    if (panelBombAngle >= 360) panelBombAngle -= 360;
    [panelBomb setPosition:ccp(SCREEN_WIDTH_HALF + panelBombDistance*cos(CC_DEGREES_TO_RADIANS(panelBombAngle)), 250 + panelBombDistance*sin(CC_DEGREES_TO_RADIANS(panelBombAngle)))];
    
    panelBombMagnetAngle += 0.6f;
    if (panelBombMagnetAngle >= 360) panelBombMagnetAngle -= 360;
    [panelBombMagnet setPosition:ccp(SCREEN_WIDTH_HALF - 50 + panelBombMagnetDistance*cos(CC_DEGREES_TO_RADIANS(panelBombMagnetAngle)), 270 + panelBombMagnetDistance*sin(CC_DEGREES_TO_RADIANS(panelBombMagnetAngle)))];
    
    panelBombTimeAngle += 0.4f;
    if (panelBombTimeAngle >= 360) panelBombTimeAngle -= 360;
    [panelBombTime setPosition:ccp(SCREEN_WIDTH_HALF + 100 + panelBombTimeDistance*cos(CC_DEGREES_TO_RADIANS(panelBombTimeAngle)), 320 + panelBombTimeDistance*sin(CC_DEGREES_TO_RADIANS(panelBombTimeAngle)))];
    
    /*CGPoint pos = btnCredits.spr.position;
	float _marketGoSpeedAcc = 0.01f;
    
    if (pos.y > (200)) _marketGoSpeedAcc = -0.01f;
    
    marketGoSpeed += _marketGoSpeedAcc;
    
    pos.y += marketGoSpeed;
    
	
	[btnCredits setPosition:pos];
    [panelMarket setPosition:pos];
    
    if (isPanelMarketOpacityAlpaAdd) {
        if (panelMarketOpacity < 253) panelMarketOpacity += 3; else isPanelMarketOpacityAlpaAdd = NO;
    } else {
        if (panelMarketOpacity > 100) panelMarketOpacity -= 3; else isPanelMarketOpacityAlpaAdd = YES;
    }
    [panelMarket.spr setOpacity:panelMarketOpacity];*/
}

- (void) touchReaction:(CGPoint)_touchPos {	
	
}

-(void) ccTouchEnded:(CGPoint)_touchPos {

}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation 
			   _diff:(CGPoint)_diff {	

}

- (void) dealloc{
	[super dealloc];
}

@end
