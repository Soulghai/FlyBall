//
//  GUIItemDef.m
//  Expand_It
//
//  Created by Mac Mini on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIItemDef.h"
#import "MainScene.h"

@implementation GUIItemDef

@synthesize enabled;
@synthesize group;
@synthesize parentFrame;
@synthesize sprName;
@synthesize sprFileName;
@synthesize objCreator;
@synthesize zIndex;

- (id) init{
	if ((self = [super init])) {		
		group = 0;
		parentFrame = [MainScene instance].gui;
		objCreator = nil;
        zIndex = INT16_MIN;
        enabled = YES;
	}
	return self;
}

@end