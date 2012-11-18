//
//  GUIItem.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIItem.h"


@implementation GUIItem

@synthesize isVisible;
@synthesize enabled;
@synthesize group;
@synthesize parentFrame;
@synthesize objCreator;
@synthesize sprName;
@synthesize sprFileName;
@synthesize zIndex;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		isVisible = NO;
		group = 0;
		parentFrame = nil;
        sprName = nil;
        sprFileName = nil;
        zIndex = INT16_MIN;
        enabled = YES;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
}

- (void) update {
	
}

- (void) show:(BOOL)_flag {
	
}

- (void) setEnabled:(BOOL)_flag {
	enabled = _flag;
}

- (void) touchReaction:(CGPoint)_touchPos {	
	
}

-(void) ccTouchEnded:(CGPoint)_touchPos {
}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation 
			   _diff:(CGPoint)_diff {
}

@end
