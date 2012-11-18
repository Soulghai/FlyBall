//
//  GUIPanel.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIPanel.h"
#import "GUIPanelDef.h"
#import "MainScene.h"

@implementation GUIPanel

@synthesize spr;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUIPanelDef *_tmpDef = (GUIPanelDef*)_def;
        sprName = _tmpDef.sprName;
        sprFileName = _tmpDef.sprFileName;
        if (_tmpDef.sprName != nil) spr = [CCSprite spriteWithSpriteFrameName:_tmpDef.sprName];
        else
            if (sprFileName != nil) spr = [CCSprite spriteWithFile:_tmpDef.sprFileName];
		[spr retain];
		parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
        zIndex = _tmpDef.zIndex;
        enabled = _tmpDef.enabled;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
    spr.position = ccp(_newPosition.x,_newPosition.y);
}

- (void) show:(BOOL)_flag {
	[super show:_flag];
	
    if (isVisible == _flag) return;
    
	if (_flag) {
		if (zIndex == INT16_MIN) [parentFrame addChild:spr]; else [parentFrame addChild:spr z:zIndex];
	} else {
		if (spr.parent) [spr removeFromParentAndCleanup:YES];
	}
    
    isVisible = _flag;
}

- (void) touchReaction:(CGPoint)_touchPos {	
	if (([MainScene instance].gui.isTouch != nil)||(!isVisible)||(!enabled)) return;
	CGPoint _windowPoint = [spr convertToWorldSpace:ccp(spr.contentSize.width*0.5f,spr.contentSize.height*0.5f)];
	if ((_touchPos.x > _windowPoint.x - spr.contentSize.width*0.5f)&&(_touchPos.x < _windowPoint.x + spr.contentSize.width*0.5f)
		&&(_touchPos.y > _windowPoint.y - spr.contentSize.height*0.5f)&&(_touchPos.y < _windowPoint.y + spr.contentSize.height*0.5f)){
		[MainScene instance].gui.isTouch = self;
	}
}

- (oneway void) release {
	if (spr) {
        [spr release];  
        spr = nil;
    }
}

@end
