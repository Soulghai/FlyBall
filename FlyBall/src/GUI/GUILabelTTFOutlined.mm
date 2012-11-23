//
//  GUILabelTTFOutlined.m
//  Expand_It
//
//  Created by Mac Mini on 21.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GUILabelTTFOutlined.h"
#import "GUILabelTTFOutlinedDef.h"
#import "Defs.h"

@implementation GUILabelTTFOutlined

@synthesize spr;
@synthesize fontName;
@synthesize text;
@synthesize fontSize;
@synthesize containerSize;
@synthesize textColor;
@synthesize outlineColor;
@synthesize outlineSize;
@synthesize alignement;

-(CCRenderTexture*) createStroke: (CCLabelTTF*) _label   size:(float)size   color:(ccColor3B)cor
{
	CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:_label.texture.contentSize.width+size*2  height:_label.texture.contentSize.height+size*2];
	CGPoint originalPos = [_label position];
	ccColor3B originalColor = [_label color];
	[_label setColor:cor];
	ccBlendFunc originalBlend = [_label blendFunc];
	[_label setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
	CGPoint center = ccp(_label.texture.contentSize.width/2+size, _label.texture.contentSize.height/2+size);
	[rt begin];
	for (int i=0; i<360; i+=15)
	{
		[_label setPosition:ccp(center.x + sin(CC_DEGREES_TO_RADIANS(i))*size, center.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
		[_label visit];
	}
	[rt end];
	[_label setPosition:originalPos];
	[_label setColor:originalColor];
	[_label setBlendFunc:originalBlend];
	[rt setPosition:originalPos];
	return rt;
}

- (id) init:(id)_def{
	if ((self = [super init])) {		
		GUILabelTTFOutlinedDef *_tmpDef = (GUILabelTTFOutlinedDef*)_def;
        
        fontName = _tmpDef.fontName;
        fontSize = _tmpDef.fontSize;
        text = _tmpDef.text;
        containerSize = _tmpDef.containerSize;
        textColor = _tmpDef.textColor;
        outlineColor = _tmpDef.outlineColor;
        outlineSize = _tmpDef.outlineSize;
        alignement = _tmpDef.alignement;
        
        spr = [CCSprite node];
        
        if (containerSize.width == 0) {
            label = [CCLabelTTF labelWithString:text fontName:fontName fontSize:fontSize];
        } else
            label = [CCLabelTTF labelWithString:text fontName:fontName fontSize:fontSize dimensions:containerSize hAlignment:alignement];
        
        //[label setPosition:ccp(_pos.x, _pos.y)];
        [label setColor:textColor];
        stroke = [self createStroke:label  size:outlineSize  color:outlineColor];
        [spr addChild:stroke];
        [spr addChild:label];
        
        //[font setAnchorPoint:ccp(0.5f,0.5f)];
        [label retain];
        [stroke retain];
        [spr retain];
        
		parentFrame = _tmpDef.parentFrame;
		group = _tmpDef.group;
        enabled = _tmpDef.enabled;
        zIndex = _tmpDef.zIndex;
        
        oldPosition = CGPointZero;
	}
	return self;
}

- (void) setPosition:(CGPoint)_newPosition {
    oldPosition = _newPosition;
    if (alignement == kCCTextAlignmentCenter) spr.position = ccp(_newPosition.x,_newPosition.y);
    else
    if (alignement == kCCTextAlignmentLeft) {
        spr.position = ccp(_newPosition.x + label.contentSize.width/2,_newPosition.y);
    } else
        spr.position = ccp(_newPosition.x - label.contentSize.width/2,_newPosition.y);
}

- (void) setText:(NSString *)_text {
    text = _text;
    [spr removeAllChildrenWithCleanup:YES];
    [label setString:_text];
    [stroke release];
    stroke = [self createStroke:label  size:outlineSize  color:outlineColor];
    [stroke retain];
    [spr addChild:stroke];
    [spr addChild:label];
    [self setPosition:oldPosition];
}

- (void) setColor:(ccColor3B)_cc3 {
    textColor = _cc3;
    [label setColor:textColor];
}

- (void) setOpacity:(GLubyte)_opacity {
    [label setOpacity:_opacity];
    [stroke.sprite setOpacity:_opacity];
    [spr setOpacity:_opacity];
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
	if (spr != nil) [spr release];
    spr = nil;
}

@end