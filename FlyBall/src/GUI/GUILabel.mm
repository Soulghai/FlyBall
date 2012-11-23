//
//  GUILabel.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUILabel.h"
#import "GUILabelDef.h"
#import "Defs.h"
#import "CCLabelBMFont.h"

@implementation GUILabel

@synthesize spr;
@synthesize fontName;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUILabelDef *_tmpDef = (GUILabelDef*)_def;
        
        fontName = _tmpDef.fontName;
        
        spr = [CCLabelBMFont labelWithString:_tmpDef.text fntFile:fontName];
        [spr setAnchorPoint:ccp(0.5f,0.5f)];
		[spr retain];
        
		parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
        enabled = _tmpDef.enabled;
        zIndex = _tmpDef.zIndex;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
    spr.position = ccp(_newPosition.x,_newPosition.y);
}

- (void) setText:(NSString *)_text {
    [spr setString:[NSString stringWithFormat:@"%@",_text]];
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