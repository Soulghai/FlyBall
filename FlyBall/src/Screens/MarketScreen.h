//
//  MarketScreen.h
//  Expand_It
//
//  Created by Mac Mini on 02.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIPanel.h"
#import "GUIButton.h"
#import "GUILabelTTFOutlined.h"

@interface MarketScreen : CCNode {
	BOOL isVisible;
	
	CCSprite *backSpr;
    GUIPanel* panelBuyInformation;
    GUIButton* btnPanelBuyInfoNO;
    GUIButton* btnPanelBuyInfoYES;
    GUIPanel* panelBuyInfoPicture;
    GUILabelTTFOutlined* labelPanelBuyInfoCaption;
    GUILabelTTFOutlined* labelPanelBuyInfoCurrValue;
    GUILabelTTFOutlined* labelPanelBuyInfoNextValue;
    GUILabelTTFOutlined* labelPanelBuyInfoPrice;
    
    GUIPanel* panelBuyCoins;
    GUIButton* btnPanelBuyCoinsNO;
    GUIButton* btnPanelBuyCoinsYES_1;
    GUIButton* btnPanelBuyCoinsYES_3;
    GUIButton* btnPanelBuyCoinsYES_5;
    GUILabelTTFOutlined* labelPanelBuyCoinsCaption;
    
    GUILabelTTFOutlined* labelCoinsCount;
    GUIPanel* panelCoinTotal;
    
    GUIButton* btnBonusAccelerationPower;
    GUIButton* btnBonusAccelerationDelay;
    GUIButton* btnBonusGetChance;
    GUIButton* btnCoinsGetChance;
    GUIButton* btnBonusGodModeTime;
    GUIButton* btnPlayerSpeedLimit;
    GUIButton* btnSpeedWallAccelerationCoeff;
    GUIButton* btnSpeedWallDeccelerationCoeff;
    GUIButton* btnPlayerMagnetDistance;
    GUIButton* btnPlayerMagnetPower;
    GUIButton* btnPlayerGodModeAfterCrashTime;
    GUIButton* btnPlayerBombSlow;
    GUIButton* btnPlayerArmor;
    GUIButton* btnLaunchBomb;
    
}

- (int) calcAvailableUpdatesCount;
- (id) init;
- (void) show:(BOOL)_flag;
- (void) update;
@end
