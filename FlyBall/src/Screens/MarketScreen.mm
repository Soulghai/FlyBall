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
#import "MyData.h"

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

- (void) showPanelBuyInformation:(NSString*)_captionText
                _descriptionText:(NSString*)_descriptionText
                        _sprName:(NSString*)_sprName
                          _price:(NSString*)_price
                           _func:(SEL)_func {
    [panelBuyInformation show:YES];
    [btnPanelBuyInfoNO show:YES];
    [btnPanelBuyInfoNO setEnabled:YES];
    [btnPanelBuyInfoYES show:YES];
    [btnPanelBuyInfoYES setEnabled:YES];
    [btnPanelBuyInfoYES setFunction:_func];
    [labelPanelBuyInfoCaption show:YES];
    [labelPanelBuyInfoCaption setText:_captionText];
    [labelPanelBuyInfoDescription show:YES];
    [labelPanelBuyInfoDescription setText:_descriptionText];
    [labelPanelBuyInfoPrice show:YES];
    [labelPanelBuyInfoPrice setText:_price];
    
    CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_sprName];
    [panelBuyInfoPicture.spr setDisplayFrame:_frame];
    [panelBuyInfoPicture show:YES];
}

- (void) panelBuyInformationHide {
    [panelBuyInformation show:NO];
    [btnPanelBuyInfoNO show:NO];
    [btnPanelBuyInfoYES show:NO];
    [btnPanelBuyInfoNO setEnabled:NO];
    [btnPanelBuyInfoYES setEnabled:NO];
    [labelPanelBuyInfoCaption show:NO];
    [labelPanelBuyInfoDescription show:NO];
    [labelPanelBuyInfoPrice show:NO];
    [panelBuyInfoPicture show:NO];
}

- (void) panelBuyInformationBtnYesAction {
    
    
}

- (NSString*) getSpriteName:(NSString*)_str {
    return [_str substringToIndex:[_str length]-5];
}

- (void) setCorrectIconFrame:(GUIButton*)_btn
                      _level:(int)_level{
    CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                             [NSString stringWithFormat:@"%@%i.jpg", [self getSpriteName:_btn.sprName], _level]];
    [_btn.spr setDisplayFrame:_frame];
}

- (void) setCorrectIconFrames {
    [self setCorrectIconFrame:btnBonusAccelerationPower _level:[Defs instance].bonusAccelerationPowerLevel];
    [self setCorrectIconFrame:btnBonusAccelerationDelay _level:[Defs instance].bonusAccelerationDelayLevel];
    [self setCorrectIconFrame:btnBonusGetChance _level:[Defs instance].bonusGetChanceLevel];
    [self setCorrectIconFrame:btnBonusGodModeTime _level:[Defs instance].bonusGodModeTimeLevel];
}

//---------------------------------------------------
// Кнопки Улучшений
//---------------------------------------------------

- (void) buttonBuyBonusAccelerationPowerAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationPowerLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].bonusAccelerationPowerLevel;
        [MyData setStoreValue:@"bonusAccelerationPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationPowerLevel]];
        [Defs instance].bonusAccelerationPower += BONUS_ACCELERATION_POWER_ADD_COEFF;
        [MyData setStoreValue:@"bonusAccelerationPower" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationPower]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnBonusAccelerationPower _level:[Defs instance].bonusAccelerationPowerLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
    }
}

- (void) buttonBuyBonusAccelerationPowerClick {
    if ([Defs instance].bonusAccelerationPowerLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusAccelerationPowerCaption","")
                     _descriptionText:NSLocalizedString(@"buttonBuyBonusAccelerationPowerDescription","")
                             _sprName:[NSString stringWithFormat:@"%@%i.jpg", [self getSpriteName:btnBonusAccelerationPower.sprName], [Defs instance].bonusAccelerationPowerLevel]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationPowerLevel] intValue]]
                                _func:@selector(buttonBuyBonusAccelerationPowerAction)];
    }
}

- (void) buttonBuyBonusAccelerationDelayAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationDelayLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].bonusAccelerationDelayLevel;
        [MyData setStoreValue:@"bonusAccelerationDelayLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusAccelerationDelayLevel]];
        [Defs instance].bonusAccelerationDelay += BONUS_ACCELERATION_DELAY_ADD_COEFF;
        [MyData setStoreValue:@"bonusAccelerationDelay" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusAccelerationDelay]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnBonusAccelerationDelay _level:[Defs instance].bonusAccelerationDelayLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
    }
}

- (void) buttonBuyBonusAccelerationDelayClick {
    if ([Defs instance].bonusAccelerationDelayLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusAccelerationDelayCaption","")
                     _descriptionText:NSLocalizedString(@"buttonBuyBonusAccelerationDelayDescription","")
                             _sprName:[NSString stringWithFormat:@"%@%i.jpg", [self getSpriteName:btnBonusAccelerationDelay.sprName], [Defs instance].bonusAccelerationDelayLevel]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationDelayLevel] intValue]]
                                _func:@selector(buttonBuyBonusAccelerationDelayAction)];
    }
}

- (void) buttonBuyBonusGetChanceAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGetChanceLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].bonusGetChanceLevel;
        [MyData setStoreValue:@"bonusGetChanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGetChanceLevel]];
        [Defs instance].bonusGetChance += BONUS_GET_CHANCE_ADD_COEFF;
        [MyData setStoreValue:@"bonusGetChance" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGetChance]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnBonusGetChance _level:[Defs instance].bonusGetChanceLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
    }
}

- (void) buttonBuyBonusGetChanceClick {
    if ([Defs instance].bonusGetChanceLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusGetChanceCaption","")
                     _descriptionText:NSLocalizedString(@"buttonBuyBonusGetChanceDescription","")
                             _sprName:[NSString stringWithFormat:@"%@%i.jpg", [self getSpriteName:btnBonusGetChance.sprName], [Defs instance].bonusGetChanceLevel]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGetChanceLevel] intValue]]
                                _func:@selector(buttonBuyBonusGetChanceAction)];
    }
}

- (void) buttonBuyBonusGodModeTimeAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGodModeTimeLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].bonusGodModeTimeLevel;
        [MyData setStoreValue:@"bonusGodModeTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].bonusGodModeTimeLevel]];
        [Defs instance].bonusGodModeTime += BONUS_GODMODE_TIME_ADD_COEFF;
        [MyData setStoreValue:@"bonusGodModeTime" value:[NSString stringWithFormat:@"%f",[Defs instance].bonusGodModeTime]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnBonusGodModeTime _level:[Defs instance].bonusGodModeTimeLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
    }
}

- (void) buttonBuyBonusGodModeTimeClick {
    if ([Defs instance].bonusGodModeTimeLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyGodModeTimeCaption","")
                     _descriptionText:NSLocalizedString(@"buttonBuyGodModeTimeDescription","")
                             _sprName:[NSString stringWithFormat:@"%@%i.jpg", [self getSpriteName:btnBonusGodModeTime.sprName], [Defs instance].bonusGodModeTimeLevel]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGodModeTimeLevel] intValue]]
                                _func:@selector(buttonBuyBonusGodModeTimeAction)];
    }
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
		
        //-------------------------------------
        //   Окно покупки элемента
        //-------------------------------------
        
        float _panelX = SCREEN_WIDTH_HALF;
        float _panelY = SCREEN_HEIGHT_HALF;
        
        GUIPanelDef *_panelDef = [GUIPanelDef node];
        _panelDef.group = GAME_STATE_NONE;
        _panelDef.parentFrame = [MainScene instance];
        _panelDef.zOrder = 100;
        _panelDef.sprName = @"window_reset.png";
        
        panelBuyInformation = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(_panelX, _panelY)];
        
        float _panelWidth = panelBuyInformation.spr.contentSize.width;
        float _panelHeight = panelBuyInformation.spr.contentSize.height;
        
        _panelDef.parentFrame = panelBuyInformation.spr;
        _panelDef.zOrder = 0;
        _panelDef.sprName = @"icon_upgrade_0.jpg";
        panelBuyInfoPicture = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(37, _panelHeight - 37)];
        
        
        btnDef.group = GAME_STATE_NONE;
        btnDef.isManyTouches = YES;
		btnDef.sprName = @"btnNo.png";
		btnDef.sprDownName = @"btnNoDown.png";
		btnDef.parentFrame = panelBuyInformation.spr;
		btnDef.func = @selector(panelBuyInformationHide);
		btnDef.enabled = NO;
		
		btnPanelBuyInfoNO = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f-50, _panelHeight*0.25f)];
		
		btnDef.sprName = @"btnOk.png";
		btnDef.sprDownName = @"btnOkDown.png";
		btnDef.func = @selector(panelBuyInformationHide);
		
		btnPanelBuyInfoYES = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f+50, _panelHeight*0.25f)];
        
        
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_NONE;
        _labelTTFOutlinedDef.text = @"";
        labelPanelBuyInfoCaption = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX, _panelY + 100)];
        
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentCenter;
        _labelTTFOutlinedDef.containerSize = CGSizeMake(200, 150);
        labelPanelBuyInfoDescription = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX + 40, _panelY)];
        
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        _labelTTFOutlinedDef.containerSize = CGSizeZero;
        labelPanelBuyInfoPrice = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX - _panelWidth*0.5f + 15, _panelY - _panelHeight *0.5f+ 15)];
        
        
        //-------------------------------------
        //   Надписи на экране
        //-------------------------------------
        
        _labelTTFOutlinedDef.group = GAME_STATE_MARKETSCREEN;
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        _labelTTFOutlinedDef.text = @"Ship";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(5, 442)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        _labelTTFOutlinedDef.text = @"Bonuses";
        [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(315, 442)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        _labelTTFOutlinedDef.text = [NSString stringWithFormat:@"%i", [Defs instance].coinsCount];
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 0);
        labelCoinsCount = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(318, SCREEN_HEIGHT - 13)];
        
        
        btnDef.group = GAME_STATE_MARKETSCREEN;
        btnDef.parentFrame = [MainScene instance].gui;
        btnDef.enabled = YES;
        btnDef.isManyTouches = YES;
        
        // Корабль
        
        btnDef.sprName = @"icon_upgrade_0.jpg";
        btnDef.sprDownName = nil;
        btnDef.func = @selector(buttonBuyBonusAccelerationPowerClick);
        btnBonusAccelerationPower = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43, 390)];
        
        btnDef.func = @selector(buttonBuyBonusAccelerationDelayClick);
        btnBonusAccelerationDelay = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(121, 390)];
        
        btnDef.func = @selector(buttonBuyBonusGetChanceClick);
        btnBonusGetChance = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(199, 390)];
        
        btnDef.func = @selector(buttonBuyBonusGodModeTimeClick);
        btnBonusGodModeTime = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(277, 390)];
        
        
       /* for (int i = 0; i < 6; i++) {
            btnDef.sprName = [NSString stringWithFormat:@"icon_upgrade_%i.jpg",i];
            btnDef.sprDownName = nil;
            btnDef.func = @selector(buttonBuyItem1Action);
            
            
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43 + ((i % 2)*64) + (i % 2)*8, 400 - int(i / 2)*72)];
        }
        
        // Бонусы
        for (int i = 0; i < 6; i++) {
            btnDef.sprName = [NSString stringWithFormat:@"icon_upgrade_%i.jpg",5-i];
            btnDef.sprDownName = nil;
            btnDef.func = @selector(buttonBuyItem1Action);
            btnDef.isManyTouches = YES;
            
            [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(206 + ((i % 2)*64) + (i % 2)*8, 400 - int(i / 2)*72)];
        }*/
        
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
        
        [self setCorrectIconFrames];
        
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
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
