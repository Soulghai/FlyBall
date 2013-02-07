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
#import "SimpleAudioEngine.h"

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
    else
        if ([MainScene instance].game.oldState == GAME_STATE_GAME)
            [[MainScene instance] showGamePause];
        else {
            [[MainScene instance] fromMarketToLevelFinishScreen];
        }
}

- (int) calcAvailableUpdatesCount {
    int _counter = 0;
    if (([Defs instance].bonusAccelerationDelayLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationDelayLevel] intValue])) ++_counter;
    if (([Defs instance].bonusAccelerationPowerLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].bonusAccelerationPowerLevel] intValue])) ++_counter;
    if (([Defs instance].bonusGetChanceLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGetChanceLevel] intValue])) ++_counter;
    if (([Defs instance].bonusGodModeTimeLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGodModeTimeLevel] intValue])) ++_counter;
    if (([Defs instance].coinsGetChanceLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].coinsGetChanceLevel] intValue])) ++_counter;
    if (([Defs instance].playerBombSlowLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerBombSlowLevel] intValue])) ++_counter;
    if (([Defs instance].playerGodModeAfterCrashTimeLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerGodModeAfterCrashTimeLevel] intValue])) ++_counter;
    if (([Defs instance].playerMagnetDistanceLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetDistanceLevel] intValue])) ++_counter;
    if (([Defs instance].playerMagnetPowerLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetPowerLevel] intValue])) ++_counter;
    if (([Defs instance].playerSpeedLimitLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerSpeedLimitLevel] intValue])) ++_counter;
    if (([Defs instance].speedWallAccelerationCoeffLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallAccelerationCoeffLevel] intValue])) ++_counter;
    if (([Defs instance].speedWallDeccelerationCoeffLevel < UPGRADE_LEVEL_COUNT)
         &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallDeccelerationCoeffLevel] intValue])) ++_counter;
    if (([Defs instance].playerArmorLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].playerArmorLevel] intValue])) ++_counter;
    if (([Defs instance].launchBombLevel < UPGRADE_LEVEL_COUNT)
        &&([Defs instance].coinsCount >= [[[Defs instance].prices objectAtIndex:[Defs instance].launchBombLevel] intValue])) ++_counter;
    
    return _counter;
}

- (void) allUpgradeIconsSetEnabled:(BOOL)_flag {
    [btnBonusAccelerationDelay setEnabled:_flag];
    [btnBonusAccelerationPower setEnabled:_flag];
    [btnBonusGetChance setEnabled:_flag];
    [btnBonusGodModeTime setEnabled:_flag];
    [btnPlayerSpeedLimit setEnabled:_flag];
    [btnSpeedWallAccelerationCoeff setEnabled:_flag];
    [btnSpeedWallDeccelerationCoeff setEnabled:_flag];
    [btnPlayerMagnetPower setEnabled:_flag];
    [btnPlayerMagnetDistance setEnabled:_flag];
    [btnPlayerBombSlow setEnabled:_flag];
    [btnPlayerGodModeAfterCrashTime setEnabled:_flag];
    [btnCoinsGetChance setEnabled:_flag];
    [btnPlayerArmor setEnabled:_flag];
    [btnLaunchBomb setEnabled:_flag];
    
}

- (void) buyCoinsPanelShow {
    [panelBuyCoins show:YES];
    [btnPanelBuyCoinsNO show:YES];
    [btnPanelBuyCoinsYES_1 show:YES];
    [btnPanelBuyCoinsYES_3 show:YES];
    [btnPanelBuyCoinsYES_5 show:YES];
    [labelPanelBuyCoinsCaption show:YES];
    [self allUpgradeIconsSetEnabled:NO];
}

- (void) buyCoinsPanelHide {
    [panelBuyCoins show:NO];
    [btnPanelBuyCoinsNO show:NO];
    [btnPanelBuyCoinsYES_1 show:NO];
    [btnPanelBuyCoinsYES_3 show:NO];
    [btnPanelBuyCoinsYES_5 show:NO];
    [labelPanelBuyCoinsCaption show:NO];
    [self allUpgradeIconsSetEnabled:YES];
}

- (void) buyCoinsAtOneDollar {
    [Defs instance].coinsCount += 100;
    [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    [self buyCoinsPanelHide];
    if (![Defs instance].isSoundMute) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"buy_coins.wav"];
    }
}

- (void) buyCoinsAtThreeDollars {
    [Defs instance].coinsCount += 250;
    [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];;
    [self buyCoinsPanelHide];
    if (![Defs instance].isSoundMute) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"buy_coins.wav"];
    }
}

- (void) buyCoinsAtFiveDollars {
    [Defs instance].coinsCount += 400;
    [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
    [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    [self buyCoinsPanelHide];
    if (![Defs instance].isSoundMute) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"buy_coins.wav"];
    }
}

- (void) showPanelBuyInformation:(NSString*)_captionText
                _currValueText:(NSString*)_currValueText
                  _nextValueText:(NSString*)_nextValueText
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
    [labelPanelBuyInfoCurrValue show:YES];
    [labelPanelBuyInfoCurrValue setText:_currValueText];
    [labelPanelBuyInfoNextValue show:YES];
    [labelPanelBuyInfoNextValue setText:_nextValueText];
    [labelPanelBuyInfoPrice show:YES];
    [labelPanelBuyInfoPrice setText:_price];
    
    CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_sprName];
    [panelBuyInfoPicture.spr setDisplayFrame:_frame];
    [panelBuyInfoPicture show:YES];
    
    [self allUpgradeIconsSetEnabled:NO];
}

- (void) panelBuyInformationHide {
    [panelBuyInformation show:NO];
    [btnPanelBuyInfoNO show:NO];
    [btnPanelBuyInfoYES show:NO];
    [btnPanelBuyInfoNO setEnabled:NO];
    [btnPanelBuyInfoYES setEnabled:NO];
    [labelPanelBuyInfoCaption show:NO];
    [labelPanelBuyInfoCurrValue show:NO];
    [labelPanelBuyInfoNextValue show:NO];
    [labelPanelBuyInfoPrice show:NO];
    [panelBuyInfoPicture show:NO];
    
    [self allUpgradeIconsSetEnabled:YES];
}

- (NSString*) getSpriteName:(NSString*)_str {
    return [_str substringToIndex:[_str length]-5];
}

- (void) setCorrectIconFrame:(GUIButton*)_btn
                      _level:(int)_level{
    CCSpriteFrame *_frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                             [NSString stringWithFormat:@"%@%i.png", [self getSpriteName:_btn.sprName], _level+1]];
    [_btn.spr setDisplayFrame:_frame];
}

- (void) setCorrectIconFrames {
    [self setCorrectIconFrame:btnBonusAccelerationPower _level:[Defs instance].bonusAccelerationPowerLevel];
    [self setCorrectIconFrame:btnBonusAccelerationDelay _level:[Defs instance].bonusAccelerationDelayLevel];
    [self setCorrectIconFrame:btnBonusGetChance _level:[Defs instance].bonusGetChanceLevel];
    [self setCorrectIconFrame:btnBonusGodModeTime _level:[Defs instance].bonusGodModeTimeLevel];
    [self setCorrectIconFrame:btnPlayerSpeedLimit _level:[Defs instance].playerSpeedLimitLevel];
    [self setCorrectIconFrame:btnSpeedWallAccelerationCoeff _level:[Defs instance].speedWallAccelerationCoeffLevel];
    [self setCorrectIconFrame:btnSpeedWallDeccelerationCoeff _level:[Defs instance].speedWallDeccelerationCoeffLevel];
    [self setCorrectIconFrame:btnPlayerMagnetDistance _level:[Defs instance].playerMagnetDistanceLevel];
    [self setCorrectIconFrame:btnPlayerMagnetPower _level:[Defs instance].playerMagnetPowerLevel];
    [self setCorrectIconFrame:btnPlayerBombSlow _level:[Defs instance].playerBombSlowLevel];
    [self setCorrectIconFrame:btnPlayerGodModeAfterCrashTime _level:[Defs instance].playerGodModeAfterCrashTimeLevel];
    [self setCorrectIconFrame:btnCoinsGetChance _level:[Defs instance].coinsGetChanceLevel];
    [self setCorrectIconFrame:btnPlayerArmor _level:[Defs instance].playerArmorLevel];
    [self setCorrectIconFrame:btnLaunchBomb _level:[Defs instance].launchBombLevel];
    
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
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy some coins??? :)");
        
        [self buyCoinsPanelShow];
        
    }
}

- (void) buttonBuyBonusAccelerationPowerClick {
    if ([Defs instance].bonusAccelerationPowerLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusAccelerationPowerCaption","")
                     _currValueText:[NSString stringWithFormat:@"%@ = %1.1f", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].bonusAccelerationPower]
                     _nextValueText:[NSString stringWithFormat:@"%@ = %1.1f", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].bonusAccelerationPower + BONUS_ACCELERATION_POWER_ADD_COEFF]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnBonusAccelerationPower.sprName], [Defs instance].bonusAccelerationPowerLevel+1]
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
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyBonusAccelerationDelayClick {
    if ([Defs instance].bonusAccelerationDelayLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusAccelerationDelayCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].bonusAccelerationDelay]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].bonusAccelerationDelay + BONUS_ACCELERATION_DELAY_ADD_COEFF]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnBonusAccelerationDelay.sprName], [Defs instance].bonusAccelerationDelayLevel+1]
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
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyBonusGetChanceClick {
    if ([Defs instance].bonusGetChanceLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyBonusGetChanceCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyCurrValue",""), int(100*[Defs instance].bonusGetChance)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyNextValue",""), int(100*([Defs instance].bonusGetChance + BONUS_GET_CHANCE_ADD_COEFF))]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnBonusGetChance.sprName], [Defs instance].bonusGetChanceLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGetChanceLevel] intValue]]
                                _func:@selector(buttonBuyBonusGetChanceAction)];
    }
}

- (void) buttonBuyCoinsGetChanceAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].coinsGetChanceLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].coinsGetChanceLevel;
        [MyData setStoreValue:@"coinsGetChanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsGetChanceLevel]];
        [Defs instance].coinsGetChance += COINS_GET_CHANCE_ADD_COEFF;
        [MyData setStoreValue:@"coinsGetChance" value:[NSString stringWithFormat:@"%f",[Defs instance].coinsGetChance]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnCoinsGetChance _level:[Defs instance].coinsGetChanceLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyCoinsGetChanceClick {
    if ([Defs instance].coinsGetChanceLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyCoinsGetChanceCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyCurrValue",""), int(100*[Defs instance].coinsGetChance)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyNextValue",""), int(100*([Defs instance].coinsGetChance + COINS_GET_CHANCE_ADD_COEFF))]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnCoinsGetChance.sprName], [Defs instance].coinsGetChanceLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].coinsGetChanceLevel] intValue]]
                                _func:@selector(buttonBuyCoinsGetChanceAction)];
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
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyBonusGodModeTimeClick {
    if ([Defs instance].bonusGodModeTimeLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyGodModeTimeCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].bonusGodModeTime]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].bonusGodModeTime + BONUS_GODMODE_TIME_ADD_COEFF]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnBonusGodModeTime.sprName], [Defs instance].bonusGodModeTimeLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].bonusGodModeTimeLevel] intValue]]
                                _func:@selector(buttonBuyBonusGodModeTimeAction)];
    }
}

- (void) buttonBuyPlayerSpeedLimitAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerSpeedLimitLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerSpeedLimitLevel;
        [MyData setStoreValue:@"playerSpeedLimitLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerSpeedLimitLevel]];
        [Defs instance].playerSpeedLimit += PLAYER_SPEED_LIMIT_ADD_COEFF;
        [MyData setStoreValue:@"playerSpeedLimit" value:[NSString stringWithFormat:@"%f",[Defs instance].playerSpeedLimit]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerSpeedLimit _level:[Defs instance].playerSpeedLimitLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyPlayerSpeedLimitClick {
    if ([Defs instance].playerSpeedLimitLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerSpeedLimitCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyCurrValue",""), int([Defs instance].playerSpeedLimit)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyNextValue",""), int(([Defs instance].playerSpeedLimit + PLAYER_SPEED_LIMIT_ADD_COEFF))]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerSpeedLimit.sprName], [Defs instance].playerSpeedLimitLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerSpeedLimitLevel] intValue]]
                                _func:@selector(buttonBuyPlayerSpeedLimitAction)];
    }
}

- (void) buttonBuySpeedWallAccelerationCoeffAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallAccelerationCoeffLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].speedWallAccelerationCoeffLevel;
        [MyData setStoreValue:@"speedWallAccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallAccelerationCoeffLevel]];
        [Defs instance].speedWallAccelerationCoeff += SPEEDWALL_ACCELERATION_ADD_COEFF;
        [MyData setStoreValue:@"speedWallAccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallAccelerationCoeff]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnSpeedWallAccelerationCoeff _level:[Defs instance].speedWallAccelerationCoeffLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuySpeedWallAccelerationCoeffClick {
    if ([Defs instance].speedWallAccelerationCoeffLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuySpeedWallAccelerationCoeffCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %1.2f sec", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].speedWallAccelerationCoeff]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %1.2f sec", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].speedWallAccelerationCoeff + SPEEDWALL_ACCELERATION_ADD_COEFF]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnSpeedWallAccelerationCoeff.sprName], [Defs instance].speedWallAccelerationCoeffLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallAccelerationCoeffLevel] intValue]]
                                _func:@selector(buttonBuySpeedWallAccelerationCoeffAction)];
    }
}

- (void) buttonBuySpeedWallDeccelerationCoeffAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallDeccelerationCoeffLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].speedWallDeccelerationCoeffLevel;
        [MyData setStoreValue:@"speedWallDeccelerationCoeffLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].speedWallDeccelerationCoeffLevel]];
        [Defs instance].speedWallDeccelerationCoeff += SPEEDWALL_DECCELERARION_ADD_COEFF;
        [MyData setStoreValue:@"speedWallDeccelerationCoeff" value:[NSString stringWithFormat:@"%f",[Defs instance].speedWallDeccelerationCoeff]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnSpeedWallDeccelerationCoeff _level:[Defs instance].speedWallDeccelerationCoeffLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuySpeedWallDeccelerationCoeffClick {
    if ([Defs instance].speedWallDeccelerationCoeffLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuySpeedWallDeccelerationCoeffCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i sec", NSLocalizedString(@"buttonBuyCurrValue",""), int(100*[Defs instance].speedWallDeccelerationCoeff)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i sec", NSLocalizedString(@"buttonBuyNextValue",""), int(100*([Defs instance].speedWallDeccelerationCoeff + SPEEDWALL_DECCELERARION_ADD_COEFF))]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnSpeedWallDeccelerationCoeff.sprName], [Defs instance].speedWallDeccelerationCoeffLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].speedWallDeccelerationCoeffLevel] intValue]]
                                _func:@selector(buttonBuySpeedWallDeccelerationCoeffAction)];
    }
}

- (void) buttonBuyPlayerMagnetDistanceAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetDistanceLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerMagnetDistanceLevel;
        [MyData setStoreValue:@"playerMagnetDistanceLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistanceLevel]];
        [Defs instance].playerMagnetDistance += PLAYER_MAGNET_DISTANDE_ADD_COEFF;
        [MyData setStoreValue:@"playerMagnetDistance" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetDistance]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerMagnetDistance _level:[Defs instance].playerMagnetDistanceLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyPlayerMagnetDistanceClick {
    if ([Defs instance].playerMagnetDistanceLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerMagnetDistanceCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyCurrValue",""), int(100*([Defs instance].playerMagnetDistance/PLAYER_MAGNET_DISTANDE_ADD_COEFF))]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i%%", NSLocalizedString(@"buttonBuyNextValue",""), int(100*(([Defs instance].playerMagnetDistance+PLAYER_MAGNET_DISTANDE_ADD_COEFF)/PLAYER_MAGNET_DISTANDE_ADD_COEFF))]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerMagnetDistance.sprName], [Defs instance].playerMagnetDistanceLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetDistanceLevel] intValue]]
                                _func:@selector(buttonBuyPlayerMagnetDistanceAction)];
    }
}

- (void) buttonBuyPlayerMagnetPowerAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetPowerLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerMagnetPowerLevel;
        [MyData setStoreValue:@"playerMagnetPowerLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerMagnetPowerLevel]];
        [Defs instance].playerMagnetPower += PLAYER_MAGNET_POWER_ADD_COEFF;
        [MyData setStoreValue:@"playerMagnetPower" value:[NSString stringWithFormat:@"%f",[Defs instance].playerMagnetPower]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerMagnetPower _level:[Defs instance].playerMagnetPowerLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyPlayerMagnetPowerClick {
    if ([Defs instance].playerMagnetPowerLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerMagnetPowerCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyCurrValue",""), int([Defs instance].playerMagnetPower)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyNextValue",""), int([Defs instance].playerMagnetPower + PLAYER_MAGNET_POWER_ADD_COEFF)]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerMagnetPower.sprName], [Defs instance].playerMagnetPowerLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerMagnetPowerLevel] intValue]]
                                _func:@selector(buttonBuyPlayerMagnetPowerAction)];
    }
}

- (void) buttonBuyPlayerBombSlowAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerBombSlowLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerBombSlowLevel;
        [MyData setStoreValue:@"playerBombSlowLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerBombSlowLevel]];
        [Defs instance].playerBombSlow += PLAYER_BOMB_SLOW_ADD_COEFF;
        [MyData setStoreValue:@"playerBombSlow" value:[NSString stringWithFormat:@"%f",[Defs instance].playerBombSlow]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerBombSlow _level:[Defs instance].playerBombSlowLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyPlayerBombSlowClick {
    if ([Defs instance].playerBombSlowLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerBombSlowCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].playerBombSlow]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].playerBombSlow + PLAYER_BOMB_SLOW_ADD_COEFF]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerBombSlow.sprName], [Defs instance].playerBombSlowLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerBombSlowLevel] intValue]]
                                _func:@selector(buttonBuyPlayerBombSlowAction)];
    }
}

- (void) buttonBuyPlayerGodModeAfterCrashTimeAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerGodModeAfterCrashTimeLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerGodModeAfterCrashTimeLevel;
        [MyData setStoreValue:@"playerGodModeAfterCrashTimeLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerGodModeAfterCrashTimeLevel]];
        [Defs instance].playerGodModeAfterCrashTime += GODMODE_AFTERCRASH_TIME_ADD_COEFF;
        [MyData setStoreValue:@"playerGodModeAfterCrashTime" value:[NSString stringWithFormat:@"%f",[Defs instance].playerGodModeAfterCrashTime]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerGodModeAfterCrashTime _level:[Defs instance].playerGodModeAfterCrashTimeLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy soom coins??? :)");
        [self buyCoinsPanelShow];
    }
}

- (void) buttonBuyPlayerGodModeAfterCrashTimeClick {
    if ([Defs instance].playerGodModeAfterCrashTimeLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerGodModeAfterCrashTimeCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyCurrValue",""), ([Defs instance].playerGodModeAfterCrashTime)]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %1.1f sec", NSLocalizedString(@"buttonBuyNextValue",""), ([Defs instance].playerGodModeAfterCrashTime + GODMODE_AFTERCRASH_TIME_ADD_COEFF)]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerGodModeAfterCrashTime.sprName], [Defs instance].playerGodModeAfterCrashTimeLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerGodModeAfterCrashTimeLevel] intValue]]
                                _func:@selector(buttonBuyPlayerGodModeAfterCrashTimeAction)];
    }
}

- (void) buttonBuyPlayerArmorAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].playerArmorLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].playerArmorLevel;
        [MyData setStoreValue:@"playerArmorLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].playerArmorLevel]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnPlayerArmor _level:[Defs instance].playerArmorLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy some coins??? :)");
        
        [self buyCoinsPanelShow];
        
    }
}

- (void) buttonBuyPlayerArmorClick {
    if ([Defs instance].playerArmorLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyPlayerArmorLevelCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].playerArmorLevel]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].playerArmorLevel + 1]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnPlayerArmor.sprName], [Defs instance].playerArmorLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].playerArmorLevel] intValue]]
                                _func:@selector(buttonBuyPlayerArmorAction)];
    }
}

- (void) buttonBuyLaunchBombLevelAction {
    [self panelBuyInformationHide];
    
    int _price = [[[Defs instance].prices objectAtIndex:[Defs instance].launchBombLevel] intValue];
    
    if ([Defs instance].coinsCount > _price) {
        ++[Defs instance].launchBombLevel;
        [MyData setStoreValue:@"launchBombLevel" value:[NSString stringWithFormat:@"%i",[Defs instance].launchBombLevel]];
        [Defs instance].coinsCount -= _price;
        [MyData setStoreValue:@"coinsCount" value:[NSString stringWithFormat:@"%i",[Defs instance].coinsCount]];
        [MyData encodeDict:[MyData getDictForSaveData]];
        
        [self setCorrectIconFrame:btnLaunchBomb _level:[Defs instance].launchBombLevel];
        [labelCoinsCount setText:[NSString stringWithFormat:@"%i", [Defs instance].coinsCount]];
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
    } else {
        CCLOG(@"Maybe buy some coins??? :)");
        
        [self buyCoinsPanelShow];
        
    }
}

- (void) buttonBuyLaunchBombLevelClick {
    if ([Defs instance].launchBombLevel < UPGRADE_LEVEL_COUNT) {
        [self showPanelBuyInformation:NSLocalizedString(@"buttonBuyLaunchBombLevelCaption","")
                       _currValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyCurrValue",""), [Defs instance].launchBombLevel]
                       _nextValueText:[NSString stringWithFormat:@"%@ = %i", NSLocalizedString(@"buttonBuyNextValue",""), [Defs instance].launchBombLevel + 1]
                             _sprName:[NSString stringWithFormat:@"%@%i.png", [self getSpriteName:btnLaunchBomb.sprName], [Defs instance].launchBombLevel+1]
                               _price:[NSString stringWithFormat:@"%i", [[[Defs instance].prices objectAtIndex:[Defs instance].launchBombLevel] intValue]]
                                _func:@selector(buttonBuyLaunchBombLevelAction)];
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
        _panelDef.sprName = @"window_upgrade.png";
        
        panelBuyInformation = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(_panelX, _panelY)];
        
        _panelDef.sprName = @"window_get_money.png";
        panelBuyCoins = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(_panelX, _panelY)];
        
        float _panelWidth = panelBuyInformation.spr.contentSize.width;
        float _panelHeight = panelBuyInformation.spr.contentSize.height;
        
        _panelDef.parentFrame = panelBuyInformation.spr;
        _panelDef.zOrder = 0;
        _panelDef.sprName = @"Upgrade_1_1.png";
        panelBuyInfoPicture = [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(37, _panelHeight - 65)];
        
        
        btnDef.group = GAME_STATE_NONE;
        btnDef.isManyTouches = YES;
		btnDef.sprName = @"btnNo.png";
		btnDef.sprDownName = @"btnNoDown.png";
		btnDef.parentFrame = panelBuyInformation.spr;
		btnDef.func = @selector(panelBuyInformationHide);
		
		btnPanelBuyInfoNO = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f-50, _panelHeight*0.25f)];
		
		btnDef.sprName = @"btnOk.png";
		btnDef.sprDownName = @"btnOkDown.png";
		btnDef.func = @selector(panelBuyInformationHide);
        btnDef.sound = @"buy_upgrade.wav";
		
		btnPanelBuyInfoYES = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f+50, _panelHeight*0.25f)];
        
        // buyCoinsPanel
        btnDef.parentFrame = panelBuyCoins.spr;
        btnDef.sprName = @"btnNo.png";
		btnDef.sprDownName = @"btnNoDown.png";
		btnDef.func = @selector(buyCoinsPanelHide);
        btnDef.sound = @"click.wav";
		
		btnPanelBuyCoinsNO = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth-15, _panelHeight - 15)];
        [btnPanelBuyCoinsNO.spr setScale:0.5f];
		
		btnDef.sprName = @"btnBuy100.png";
		btnDef.sprDownName = @"btnBuy100Down.png";
		btnDef.func = @selector(buyCoinsAtOneDollar);
		
		btnPanelBuyCoinsYES_1 = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f - 90, _panelHeight*0.4f)];
        
        btnDef.sprName = @"btnBuy250.png";
		btnDef.sprDownName = @"btnBuy250Down.png";
		btnDef.func = @selector(buyCoinsAtThreeDollars);
		
		btnPanelBuyCoinsYES_3 = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f, _panelHeight*0.4f)];
        
        btnDef.sprName = @"btnBuy400.png";
		btnDef.sprDownName = @"btnBuy400Down.png";
		btnDef.func = @selector(buyCoinsAtFiveDollars);
		
		btnPanelBuyCoinsYES_5 = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(_panelWidth*0.5f + 90, _panelHeight*0.4f)];
        
        
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_NONE;
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.fontSize = 16;
        labelPanelBuyInfoCaption = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX, _panelY + 63)];
        
        _labelTTFOutlinedDef.fontSize = 20;
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        labelPanelBuyInfoCurrValue = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX + _panelWidth*0.5f - 10, _panelY + 33)];
        
        _labelTTFOutlinedDef.textColor = ccc3(0, 255, 0);
        labelPanelBuyInfoNextValue = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX + _panelWidth*0.5f - 10, _panelY + 8)];

        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 255);
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        _labelTTFOutlinedDef.containerSize = CGSizeZero;
        labelPanelBuyInfoPrice = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX, _panelY - _panelHeight *0.5f + 35)];
        
        _panelDef.group = GAME_STATE_MARKETSCREEN;
        _panelDef.parentFrame = panelBuyInformation.spr;
        _panelDef.zOrder = 0;
        _panelDef.sprName = @"gui_coin.png";
        [[MainScene instance].gui addItem:(id)_panelDef _pos:ccp(_panelWidth*0.5f - 12, 38)];
        
        
        // buyCoinsPanel
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentCenter;
        _labelTTFOutlinedDef.text = NSLocalizedString(@"panelBuyCoinsCaption","");
        labelPanelBuyCoinsCaption = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(_panelX, _panelY + 48)];
        
        //-------------------------------------
        //   Надписи на экране
        //-------------------------------------
        
        _labelTTFOutlinedDef.group = GAME_STATE_MARKETSCREEN;
        //_labelTTFOutlinedDef.alignement = kCCTextAlignmentLeft;
        //_labelTTFOutlinedDef.text = @"Ship";
        //[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(5, 442)];
        
        //_labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        //_labelTTFOutlinedDef.text = @"Bonuses";
        //[[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(315, 442)];
        
        _labelTTFOutlinedDef.alignement = kCCTextAlignmentRight;
        _labelTTFOutlinedDef.text = [NSString stringWithFormat:@"%i", [Defs instance].coinsCount];
        _labelTTFOutlinedDef.textColor = ccc3(255, 255, 0);
        labelCoinsCount = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:ccp(318, SCREEN_HEIGHT - 13)];
        
        _panelDef.group = GAME_STATE_MARKETSCREEN;
        _panelDef.parentFrame = [MainScene instance].gui;
        _panelDef.zOrder = 0;
        _panelDef.sprName = @"gui_coin.png";
        panelCoinTotal = [[MainScene instance].gui addItem:(id)_panelDef _pos:CGPointZero];
        
        
        btnDef.group = GAME_STATE_MARKETSCREEN;
        btnDef.parentFrame = [MainScene instance].gui;
        btnDef.isManyTouches = YES;
        
        // Корабль
        btnDef.sprName = @"Upgrade_1_1.png";
        btnDef.sprDownName = nil;
        btnDef.func = @selector(buttonBuyPlayerArmorClick);
        btnPlayerArmor = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43, 390)];
        
        btnDef.sprName = @"Upgrade_2_1.png";
        btnDef.func = @selector(buttonBuyPlayerSpeedLimitClick);
        btnPlayerSpeedLimit = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(121, 390)];
        
        btnDef.sprName = @"Upgrade_3_1.png";
        btnDef.func = @selector(buttonBuyBonusAccelerationDelayClick);
        btnBonusAccelerationDelay = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(199, 390)];
        
        btnDef.sprName = @"Upgrade_4_1.png";
        btnDef.sprDownName = nil;
        btnDef.func = @selector(buttonBuyBonusAccelerationPowerClick);
        btnBonusAccelerationPower = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(277, 390)];
        
        btnDef.sprName = @"Upgrade_14_1.png";
        btnDef.func = @selector(buttonBuyBonusGetChanceClick);
        btnBonusGetChance = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43, 156)];
        
        btnDef.sprName = @"Upgrade_6_1.png";
        btnDef.func = @selector(buttonBuyBonusGodModeTimeClick);
        btnBonusGodModeTime = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(199, 312)];
        
        btnDef.sprName = @"Upgrade_7_1.png";
        btnDef.func = @selector(buttonBuySpeedWallAccelerationCoeffClick);
        btnSpeedWallAccelerationCoeff = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43, 312)];
        
        btnDef.sprName = @"Upgrade_8_1.png";
        btnDef.func = @selector(buttonBuySpeedWallDeccelerationCoeffClick);
        btnSpeedWallDeccelerationCoeff = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(121, 312)];
        
        btnDef.sprName = @"Upgrade_9_1.png";
        btnDef.func = @selector(buttonBuyPlayerMagnetDistanceClick);
        btnPlayerMagnetDistance = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(121, 234)];
        
        btnDef.sprName = @"Upgrade_10_1.png";
        btnDef.func = @selector(buttonBuyPlayerMagnetPowerClick);
        btnPlayerMagnetPower = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(43, 234)];
        
        btnDef.sprName = @"Upgrade_11_1.png";
        btnDef.func = @selector(buttonBuyPlayerGodModeAfterCrashTimeClick);
        btnPlayerGodModeAfterCrashTime = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(277, 312)];
        
        btnDef.sprName = @"Upgrade_12_1.png";
        btnDef.func = @selector(buttonBuyPlayerBombSlowClick);
        btnPlayerBombSlow = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(199, 234)];
        
        btnDef.sprName = @"Upgrade_13_1.png";
        btnDef.func = @selector(buttonBuyCoinsGetChanceClick);
        btnCoinsGetChance = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(277, 234)];
        
        btnDef.sprName = @"Upgrade_5_1.png";
        btnDef.func = @selector(buttonBuyLaunchBombLevelClick);
        btnLaunchBomb = [[MainScene instance].gui addItem:(id)btnDef _pos:ccp(121, 156)];
		
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
        [panelCoinTotal setPosition:ccp(labelCoinsCount.spr.position.x - labelCoinsCount.text.length*6 - panelCoinTotal.spr.contentSize.width*0.5f, labelCoinsCount.spr.position.y+3)];
        
        [self allUpgradeIconsSetEnabled:YES];
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
