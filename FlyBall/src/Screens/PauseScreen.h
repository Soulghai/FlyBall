//
//  PauseScreen.h
//  Expand_It
//
//  Created by Mac Mini on 10.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUICheckBox.h"
#import "GUIButton.h"
#import "GUIPanel.h"
#import "GUILabel.h"

@interface PauseScreen : CCNode {
	BOOL isVisible;
	GUIPanel *backgroundSpr;
	
	GUIPanel *pauseZZZSpr;
	id pauseAction;
	GUICheckBox *btnSound;
    GUICheckBox *btnMusic;
    GUIButton *btnLevels;
    GUIButton *btnShop;
    GUIPanel *pauseHeroZZZ;
    //GUIButton *buttonPassLevel;
    //GUIPanel *panelFeaturePassLevelCounterIcon;
    //GUILabel *labelFeaturePassLevelCounterIcon;
    //GUIButton *btnCredits;
    //GUIPanel *panelMarket;
    //BOOL isPanelMarketOpacityAlpaAdd;
    //GLubyte panelMarketOpacity;
    
    //float marketGoSpeed;
    BOOL isShadowAnimationClose;
    BOOL isPauseHeroRotateRight;
}

//@property (nonatomic, retain) GUIButton *buttonPassLevel;
//@property (nonatomic, retain) GUILabel *labelFeaturePassLevelCounterIcon;
//@property (nonatomic, retain) GUIPanel *panelFeaturePassLevelCounterIcon;

- (id) init;
- (void) load;
- (void) show:(BOOL)_flag;
- (void) update;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
@end
