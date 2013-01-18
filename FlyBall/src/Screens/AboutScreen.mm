//
//  AboutScreen.mm
//  Expand_It
//
//  Created by Mac Mini on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutScreen.h"
#import	"globalParam.h"
#import "Defs.h"
#import "GUIButtonDef.h"
#import "GUIPanelDef.h"
#import "SimpleAudioEngine.h"
#import "GameStandartFunctions.h"
#import "MainScene.h"
#import "FlurryAnalytics.h"
#import "AnalyticsData.h"

@implementation AboutScreen

- (void) buttonBackToMenuScreenClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonBackToMenuScreenAction {
	[[MainScene instance] showMenu];
}


- (id) init {
	if ((self = [super init])) {
		isVisible = NO;
		
		backgroundSpr = nil;
        
        GUIPanelDef *panelDef = [GUIPanelDef node];
        panelDef.group = GAME_STATE_CREDITS;
        //panelDef.parentFrame = [Defs instance].objectBackLayer;
        panelDef.zIndex = 10;
        /*panelDef.sprName = @"star_menu.png";
		panelHighlight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH_HALF,200)];
        [panelHighlight.spr setScaleX:3.5f];
        [panelHighlight.spr setScaleY:3.5f];*/
		
        /*panelDef.parentFrame = [MainScene instance].gui;
        panelDef.sprName = @"levelFinishScreenLeftPalm.png";
        panelDef.zIndex = 15;
		panelPalmLeft = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(-17,130)];
        [panelPalmLeft.spr setAnchorPoint:CGPointMake(0.1f,0.1f)];
        isPalmLeftGoUp = YES;
        
        panelDef.sprName = @"levelFinishScreenRightPalm.png";
        panelDef.zIndex = 16;
		panelPalmRight = [[MainScene instance].gui addItem:(id)panelDef _pos:ccp(SCREEN_WIDTH+30,90)];
        [panelPalmRight.spr setAnchorPoint:CGPointMake(1.0f,0.1f)];
        isPalmRightGoUp = NO;*/
        
        GUIButtonDef *btnPlayDef = [GUIButtonDef node];
		btnPlayDef.sprName = @"btnBack.png";
		btnPlayDef.sprDownName = @"btnBackDown.png";
		btnPlayDef.group = GAME_STATE_CREDITS;
		btnPlayDef.objCreator = self;
		btnPlayDef.func = @selector(buttonBackToMenuScreenClick);
		btnPlayDef.sound = @"button_click.wav";
        
        [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(35,35)];
        
        creditsArr = [NSMutableArray arrayWithCapacity:11];
        [creditsArr retain];
        
        CCLabelBMFont *font;
        
        font = [CCLabelBMFont labelWithString:@"Crazy Jump" fntFile:@"gameFont.fnt"];
        [font setScale:1.6f];
        [font setColor:ccc3(100,100,255)];
        [creditsArr addObject: font];
        
#if MACROS_LITE_VERSION == 1
        font = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"ver. %.1f lite", GAME_VERSION] fntFile:@"gameFont.fnt"];
#else
        font = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"ver. %.1f", GAME_VERSION] fntFile:@"gameFont.fnt"];
#endif
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"(c) 2012 FDGENTERTAINMENT GMBH & CO KG"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"WEBSITE:"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,0)];
        [font setScale:0.8f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"www.fdg-entertainment.com"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"SUPPORT:"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,0)];
        [font setScale:0.8f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"support@fdg-entertainment.com"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Credits"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,100,100)];
        [font setScale:1];
        [creditsArr addObject: font];
        
        
        font = [CCLabelBMFont labelWithString:@"Zakhar STAFF:"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,0)];
        [font setScale:0.8f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Programming - Zakhar Gadzhiev"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Graphic designer - Dmitry Vashshinnikov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Sound design - Strategic Music"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Level designer - Ayza Melikov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Video designer - Dmitry Kizenkov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        
        
        
        font = [CCLabelBMFont labelWithString:@"FDG STAFF:"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,0)];
        [font setScale:0.8f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Producer - Philipp DOESCHL"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"CO-Producer - Thomas Kern"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"QA - Maxi Heiser"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"QA - Piotr Marciniak"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"PR & Marketing - Thomas Kern"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Busines & Legal - Marcus Goerl"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        
        
        
        font = [CCLabelBMFont labelWithString:@"Testers"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,0)];
        [font setScale:0.8f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"FDG TEAM"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Nadejda Ivanovna"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Zabira Gadzhieva"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Rasim Ayvazov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Ruslan Ramazanov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Pavel Kruchinin"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        font = [CCLabelBMFont labelWithString:@"Oleg Rubcov"fntFile:@"gameFont.fnt"];
        [font setColor:ccc3(255,255,255)];
        [font setScale:0.6f];
        [creditsArr addObject: font];
        
        
        
        unsigned int _len = [creditsArr count];
        for (unsigned int i = 0; i < _len; i++) {
            font = [creditsArr objectAtIndex:i];
            [font setAnchorPoint:ccp(0.5f,0.5f)];
        }
        
        creditsMoveTime = 0;
        creditsMoveDelay = 3;
	}
	return self;
}

- (void) show:(BOOL)_flag {
	if (isVisible == _flag) return;
	
	isVisible = _flag;
	
    CCLabelBMFont *font;
    unsigned int _len = [creditsArr count];
    int i;
    
	if (isVisible){
        [[GameStandartFunctions instance] playOpenScreenAnimation];
        
        creditsMoveTime = 0;
        
        if (backgroundSpr == nil) {
            if ([Defs instance].iPhone5)
                backgroundSpr = [CCSprite spriteWithFile:@"credits_iPhone5.jpg"];
            else
                backgroundSpr = [CCSprite spriteWithFile:@"credits.jpg"];
            backgroundSpr.position = ccp(SCREEN_WIDTH_HALF,SCREEN_HEIGHT_HALF);
            [backgroundSpr retain];
        }
		if (backgroundSpr.parent == nil) 
			[self addChild:backgroundSpr z:0];
        
        int _oldPosition = 310;
        for (i = 0; i < _len; i++) {
            font = [creditsArr objectAtIndex:i];            
            _oldPosition += - (40*font.scaleX);
            font.position = ccp(SCREEN_WIDTH_HALF, _oldPosition);
            
            if (i == 0) _oldPosition -= 70;
            
            if (!font.parent) [self addChild:font];
        }
        
	} else { 
		if (backgroundSpr.parent != nil) [backgroundSpr removeFromParentAndCleanup:YES];
        for (i = 0; i < _len; i++) {
            font = [creditsArr objectAtIndex:i];
            [font removeFromParentAndCleanup:YES];
        }
	}
}

- (void) update {
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
                    [self buttonBackToMenuScreenAction];
                }
            }
        }
    
    //if (panelHighlight.spr.rotation < 360) panelHighlight.spr.rotation += 0.5f; else panelHighlight.spr.rotation = 0.5f;
    
	/*if (isPalmRightGoUp) {
        if (panelPalmRight.spr.rotation < 3) panelPalmRight.spr.rotation += 0.07f; else isPalmRightGoUp = NO;
    } else {
        if (panelPalmRight.spr.rotation > -6) panelPalmRight.spr.rotation -= 0.07f; else isPalmRightGoUp = YES;
    }
    
    if (isPalmLeftGoUp) {
        if (panelPalmLeft.spr.rotation < 4) panelPalmLeft.spr.rotation += 0.08f; else isPalmLeftGoUp = NO;
    } else {
        if (panelPalmLeft.spr.rotation > -1) panelPalmLeft.spr.rotation -= 0.08f; else isPalmLeftGoUp = YES;
    }*/
    
    if (creditsMoveTime >= creditsMoveDelay) {
        CCLabelBMFont *font;
        unsigned int _len = [creditsArr count];
        unsigned int i;
        
        int _addCoeff = 0;
        font = [creditsArr objectAtIndex:0];
        if (font.position.y > 1120) {
            _addCoeff = -1170;
            [FlurryAnalytics logEvent:ANALYTICS_CREITS_SCREEN_WATHCHED_TO_THE_END];
        }
        for (i = 0; i < _len; i++) {
            font = [creditsArr objectAtIndex:i];
            [font setPosition:ccp(SCREEN_WIDTH_HALF, font.position.y + _addCoeff + 1)];
        }
    } else creditsMoveTime += TIME_STEP;
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
