//
//  GUILabelTTFDef.m
//  Expand_It
//
//  Created by Mac Mini on 10.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILabelTTFDef.h"
#import "MainScene.h"


@implementation GUILabelTTFDef

@synthesize text;
@synthesize fontName;
@synthesize fontSize;
@synthesize containerSize;
@synthesize textColor;
@synthesize alignement;

- (id) init{
	if ((self = [super init])) {		
		text = @"";
        fontName = @"MyriadPro-Bold";
        fontSize = 20;
        parentFrame = [MainScene instance];
        containerSize = CGSizeMake(0,0);
        textColor = ccc3(0, 0, 0);
        alignement = kCCTextAlignmentCenter;
	}
	return self;
}

@end