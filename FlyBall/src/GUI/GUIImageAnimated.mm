//
//  GUIImageAnimated.m
//  Expand_It
//
//  Created by Mac Mini on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIImageAnimated.h"
#import "GUIImageAnimatedDef.h"

@implementation GUIImageAnimated

@synthesize spr;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUIImageAnimatedDef *_tmpDef = (GUIImageAnimatedDef*)_def;
		spr = [CCSprite spriteWithSpriteFrameName:_tmpDef.sprName];
		[spr retain];
		parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
    spr.position = ccp(_newPosition.x,_newPosition.y);
}

- (void) show:(BOOL)_flag {
	[super show:_flag];
	
    if (isVisible == _flag) return;
	
	isVisible = _flag;
    
	if (_flag) {
		if (zIndex == INT16_MIN) [parentFrame addChild:spr]; else [parentFrame addChild:spr z:zIndex];
	} else {
		if (spr.parent) [spr removeFromParentAndCleanup:YES];
	}
}

- (oneway void) release {
	if (spr) [spr release];
    spr = nil;
}

@end
