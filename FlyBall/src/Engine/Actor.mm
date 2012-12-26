//
//  Actor.m
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "Actor.h"
#import "globalParam.h"
#import "Defs.h"

@implementation Actor

@synthesize itemID;
@synthesize isActive;
@synthesize isOutOfArea;
@synthesize isWaitRemove;
@synthesize costume;

- (id) init{
	if ((self = [super init])) {		
		[[Defs instance].actorManager add:self];
		costume = nil;
		parentFrame = nil;
		
		isWaitRemove = NO;
		
		isOutOfArea = NO;
		isVisible = NO;
        
        isActive = NO;
		
		zCoord = -1; // -1 означает, что Z координата задается автоматчески
	}
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (int) getID{
	return itemID;
}

- (void) setID:(int)_value{
	itemID = _value;
}

- (void) createStuff{
}

- (BOOL) getOutOfArea{
	return isOutOfArea;
}

- (void) prepareToRemove{
	isWaitRemove = YES;
}

- (void) update:(ccTime)dt {
	if (isWaitRemove) return;
}

- (void) activate {
    isActive = YES;
}

- (void) deactivate {
    isActive = NO;
}

- (void) outOfArea {
	isOutOfArea = YES;

}
- (void) removeActor {
	[self removeCostume];
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
		if ((isActive)&&(!isWaitRemove) && (!costume.parent)) {
            if (zCoord != -1) [parentFrame addChild:costume z:zCoord]; else [parentFrame addChild:costume];
        } else return;
	}
	else
		if (costume.parent) [costume removeFromParentAndCleanup:YES];
	
	isVisible = _flag;
}

- (void) touch {
    
}

@end
