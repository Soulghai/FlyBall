//
//  GUIInterface.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
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

@interface GUIInterface : CCSpriteBatchNode {
	NSMutableArray *buttons;
	NSMutableArray *buttonsBitmap;
	NSMutableArray *labels;
    NSMutableArray *labelsTTF;
    NSMutableArray *labelsTTFOutlined;
	NSMutableArray *buttonTexts;
	NSMutableArray *checkBoxs;
	NSMutableArray *panels;
	
	NSString *sndClick;
	NSString *sndOnButton;				//Если курсор над интерфейсом (любым его элементом)
}

@property (nonatomic, assign) unsigned int currentGroup;
@property (nonatomic, retain) GUIItem *isTouch;

-(id)initWithFile:(NSString *)fileImage capacity:(NSUInteger)capacity;
	
- (id) addItem:(id)_def
			_pos:(CGPoint)_pos;
	
- (GUIButton*) addButton:(GUIButtonDef*)_def
					_pos:(CGPoint)_pos;

/*- (GUIButtonBitmap*) addButtonBitmap:(GUIButtonBitmapDef*)_def
					_pos:(CGPoint)_pos;*/

- (GUILabel*) addLabel:(GUILabelDef*)_def
					   _pos:(CGPoint)_pos;

- (GUILabelTTF*) addLabelTTF:(GUILabelTTFDef*)_def
                  _pos:(CGPoint)_pos;

- (GUILabelTTFOutlined*) addLabelTTFOutlined:(GUILabelTTFOutlinedDef*)_def
                                _pos:(CGPoint)_pos;

- (GUIButtonText*) addButtonText:(GUIButtonTextDef*)_def
				_pos:(CGPoint)_pos;

- (GUICheckBox*) addCheckBox:(GUICheckBoxDef*)_def
				_pos:(CGPoint)_pos;

- (GUIPanel*) addPanel:(GUIPanelDef*)_def
				_pos:(CGPoint)_pos;

- (void) update;
- (void) show:(unsigned int)_groupIndex;
- (void) showOnly:(unsigned int)_groupIndex;
- (BOOL) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
@end