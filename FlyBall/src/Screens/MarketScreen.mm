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
    //[[MKStoreManager sharedManager] buyFeature:kFeatureAId];
    //[FlurryAnalytics logEvent:ANALYTICS_IAP_MARKET_SCREEN_BUY_5_SKIPS];
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
		
		GUIButtonDef *btnPlayDef = [GUIButtonDef node];
		btnPlayDef.sprName = @"btnBack.png";
		btnPlayDef.sprDownName = @"btnBackDown.png";
		btnPlayDef.group = GAME_STATE_MARKETSCREEN;
		btnPlayDef.objCreator = self;
		btnPlayDef.func = @selector(buttonBackToMenuScreenClick);
		btnPlayDef.sound = @"button_click.wav";
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(30,30)];
		
        GUIPanelDef *_panelDef = [GUIPanelDef node];
        _panelDef.group = GAME_STATE_MARKETSCREEN;
        for (int i = 0; i < 5; i++) {
            _panelDef.sprName = @"icon_upgrade_1.jpg";
            
            [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(20 + (i*64 + 10), 400)];
        }
        
        
        for (int i = 0; i < 5; i++) {
            btnPlayDef.sprName = @"btnBuy5Up.png";
            btnPlayDef.sprDownName = @"btnBuy5Down.png";
            btnPlayDef.func = @selector(buttonBuyItem1Action);
            btnPlayDef.isManyTouches = YES;
            
            [[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(20 + (i*64 + 10), 400)];
        }
		
		btnPlayDef.sprName = @"btnBuy15Up.png";
		btnPlayDef.sprDownName = @"btnBuy15Down.png";
		btnPlayDef.func = @selector(buttonBuyItem2Action);
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(134,170)];
        
        btnPlayDef.sprName = @"btnGiftUp.png";
		btnPlayDef.sprDownName = @"btnGiftDown.png";
		btnPlayDef.func = @selector(buttonBuyAppAsGift);
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(280,30)];
		
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
