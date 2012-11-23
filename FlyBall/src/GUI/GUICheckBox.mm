//
//  GUICheckBox.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUICheckBox.h"
#import "GUICheckBoxDef.h"
#import "SimpleAudioEngine.h"
#import "globalParam.h"
#import "MainScene.h"
#import "Defs.h"

@implementation GUICheckBox

@synthesize spr;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUICheckBoxDef *_tmpDef = (GUICheckBoxDef*)_def;
		sprOneName = _tmpDef.sprName;
        sprOneDownName = _tmpDef.sprOneDownName; 
		sprTwoName = _tmpDef.sprTwoName;
		sprTwoDownName = _tmpDef.sprTwoDownName;
        parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
		sound = _tmpDef.sound;
		objCreator = _tmpDef.objCreator;
		func = _tmpDef.func;
		checked = _tmpDef.checked;
		enabled = _tmpDef.enabled;
        zIndex = _tmpDef.zIndex;
		
		if (checked)
			spr = [CCSprite spriteWithSpriteFrameName:sprTwoName];
		else
			spr = [CCSprite spriteWithSpriteFrameName:sprOneName];
		
		[spr retain];
		
		isBtnDown = NO;
		btnDownTime = 0;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
    spr.position = ccp(_newPosition.x,_newPosition.y);
}

- (void) setEnabled:(BOOL)_flag {
	enabled = _flag;
}

- (void) show:(BOOL)_flag {
	[super show:_flag];
	
    if (isVisible == _flag) return;
	
	isVisible = _flag;
    
	if (_flag) {
		if (zIndex == INT16_MIN) [parentFrame addChild:spr]; else [parentFrame addChild:spr z:zIndex];
        if (isBtnDown) {
            isBtnDown = NO;
            CCSpriteFrame *frame;
            if (checked) 
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprTwoName];
            else
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprOneName];
            [spr setDisplayFrame:frame];
        }
	} else {
		if (spr.parent) [spr removeFromParentAndCleanup:YES];
	}
}

- (void) update {
	if (!isVisible) return;
	//страхуемся, если ccTouchEnded не сработал
	if (isBtnDown)
	/*&&((endTouchPos.x > btnPlay.position.x - btnPlay.contentSize.width*0.5)&&(endTouchPos.x < btnPlay.position.x + btnPlay.contentSize.width*0.5)
	 &&(endTouchPos.y > btnPlay.position.y - 20)&&(endTouchPos.y < btnPlay.position.y + 20)))*/{
		 btnDownTime += TIME_STEP;
		 if (btnDownTime >= BUTTON_DOWN_WAIT) {
			 [self setChecked:!checked];
			 isBtnDown = NO;
			 if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:sound];
			 [objCreator performSelector:func];
             CCLOG(@"[CHECKBOX CLICK-FUNC] %@", NSStringFromSelector(func));
		 }
	 }
}

- (void) setChecked:(BOOL)_checked {
	checked = _checked;
	CCSpriteFrame *frame;
	if (checked) 
		frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprTwoName];
	else
		frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprOneName];
	[spr setDisplayFrame:frame];
}

- (void) touchReaction:(CGPoint)_touchPos {	
	if (([MainScene instance].gui.isTouch != nil)||(!isVisible)||(!enabled)) return;
	endTouchPos = CGPointMake(_touchPos.x, _touchPos.y);
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if ((_touchPos.x > _windowPoint.x - spr.contentSize.width*0.5f)&&(_touchPos.x < _windowPoint.x + spr.contentSize.width*0.5f)
		&&(_touchPos.y > _windowPoint.y - spr.contentSize.height*0.5f)&&(_touchPos.y < _windowPoint.y + spr.contentSize.height*0.5f)){
		[MainScene instance].gui.isTouch = self;
		isBtnDown = YES;
		btnDownTime = 0;
        
        CCSpriteFrame *frame = nil;
        if (checked) {
            if (sprTwoDownName != nil) frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprTwoDownName];
        }
        else {
            if (sprOneDownName != nil) frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprOneDownName];
        }
        if (frame != nil) [spr setDisplayFrame:frame];
	}
}

-(void) ccTouchEnded:(CGPoint)_touchPos {
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if ((isBtnDown)&&(_touchPos.x > _windowPoint.x - spr.contentSize.width*0.5f)&&(_touchPos.x < _windowPoint.x + spr.contentSize.width*0.5f)
		&&(_touchPos.y > _windowPoint.y - spr.contentSize.height*0.5f)&&(_touchPos.y < _windowPoint.y + spr.contentSize.height*0.5f)){
		[self setChecked:!checked];
		isBtnDown = NO;
		if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:sound];
		[objCreator performSelector:func];
        CCLOG(@"[CHECKBOX CLICK-FUNC] %@", NSStringFromSelector(func));
	}
}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation 
			   _diff:(CGPoint)_diff {
	endTouchPos = CGPointMake(_touchLocation.x, _touchLocation.y);
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if (isBtnDown) {
		if ((_touchLocation.x < _windowPoint.x - spr.contentSize.width*0.5f)||(_touchLocation.x > _windowPoint.x + spr.contentSize.width*0.5f)
			||(_touchLocation.y < _windowPoint.y - spr.contentSize.height*0.5f)||(_touchLocation.y > _windowPoint.y + spr.contentSize.height*0.5f)){
			CCSpriteFrame *frame;
			if (checked) 
				frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprTwoName];
			else
				frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprOneName];
			[spr setDisplayFrame:frame];
			isBtnDown = NO;
		} else {
			btnDownTime = 0;
		}
    }
}

- (oneway void) release {
	if (spr) [spr release];
    spr = nil;
}

@end
