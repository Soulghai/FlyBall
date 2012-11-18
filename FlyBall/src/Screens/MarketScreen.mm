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
    [FlurryAnalytics logEvent:ANALYTICS_MARKET_SCREEN_GIFT_THIS_APP];
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
    [[MKStoreManager sharedManager] buyFeature:kFeatureAId];
    [FlurryAnalytics logEvent:ANALYTICS_IAP_MARKET_SCREEN_BUY_5_SKIPS];
}

- (void) buttonBuyItem2Action {
    [[MKStoreManager sharedManager] buyFeature:kFeatureBId];
    [FlurryAnalytics logEvent:ANALYTICS_IAP_MARKET_SCREEN_BUY_15_SKIPS];
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
		
		btnPlayDef.sprName = @"btnBuy5Up.png";
		btnPlayDef.sprDownName = @"btnBuy5Down.png";
		btnPlayDef.func = @selector(buttonBuyItem1Action);
        btnPlayDef.isManyTouches = YES;
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(134,233)];
        
        float _textSize = 1;
        if ([[Defs instance].currentLanguage isEqualToString:@"en"]) {
            _textSize = 1.0f; 
        } else
            if ([[Defs instance].currentLanguage isEqualToString:@"ru"]) {
                _textSize = 1.0f; 
            } else
                if ([[Defs instance].currentLanguage isEqualToString:@"fr"]) {
                    _textSize = 0.9f; 
                } else
                    if ([[Defs instance].currentLanguage isEqualToString:@"de"]) {
                        _textSize = 0.8f; 
                    }else
                        if ([[Defs instance].currentLanguage isEqualToString:@"it"]) {
                            _textSize = 0.9f; 
                        }else
                            if ([[Defs instance].currentLanguage isEqualToString:@"es"]) {
                                _textSize = 1.0f; 
                            }else
                                if ([[Defs instance].currentLanguage isEqualToString:@"pt"]) {
                                    _textSize = 1.0f; 
                                }
		
		marketItem1Text = [[Defs instance].myFont textOutOutlined:ccp(280, 233) _str: NSLocalizedString(@"get 5 skips",@"")];
        [marketItem1Text setScale:_textSize];
		//[marketItem1Text setColor:ccc3(255, 255, 100)];
		//[marketItem1Text setAnchorPoint:ccp(0,0.5f)];
		[marketItem1Text retain];
		
		btnPlayDef.sprName = @"btnBuy15Up.png";
		btnPlayDef.sprDownName = @"btnBuy15Down.png";
		btnPlayDef.func = @selector(buttonBuyItem2Action);
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(134,170)];
		
		marketItem2Text = [[Defs instance].myFont textOutOutlined:ccp(280, 169) _str:NSLocalizedString(@"get 15 skips",@"")];
		//[marketItem2Text setColor:ccc3(255, 255, 100)];
		//[marketItem2Text setAnchorPoint:ccp(0,0.5f)];
        [marketItem2Text setScale:_textSize];
		[marketItem2Text retain];
		
		/*btnPlayDef.sprName = @"btnBuyInfinityUp.png";
		btnPlayDef.sprDownName = @"btnBuyInfinityDown.png";
		btnPlayDef.func = @selector(buttonBuyItem3Action);
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(SCREEN_WIDTH*0.27f,110)];
		
		marketItem3Text = [[Defs instance].myFont textOut:ccp(SCREEN_WIDTH*0.36f, 110) _str:@"infinity skips"];
		[marketItem3Text setColor:ccc3(255, 255, 100)];
		[marketItem3Text setAnchorPoint:ccp(0,0.5f)];
		[marketItem3Text retain];*/
        
        _textSize = 0.7f;
        
        if ([[Defs instance].currentLanguage isEqualToString:@"ru"]) {
            _textSize = 1.2f; 
        }else
        if ([[Defs instance].currentLanguage isEqualToString:@"de"]) {
            _textSize = 1.1f; 
        }else
            if ([[Defs instance].currentLanguage isEqualToString:@"pt"]) {
                _textSize = 0.7f; 
            }else
                if ([[Defs instance].currentLanguage isEqualToString:@"es"]) {
                    _textSize = 0.7f; 
                }
        
        btnPlayDef.sprName = @"btnGiftUp.png";
		btnPlayDef.sprDownName = @"btnGiftDown.png";
		btnPlayDef.func = @selector(buttonBuyAppAsGift);
		
		[[MainScene instance].gui addItem:(id)btnPlayDef _pos:ccp(134,50)];
        
		marketItem4Text = [[Defs instance].myFont textOutOutlined:ccp(287, 46) _str:NSLocalizedString(@"GIFT THIS APP",@"")];
		//[marketItem4Text setColor:ccc3(255, 255, 100)];
		//[marketItem4Text setAnchorPoint:ccp(0,0.5f)];
        [marketItem4Text setScale:_textSize];
		[marketItem4Text retain];
		
		/*marketTitleText = [[Defs instance].myFont textOut:ccp(SCREEN_WIDTH_HALF, 300) _str:@"Market"];
		[marketTitleText setColor:ccc3(255, 255, 255)];
		[marketTitleText retain];*/
		
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
		if (backSpr.parent == nil) [[Defs instance].objectFrontLayer addChild:backSpr];
		//if (marketTitleText.parent == nil) [backSpr addChild:marketTitleText];
		if (marketItem1Text.parent == nil) [[Defs instance].objectFrontLayer addChild:marketItem1Text];
		if (marketItem2Text.parent == nil) [[Defs instance].objectFrontLayer addChild:marketItem2Text];
		//if (marketItem3Text.parent == nil) [backSpr addChild:marketItem3Text];
        if (marketItem4Text.parent == nil) [[Defs instance].objectFrontLayer addChild:marketItem4Text];
	} else { 
		if (marketItem1Text.parent != nil) [marketItem1Text removeFromParentAndCleanup:YES];
		if (marketItem2Text.parent != nil) [marketItem2Text removeFromParentAndCleanup:YES];
		//if (marketItem3Text.parent != nil) [marketItem3Text removeFromParentAndCleanup:YES];
        if (marketItem4Text.parent != nil) [marketItem4Text removeFromParentAndCleanup:YES];
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
