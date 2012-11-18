//
//  GUICheckBox.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"

@interface GUICheckBox : GUIItem {
	CCSprite *spr;
	NSString *sprOneName;
	NSString *sprOneDownName;
	NSString *sprTwoName;
	NSString *sprTwoDownName;
	int state;
	NSString *sound;
	SEL func;
	BOOL checked;
	
	CGPoint endTouchPos;
	BOOL isBtnDown;
	float btnDownTime;
}

@property (nonatomic, retain) CCSprite *spr;

- (id) init:(id)_def;
- (void) show:(BOOL)_flag;
- (void) setChecked:(BOOL)_checked;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
@end
