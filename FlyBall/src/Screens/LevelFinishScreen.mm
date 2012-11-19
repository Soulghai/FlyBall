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

//
// ParticleExplosion
//
@implementation CCParticleExplosion2
-(id) init
{
	return [self initWithTotalParticles:700];
}

-(id) initWithTotalParticles:(NSUInteger)p
{
	if( (self=[super initWithTotalParticles:p]) ) {
        
		// duration
		duration = 0.1f;
		
		self.emitterMode = kCCParticleModeGravity;
        
		// Gravity Mode: gravity
		self.gravity = ccp(0,0);
		
		// Gravity Mode: speed of particles
		self.speed = 150;
		self.speedVar = 40;
		
		// Gravity Mode: radial
		self.radialAccel = 0;
		self.radialAccelVar = 0;
		
		// Gravity Mode: tagential
		self.tangentialAccel = 0;
		self.tangentialAccelVar = 0;
		
		// angle
		angle = 0;
		angleVar = 360;
        
		// emitter position
		self.position = CGPointZero;
		posVar = CGPointZero;
		
		// life of particles
		life = 0.25f;
		lifeVar = 0.05f;
		
		// size, in pixels
		startSize = 5.0f;
		startSizeVar = 3.0f;
		endSize = 12;
        
		// emits per second
		emissionRate = totalParticles/duration;
		
		// color of particles
		startColor.r = 0.7f;
		startColor.g = 0.7f;
		startColor.b = 0.0f;
		startColor.a = 1.0f;
		startColorVar.r = 0.3f;
		startColorVar.g = 0.3f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.0f;
		endColor.r = 1.0f;
		endColor.g = 1.0f;
		endColor.b = 0.0f;
		endColor.a = 1.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"bomb_particle.png"];
        
		// additive
		self.blendAdditive = YES;
	}
	
	return self;
}
@end

@implementation LevelFinishScreen

- (void) buttonLevelRestartClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:2];
    [FlurryAnalytics logEvent:ANALYTICS_LEVELEND_SCREEN_BUTTON_REPLAY_CLICKED];
}

- (void) buttonLevelRestartAction {
    [self show:NO];
    [[MainScene instance].game levelRestart];
        
    [FlurryAnalytics logEvent:ANALYTICS_GAME_SCREEN_BUTTON_RESTART_LEVEL_CLICKED];
}

- (void) buttonLevelsClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:1];
    [FlurryAnalytics logEvent:ANALYTICS_LEVELEND_SCREEN_BUTTON_REPLAY_CLICKED];
}

- (void) buttonLevelsAction {
    [self show:NO];
    [[MainScene instance] showMenu];
    [FlurryAnalytics logEvent:ANALYTICS_PAUSE_SCREEN_BUTTON_LEVELS_CLICKED];
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_LEVELFINISH;
        _labelTTFOutlinedDef.text = @"AAAAhhhhaaAAaaha..";
        
        levelNumber =[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(SCREEN_WIDTH_HALF, 320)];
        
        scoreStrPos = ccp(SCREEN_WIDTH_HALF, 244);
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 0);
        scoreStr =[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:scoreStrPos];
		
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnLevels.png";
		btnDef.sprDownName = @"btnLevelsDown.png";
		btnDef.group = GAME_STATE_LEVELFINISH;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonLevelsClick);
		btnDef.sound = @"button_click.wav";
        [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF-40,40)];
        
        btnDef.sprName = @"btnRestart.png";
		btnDef.sprDownName = @"btnRestartDown.png";
		btnDef.group = GAME_STATE_LEVELFINISH;
		btnDef.func = @selector(buttonLevelRestartClick);
        [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(SCREEN_WIDTH_HALF+40,40)];
        
        GUIPanelDef *panelDef = [GUIPanelDef node];
        
        //panelDef.parentFrame = [Defs];
        panelDef.group = GAME_STATE_LEVELFINISH;
        panelDef.sprName = @"star_menu.png";
        panelDef.zIndex = 10;
		panelHighlight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,200)];
        [panelHighlight.spr setScaleX:3.5f];
        [panelHighlight.spr setScaleY:3.5f];
        
        panelDef.sprName = @"levelFinishScreenTable.png";
        panelDef.zIndex = 11;
		[[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,235)];
        
        panelDef.group = GAME_STATE_NONE;
        panelDef.zIndex = 12;
        panelDef.sprName = @"improved_score.png";
        if ([Defs instance].iPhone5)
            panelImproved = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(170, 235)];
        else
            panelImproved = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(150, 235)];
		
        panelImprovedGrowSpeedAcc = 0.02;
        
        panelDef.group = GAME_STATE_LEVELFINISH;
        
        panelDef.sprName = @"levelFinishScreenLeftPalm.png";
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
        isBushLeftGoUp = NO;
        
        panelDef.sprName = @"star_1.png";
        panelDef.zIndex = 18;
        panelDef.group = GAME_STATE_NONE;
		starArr = [NSArray arrayWithObjects:
				   [[MainScene instance].gui addItem:(id)panelDef _pos:CGPointZero],
				   [[MainScene instance].gui addItem:(id)panelDef _pos:CGPointZero],
				   [[MainScene instance].gui addItem:(id)panelDef _pos:CGPointZero],
				   nil];
		[starArr retain];
		
		for (unsigned int i = 0; i < 3; i++) {
			GUIPanel *_spr = [starArr objectAtIndex:i];
			[_spr setPosition:ccp(SCREEN_WIDTH_HALF - 7 - _spr.spr.contentSize.width + i * (_spr.spr.contentSize.width+5), (int)(SCREEN_HEIGHT_HALF*0.78f))];
		}
		
		NSArray *starAnimFrames = [NSArray arrayWithObjects:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_1.png"],
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_2.png"],
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_3.png"],
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_4.png"],
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_5.png"],
                                   [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"star_6.png"],
						  nil];
		
		CCAnimation *starAnimation= [CCAnimation animationWithSpriteFrames:starAnimFrames delay:0.08f];
		starAction = [NSArray arrayWithObjects:
					  [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:starAnimation]],
					  [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:starAnimation]],
					  [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:starAnimation]],
					  nil];
		[starAction retain];
		
		starsToShowCount = 0;
        starsToShowCurrent = 0;
        starsToShowTimer = 0;
        starsToShowDelta = 0.34f;
        soundScoreDelay = 0.5f;  
        
        waitAddScoreTime = 0;
        waitAddScoreDelay = 1.3f;
        
        scoreCurrValueAddDelay = FRAME_RATE*0.8f;
        
        emitter = [NSMutableArray arrayWithCapacity:3];
        [emitter retain];
	}
	return self;
}

- (void) setScore:(int) _value {
    scoreValue = _value;
    scoreCurrValue = 0;
    scoreCurrValueKoeff = scoreValue/scoreCurrValueAddDelay;
    soundScoreTime = soundScoreDelay;
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

        [scoreStr setText:@"0"];
	} else { 
		if (levelNumber.parent != nil) [levelNumber removeFromParentAndCleanup:YES];
		for (unsigned int i = 0; i < 3; i++) {
			GUIPanel *_spr = [starArr objectAtIndex:i];
			if (_spr.isVisible) {
				id _actionID = [starAction objectAtIndex:i];
				[_spr.spr stopAction:_actionID];
				//[_spr removeFromParentAndCleanup:YES];
			}
		}
		if (scoreStr.parent != nil) [scoreStr removeFromParentAndCleanup:YES];
        
        for(unsigned int i = 0; i < [emitter count]; i++) {
            CCParticleSystem *_part = [emitter objectAtIndex:i];
            if ((_part)&&(_part.parent)) [_part removeFromParentAndCleanup:YES];
            [_part release];
            _part = nil;
        }
        [emitter removeAllObjects];
	}
}

- (void) showStarAtID:(unsigned int) _id {
    GUIPanel *_spr = [starArr objectAtIndex:_id];
    [_spr show:YES];
    id _actionID = [starAction objectAtIndex:_id];
    [_spr.spr runAction:_actionID];
    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
    
    CCParticleSystem *_part = [[CCParticleExplosion2 alloc] initWithTotalParticles:100];
    
    [emitter addObject:_part];
    [_part setPosition:ccp(_spr.spr.position.x,_spr.spr.position.y)];
    [[MainScene instance] addChild:_part];
}

- (void) showStars:(unsigned int)_starCount {
	starsToShowCount = _starCount;
    starsToShowCurrent = 0;
    starsToShowTimer = - 0.7f;
    //[self showStarAtID:starsToShowCurrent];
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
                        }
                        else
                            if ([Defs instance].afterCloseAnimationScreenType == 2) {
                                [self buttonLevelRestartAction];
                            }
                    return;
                }
            }
        
        if (panelHighlight.spr.rotation < 360) panelHighlight.spr.rotation += 1; else panelHighlight.spr.rotation = 1;
        
        
        if (isBushGoUp) {
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
        }
        
        if (starsToShowCurrent < starsToShowCount) {
            starsToShowTimer += TIME_STEP;
            if (starsToShowTimer >= starsToShowDelta ){
                starsToShowTimer = 0;
                [self showStarAtID:starsToShowCurrent];
                ++starsToShowCurrent;
            }
        }
        
        
        //waitAddScoreTime += TIME_STEP;
        //if (waitAddScoreTime >= waitAddScoreDelay) {
        if (scoreCurrValue < scoreValue) {
            scoreCurrValue += scoreCurrValueKoeff;
            [scoreStr setPosition:ccp(scoreStrPos.x + [[Utils instance] myRandom2F]*2, scoreStrPos.y + [[Utils instance] myRandom2F]*2)];
            if (scoreCurrValue > scoreValue) {
                [scoreStr setText:[NSString stringWithFormat:@"%d",scoreValue]];
            } else {
                [scoreStr setText:[NSString stringWithFormat:@"%d",(int)round(scoreCurrValue)]];
                soundScoreTime += TIME_STEP;
                if (soundScoreTime >= soundScoreDelay) {
                    if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:@"points_count.wav"];  
                    soundScoreTime = 0;
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
