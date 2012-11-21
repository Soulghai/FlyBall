//
//  GUILableTTF.m
//  Expand_It
//
//  Created by Mac Mini on 10.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILabelTTF.h"
#import "GUILabelTTFDef.h"

@implementation GUILabelTTF

@synthesize spr;
@synthesize fontName;
@synthesize fontSize;
@synthesize containerSize;
@synthesize alignement;

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUILabelTTFDef *_tmpDef = (GUILabelTTFDef*)_def;
        
        fontName = _tmpDef.fontName;
        fontSize = _tmpDef.fontSize;
        text = _tmpDef.text;
        containerSize = _tmpDef.containerSize;
        alignement = _tmpDef.alignement;
        textColor = _tmpDef.textColor;
        
        //fontName = @"cour.ttf";
        
        //CGSize actualSize = [text sizeWithFont:[UIFont fontWithName:@"cour.ttf" size:fontSize] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
        
        //CGSize containerSize = {actualSize.width, actualSize.height};
        if (containerSize.width == 0) {
            spr = [CCLabelTTF labelWithString:text fontName:fontName fontSize:fontSize];
            if (alignement == kCCTextAlignmentLeft) [spr setAnchorPoint:ccp(0, 0.5f)];
            else if (alignement == kCCTextAlignmentRight) [spr setAnchorPoint:ccp(1, 0.5f)];
        } else
            spr = [CCLabelTTF labelWithString:text fontName:fontName fontSize:fontSize dimensions:containerSize hAlignment:alignement];
        
        //[font setAnchorPoint:ccp(0.5f,0.5f)];
        [spr retain];
        
        [spr setColor:textColor];
        
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

- (void) setColor:(ccColor3B)_cc3 {
    textColor = _cc3;
    [spr setColor:textColor];
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
