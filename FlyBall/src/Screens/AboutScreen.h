//
//  AboutScreen.h
//  Expand_It
//
//  Created by Mac Mini on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIPanel.h"

@interface AboutScreen : CCNode {
	BOOL isVisible;
	CCSprite *backgroundSpr;
    GUIPanel *panelPalmLeft;
    GUIPanel *panelPalmRight;
    BOOL isPalmLeftGoUp;
    BOOL isPalmRightGoUp;
    GUIPanel *panelHighlight;
    
    NSMutableArray *creditsArr;
    float creditsMoveTime;
    float creditsMoveDelay;
}

- (id) init;
- (void) show:(BOOL)_flag;
- (void) update;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
- (void) dealloc;

@end