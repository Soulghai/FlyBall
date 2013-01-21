//
//  Actor.m
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Boom.h"
#import "globalParam.h"
#import "Defs.h"
#import "MainScene.h"

@implementation Boom

@synthesize isActive;
@synthesize costume;

- (id) init{
	if ((self = [super init])) {		
		costume = nil;
		parentFrame = [Defs instance].spriteSheetChars;
		
		isVisible = NO;
        
        isActive = NO;
        
        delayShowing = 0.3f;
        
        [self load];
	}
	return self;
}

- (void) load{
    costume = [CCSprite spriteWithSpriteFrameName:@"boomShine.png"];
    [costume setScale:3.125f];
	[costume retain];
}

- (void) setPosition:(CGPoint)_pos
                  _z:(int)_z{
    [costume setPosition:_pos];
    
    zCoord = _z;
    
    positionCoeff = ccp(_pos.x - [MainScene instance].game.player.position.x, _pos.y - [MainScene instance].game.player.position.y);
}

- (void) update:(ccTime)dt {
	timeShowing += dt;
    if (timeShowing >= delayShowing) {
        [self deactivate];
        [self show:NO];
    } else {
        [costume setPosition:ccpAdd([MainScene instance].game.player.position, positionCoeff)];
    }
}

- (void) activate {
    isActive = YES;
    
    timeShowing = 0;
}

- (void) deactivate {
    isActive = NO;
}

- (void) outOfArea {

}

- (void) removeCostume {
	if (costume != nil) {
		if (costume.parent != nil) [costume removeFromParentAndCleanup:YES];
		[costume release];
		costume = nil;
	}
}

- (void) show:(BOOL)_flag {
	if ((isVisible == _flag)||(costume == nil)) return;
	
	if (_flag) {
		if ((isActive) && (!costume.parent)) {
            [parentFrame addChild:costume z:zCoord];
        } else return;
	}
	else
		if (costume.parent) [costume removeFromParentAndCleanup:YES];
	
	isVisible = _flag;
}

@end
