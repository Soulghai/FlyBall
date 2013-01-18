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

@implementation Boom

@synthesize itemID;
@synthesize isActive;
@synthesize costume;

- (id) init{
	if ((self = [super init])) {		
		[[Defs instance].actorManager add:self];
		costume = nil;
		parentFrame = nil;
		
		isVisible = NO;
        
        isActive = NO;
	}
	return self;
}

- (void) load{
    costume = [CCSprite spriteWithSpriteFrameName:@"btnPlay.png"];
	[costume retain];
}

- (void) update:(ccTime)dt {
	
}

- (void) activate {
    isActive = YES;
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
            [parentFrame addChild:costume];
        } else return;
	}
	else
		if (costume.parent) [costume removeFromParentAndCleanup:YES];
	
	isVisible = _flag;
}

@end
