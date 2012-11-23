//
//  MarketScreen.mm
//  Expand_It
//
//  Created by Mac Mini on 02.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MarketScreen.h"
#import "MainScene.h"
#import "globalParam.h"
#import "Defs.h"
#import "GUIButtonDef.h"
#import "MKStoreManager.h"
#import "GameStandartFunctions.h"
#import "AnalyticsData.h"
#import "FlurryAnalytics.h"

@implementation MarketScreen

- (void) buttonBuyAppAsGift {
    [[GameStandartFunctions instance] goToUrl:@"http://itunes.apple.com/ru/app/human-juice/id407550337?mt=8"];
    //[FlurryAnalytics logEvent:ANALYTICS_MARKET_SCREEN_GIFT_THIS_APP];
}

- (void) buttonBackToMenuScreenClick {
	[[GameStandartFunctions instance] playCloseScreenAnimation:0];
}

- (void) buttonBackToMenuScreenAction {
	[self show:NO];
	if ([MainScene instance].game.oldState == GAME_STATE_MENU)
        [[MainScene instance] showMenu];
    else [[MainScene instance] showGamePause];
}

- (void) buttonBuyItem1Action {
    [panelBuyInformation show:YES];
    [btnPanelBuyInfoNO show:YES];
    [btnPanelBuyInfoYES show:YES];
    [btnPanelBuyInfoNO setEnabled:YES];
    [btnPanelBuyInfoYES setEnabled:YES];
}

- (void) panelBuyInformationHide {
    [panelBuyInformation show:NO];
    [btnPanelBuyInfoNO show:NO];
    [btnPanelBuyInfoYES show:NO];
    [btnPanelBuyInfoNO setEnabled:NO];
    [btnPanelBuyInfoYES setEnabled:NO];
}

- (void) buttonBuyItem2Action {
    //[[MKStoreManager sharedManager] buyFeature:kFeatureBId];
    //[FlurryAnalytics logEvent:ANALYTICS_IAP_MARKET_SCREEN_BUY_15_SKIPS];
}

- (void) buttonBuyItem3Action {
	
}

- (id) init{
	if ((self = [super init])) {
		isVisible = NO;
		
		backSpr = nil;		
		
		GUIButtonDef *btnDef = [GUIButtonDef node];
		btnDef.sprName = @"btnBack.png";
		btnDef.sprDownName = @"btnBackDown.png";
		btnDef.group = GAME_STATE_MARKETSCREEN;
		btnDef.objCreator = self;
		btnDef.func = @selector(buttonBackToMenuScreenClick);
		btnDef.sound = @"button_click.wav";
		
		[[MainScene instance].gui addItem:(id)btnDef _pos:ccp(30,30)];
		
        GUIPanelDef *_panelDef = [GUIPanelDef node];
        _panelDef.group = GAME_STATE_NONE;
        _panelDef.parentFrame = [MainScene instance];
        _panelDef.zOrder = 100;
        _panelDef.sprName = @"window_reset.png";
        
        panelBuyInformation = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF)];
        
        btnDef.group = GAME_STATE_NONE;
        btnDef.isManyTouches = YES;
		btnDef.sprName = @"btnNo.png";
		btnDef.sprDownName = @"btnNoDown.png";
		btnDef.parentFrame = panelBuyInformation.spr;
		btnDef.func = @selector(panelBuyInformationHide);
		btnDef.enabled = NO;
		
		btnPanelBuyInfoNO = [[MainScene instance].gui addItem:(id)btnDef
                                                                _pos:ccp(panelBuyInformation.spr.contentSize.width*0.5f-50, panelBuyInformation.spr.contentSize.height*0.25f)];
		
		btnDef.sprName = @"btnOk.png";
		btnDef.sprDownName = @"btnOkDown.png";
		btnDef.func = @selector(panelBuyInformationHide);
		
		btnPanelBuyInfoYES = [[MainScene instance].gui addItem:(id)btnDef
                                                                 _pos:ccp(panelBuyInformation.spr.contentSize.width*0.5f+50, panelBuyInformation.spr.contentSize.height*0.25f)];
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_MARKETSCREEN;
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentCenter;
        _labelTTFOutlinedDef.text = @"Improvements";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(SCREEN_WIDTH_HALF, 465)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        _labelTTFOutlinedDef.text = @"Ship";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(5, 442)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        _labelTTFOutlinedDef.text = @"Bonuses";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(315, 442)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        _labelTTFOutlinedDef.text = @"Ship equipment";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(5, 200)];
        
        
        btnDef.group = GAME_STATE_MARKETSCREEN;
        btnDef.parentFrame = [MainScene instance].gui;
        btnDef.enabled = YES;
        // Корабль
        for (int i = 0; i < 6; i++) {
            btnDef.sprName = [NSString stringWithFormat:@"icon_upgrade_%i.jpg",i];
            btnDef.sprDownName = nil;
            btnDef.func = @selector(buttonBuyItem1Action);
            btnDef.isManyTouches = YES;
            
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43 + ((i % 2)*64) + (i % 2)*8, 400 - int(i / 2)*72)];
        }
        
        // Бонусы
        for (int i = 0; i < 6; i++) {
            btnDef.sprName = [NSString stringWithFormat:@"icon_upgrade_%i.jpg",5-i];
            btnDef.sprDownName = nil;
            btnDef.func = @selector(buttonBuyItem1Action);
            btnDef.isManyTouches = YES;
            
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(206 + ((i % 2)*64) + (i % 2)*8, 400 - int(i / 2)*72)];
        }
        
        btnDef.sprName = @"btnGiftUp.png";
		btnDef.sprDownName = @"btnGiftDown.png";
		btnDef.func = @selector(buttonBuyAppAsGift);
		
		[[MainScene instance].gui addItem:(id)btnDef _pos:ccp(275,30)];
		
	}
	return self;
}

- (void) show:(BOOL)_flag{
	if (isVisible == _flag) return;
	
	isVisible = _flag;
	
	if (isVisible){	
        [[GameStandartFunctions instance] playOpenScreenAnimation];
        
        if (backSpr == nil) {
            if ([Defs instance].iPhone5)
                backSpr = [CCSprite spriteWithFile:@"shop_iPhone5.jpg"];
            else
                backSpr = [CCSprite spriteWithFile:@"shop.jpg"];
            backSpr.position = ccp(SCREEN_WIDTH_HALF,SCREEN_HEIGHT_HALF);
            [backSpr retain];
        }
		if (backSpr.parent == nil) [self addChild:backSpr];
	} else { 
		if (backSpr.parent != nil) [backSpr removeFromParentAndCleanup:YES];
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
}

- (void) dealloc{	
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[super dealloc];
}

@end
