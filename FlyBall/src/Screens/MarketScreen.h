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
    GUILabelTTFOutlined* labelPanelBuyInfoDescription;
    GUILabelTTFOutlined* labelPanelBuyInfoPrice;
    
    GUILabelTTFOutlined* labelCoinsCount;
    
    GUIButton* btnBonusAccelerationPower;
    GUIButton* btnBonusAccelerationDelay;
    GUIButton* btnBonusGetChance;
    GUIButton* btnBonusGodModeTime;
}

- (id) init;
- (void) show:(BOOL)_flag;
- (void) update;
@end
