//
//  GUIButtonDef.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIButtonDef.h"

@implementation GUIButtonDef

@synthesize sprDownName;
@synthesize sound;
@synthesize func;
@synthesize isManyTouches;

- (id) init{
	if ((self = [super init])) {		
        isManyTouches = NO;
        sprDownName = nil;
        sound = @"button_click.wav";
	}
	return self;
}

@end
