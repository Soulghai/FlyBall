//
//  GUIInterface.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUIInterface.h"
#import "GUIItem.h"
#import "GUIButtonDef.h"
#import "GUIButtonTextDef.h"
#import "GUILabelDef.h"
#import "GUICheckBoxDef.h"
#import "GUIPanelDef.h"
#import "GUIButton.h"
#import "GUIButtonText.h"
#import "GUILabel.h"
#import "GUICheckBox.h"
#import "GUIPanel.h"
#import "GUILabelTTF.h"
#import "GUILabelTTFDef.h"
#import "GUILabelTTFOutlined.h"
#import "GUILabelTTFOutlinedDef.h"
#import "globalParam.h"

@implementation GUIInterface

@synthesize currentGroup;
@synthesize isTouch;

- (id)initWithFile:(NSString *)fileImage capacity:(NSUInteger)capacity {
	if ((self = [super initWithFile:fileImage capacity:capacity])) {				
		buttons = [NSMutableArray arrayWithCapacity:10];
		[buttons retain];
		buttonTexts = [NSMutableArray arrayWithCapacity:10];
		[buttonTexts retain];
		labels = [NSMutableArray arrayWithCapacity:10];
		[labels retain];
        labelsTTF = [NSMutableArray arrayWithCapacity:10];
		[labelsTTF retain];
        labelsTTFOutlined = [NSMutableArray arrayWithCapacity:10];
		[labelsTTFOutlined retain];
		checkBoxs = [NSMutableArray arrayWithCapacity:10];
		[checkBoxs retain];
		panels = [NSMutableArray arrayWithCapacity:10];
		[panels retain];
		
		currentGroup = GAME_STATE_NONE;
	}
	return self;
}

- (id) addItem:(id)_def
			_pos:(CGPoint)_pos {
	
	if ([_def isKindOfClass:[GUIButtonDef class]]) return [self addButton:_def _pos:_pos]; else
		if ([_def isKindOfClass:[GUIButtonTextDef class]]) return [self addButtonText:_def _pos:_pos]; else
			if ([_def isKindOfClass:[GUILabelDef class]]) return [self addLabel:_def _pos:_pos]; else
                if ([_def isKindOfClass:[GUILabelTTFDef class]]) return [self addLabelTTF:_def _pos:_pos]; else
                    if ([_def isKindOfClass:[GUILabelTTFOutlinedDef class]]) return [self addLabelTTFOutlined:_def _pos:_pos]; else
                    if ([_def isKindOfClass:[GUICheckBoxDef class]]) return [self addCheckBox:_def _pos:_pos]; else
                        if ([_def isKindOfClass:[GUIPanelDef class]]) return [self addPanel:_def _pos:_pos];
	return nil;
}

- (GUIButton*) addButton:(GUIButtonDef*)_def
					_pos:(CGPoint)_pos {
	GUIButton *_item = [[GUIButton alloc] init:_def];
	[buttons addObject:_item];
	[_item setPosition:_pos];
	return _item;					
}

- (GUIButtonText*) addButtonText:(GUIButtonTextDef*)_def
							_pos:(CGPoint)_pos {
	GUIButtonText *_item = [[GUIButtonText alloc] init:_def];
	[buttonTexts addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

/*- (GUIButtonBitmap*) addButtonBitmap:(GUIButtonBitmapDef*)_def
 _pos:(CGPoint)_pos;*/

- (GUILabel*) addLabel:(GUILabelDef*)_def
				  _pos:(CGPoint)_pos {
	GUILabel *_item = [[GUILabel alloc] init:_def];
	[labels addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

- (GUILabelTTF*) addLabelTTF:(GUILabelTTFDef*)_def
				  _pos:(CGPoint)_pos {
	GUILabelTTF *_item = [[GUILabelTTF alloc] init:_def];
	[labelsTTF addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

- (GUILabelTTFOutlined*) addLabelTTFOutlined:(GUILabelTTFOutlinedDef*)_def
                        _pos:(CGPoint)_pos {
	GUILabelTTFOutlined *_item = [[GUILabelTTFOutlined alloc] init:_def];
	[labelsTTFOutlined addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

- (GUICheckBox*) addCheckBox:(GUICheckBoxDef*)_def
						_pos:(CGPoint)_pos {
	GUICheckBox *_item = [[GUICheckBox alloc] init:_def];
	[checkBoxs addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

- (GUIPanel*) addPanel:(GUIPanelDef*)_def
				  _pos:(CGPoint)_pos {
	GUIPanel *_item = [[GUIPanel alloc] init:_def];
	[panels addObject:_item];
	[_item setPosition:_pos];
	return _item;
}

- (void) update {	
	unsigned int _count;
	unsigned int i;
	
	_count = [buttons count];
	GUIItem *_object;
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
	
	_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
	
	_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
    
    _count = [labelsTTF count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTF objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
    
    _count = [labelsTTFOutlined count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTFOutlined objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
	
	_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object update];
	}
}

- (void) show:(unsigned int)_groupIndex {
	unsigned int _count;
	unsigned int i;
	
	currentGroup = _groupIndex;
	
	GUIItem *_object;
	
	_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [buttons count];
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
    
    _count = [labelsTTF count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTF objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
    
    _count = [labelsTTFOutlined count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTFOutlined objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if ((_object.group & currentGroup) != 0) [_object show:YES];
		else [_object show:NO];
	}
}

- (void) showOnly:(unsigned int)_groupIndex {
	unsigned int _count;
	unsigned int i;
	
	currentGroup = _groupIndex;
	
	GUIItem *_object;
	
	_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [buttons count];
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
    
    _count = [labelsTTF count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTF objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
    
    _count = [labelsTTFOutlined count];
	for (i = 0; i < _count; i++) {
		_object = [labelsTTFOutlined objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if (_object.group == currentGroup) [_object show:YES];
		else [_object show:NO];
	}
}

- (BOOL) touchReaction:(CGPoint)_touchPos {	
	unsigned int _count;
	unsigned int i;
	
	
    isTouch = nil;
	
	_count = [buttons count];
	GUIItem *_object;
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if ((isTouch == nil)&&(_object.isVisible)) [_object touchReaction:_touchPos];
	}
	
	/*_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if (_object.isVisible) [_object touchReaction:_touchPos];
	}
	
	_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if (_object.isVisible) [_object touchReaction:_touchPos];
	}*/
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if ((isTouch == nil)&&(_object.isVisible)) [_object touchReaction:_touchPos];
	}
	
	_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if ((isTouch == nil)&&(_object.isVisible)) [_object touchReaction:_touchPos];
	}
	
	if (isTouch != nil) return YES; else return NO;
}

-(void) ccTouchEnded:(CGPoint)_touchPos {
	unsigned int _count;
	unsigned int i;
	
	_count = [buttons count];
	GUIItem *_object;
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchEnded:_touchPos];
	}
	
	/*_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchEnded:_touchPos];
	}
	
	_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchEnded:_touchPos];
	}*/
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchEnded:_touchPos];
	}
	
	/*_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchEnded:_touchPos];
	}*/
}

-(void) ccTouchMoved:(CGPoint)_touchLocation
	   _prevLocation:(CGPoint)_prevLocation 
			   _diff:(CGPoint)_diff {
	unsigned int _count;
	unsigned int i;
	
	_count = [buttons count];
	GUIItem *_object;
	for (i = 0; i < _count; i++) {
		_object = [buttons objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}
	
	/*_count = [buttonTexts count];
	for (i = 0; i < _count; i++) {
		_object = [buttonTexts objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}*/
	
	/*_count = [labels count];
	for (i = 0; i < _count; i++) {
		_object = [labels objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}*/
	
	_count = [checkBoxs count];
	for (i = 0; i < _count; i++) {
		_object = [checkBoxs objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}
	
	/*_count = [panels count];
	for (i = 0; i < _count; i++) {
		_object = [panels objectAtIndex:i];
		if (_object.isVisible) [_object ccTouchMoved:_touchLocation _prevLocation:_prevLocation _diff:_diff];
	}*/
}

- (void) dealloc {
	[isTouch release];
    isTouch = nil;
	[super dealloc];
}

@end
