//
//  GUIButton.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIButton.h"
#import "SimpleAudioEngine.h"
#import "globalParam.h"
#import "MainScene.h"
#import "Defs.h"

@implementation GUIButton

@synthesize spr;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUIButtonDef *_tmpDef = (GUIButtonDef*)_def;
		sprName = _tmpDef.sprName;
		spr = [CCSprite spriteWithSpriteFrameName:sprName];
		[spr retain];
		sprDownName = _tmpDef.sprDownName;
		parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
		sound = _tmpDef.sound;
		objCreator = _tmpDef.objCreator;
		func = _tmpDef.func;
		enabled = _tmpDef.enabled;
        zIndex = _tmpDef.zIndex;
        isManyTouches = _tmpDef.isManyTouches;
		
		isBtnDown = NO;
		btnDownTime = 0;
	}
	return self;
}

- (void) setFunction:(SEL)_func {
    func = _func;
}

- (void) setPosition:(CGPoint)_newPosition {
    spr.position = ccp(_newPosition.x,_newPosition.y);
}

- (void) show:(BOOL)_flag {
	[super show:_flag];
    
    if (isVisible == _flag) return;
	
	isVisible = _flag;
	
	if (_flag) {
        isClickOnce = NO;
		if (spr.parent == nil) {
          if (zIndex == INT16_MIN) [parentFrame addChild:spr]; else [parentFrame addChild:spr z:zIndex];
        }
        if (isBtnDown) {
            isBtnDown = NO;
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprName];
            [spr setDisplayFrame:frame];
        }
	} else {
		if (spr.parent) [spr removeFromParentAndCleanup:YES];
	}
}

- (void) update {
	//страхуемся, если ccTouchEnded не сработал
	if (!isVisible) return;
	
	if (isBtnDown)
	/*&&((endTouchPos.x > btnPlay.position.x - btnPlay.contentSize.width*0.5)&&(endTouchPos.x < btnPlay.position.x + btnPlay.contentSize.width*0.5)
	 &&(endTouchPos.y > btnPlay.position.y - 20)&&(endTouchPos.y < btnPlay.position.y + 20)))*/{
		 btnDownTime += TIME_STEP;
		 if (btnDownTime >= BUTTON_DOWN_WAIT) {
			 if (sprDownName != nil) {
                 CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprName];
                 [spr setDisplayFrame:frame];
             }
			 isBtnDown = NO;
             isClickOnce = YES;
			 if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:sound];
			 [objCreator performSelector:func];
             CCLOG(@"[BUTTON CLICK-FUNC] %@", NSStringFromSelector(func));
		 }
	 }
}

- (void) touchReaction:(CGPoint)_touchPos {	
	if (([MainScene instance].gui.isTouch != nil)||(!isVisible)||(!enabled)||((isClickOnce)&&(!isManyTouches))) return;
	endTouchPos = CGPointMake(_touchPos.x, _touchPos.y);
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if ((_touchPos.x > _windowPoint.x - spr.contentSize.width*0.5f)&&(_touchPos.x < _windowPoint.x + spr.contentSize.width*0.5f)
		&&(_touchPos.y > _windowPoint.y - spr.contentSize.height*0.5f)&&(_touchPos.y < _windowPoint.y + spr.contentSize.height*0.5f)){
		[MainScene instance].gui.isTouch = self;
		isBtnDown = YES;
		if (sprDownName != nil) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprDownName];
            [spr setDisplayFrame:frame];
        }
		btnDownTime = 0;
	}
}

-(void) ccTouchEnded:(CGPoint)_touchPos {
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if ((isBtnDown)&&(_touchPos.x > _windowPoint.x - spr.contentSize.width*0.5f)&&(_touchPos.x < _windowPoint.x + spr.contentSize.width*0.5f)
		&&(_touchPos.y > _windowPoint.y - spr.contentSize.height*0.5f)&&(_touchPos.y < _windowPoint.y + spr.contentSize.height*0.5f)){
		if (sprDownName != nil) {
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprName];
            [spr setDisplayFrame:frame];
        }
		isBtnDown = NO;
        isClickOnce = YES;
		if (![Defs instance].isSoundMute) [[SimpleAudioEngine sharedEngine] playEffect:sound];
		[objCreator performSelector:func];
        CCLOG(@"[BUTTON CLICK-FUNC] %@", NSStringFromSelector(func));
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
            // Если меняли изображение на нажатое, то возвращаем обратно    
            if (sprDownName != nil) {
                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:sprName];
                [spr setDisplayFrame:frame];
            }
			isBtnDown = NO;
		} else {
			btnDownTime = 0;
		}
    }
}

- (void) dealloc {
	if (spr) [spr release];
    spr = nil;
	[super dealloc];
}

@end
