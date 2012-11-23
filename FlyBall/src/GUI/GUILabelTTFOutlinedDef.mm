//
//  GUILabelTTFOutlinedDef.m
//  Expand_It
//
//  Created by Mac Mini on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILabelTTFOutlinedDef.h"
#import "MainScene.h"

@implementation GUILabelTTFOutlinedDef

@synthesize text;
@synthesize fontName;
@synthesize fontSize;
@synthesize containerSize;
@synthesize textColor;
@synthesize outlineColor;
@synthesize outlineSize;
@synthesize alignement;

- (id) init{
	if ((self = [super init])) {		
		text = @"";
        fontName = @"MyriadPro-Bold";
        fontSize = 20;
        parentFrame = [MainScene instance];
        containerSize = CGSizeMake(0,0);
        textColor = ccc3(255, 255, 255);
        outlineColor = ccc3(0, 0, 0);
        outlineSize = 2;
        alignement = kCCTextAlignmentCenter;
	}
	return self;
}

@end
