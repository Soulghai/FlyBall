//
//  GUIButton.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"
#import "GUIButtonDef.h"

@interface GUIButton : GUIItem {
	CCSprite *spr;
	NSString *sprDownName;
	int state;
	NSString *sound;
	SEL func;
	
	CGPoint endTouchPos;
	BOOL isBtnDown;
	float btnDownTime;
    
    BOOL isClickOnce;
    BOOL isManyTouches;
}

@property (nonatomic, retain) CCSprite *spr;

- (id) init:(id)_def;
- (void) show:(BOOL)_flag;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
- (void) setFunction:(SEL)_func;
@end
