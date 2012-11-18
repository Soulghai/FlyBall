//
//  GUIItem.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GUIItem : CCNode {
	BOOL isVisible;
	unsigned int group;
	CCNode *parentFrame;
	id objCreator;
    BOOL enabled;
    NSString *sprName;
    NSString *sprFileName;
    int zIndex;
}

@property (nonatomic,readwrite) BOOL isVisible;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) unsigned int group;
@property (nonatomic,assign) CCNode *parentFrame;
@property (nonatomic,assign) NSString *sprName;
@property (nonatomic,assign) NSString *sprFileName;
@property (nonatomic,assign) id objCreator;
@property (nonatomic,assign) int zIndex;

- (id) init:(id)_def;
- (void) setPosition:(CGPoint)_newPosition;
- (void) update;
- (void) show:(BOOL)_flag;
- (void) setEnabled:(BOOL)_flag;
- (void) touchReaction:(CGPoint)_touchPos;
- (void) ccTouchEnded:(CGPoint)_touchPos;
- (void) ccTouchMoved:(CGPoint)_touchLocation
		_prevLocation:(CGPoint)_prevLocation 
				_diff:(CGPoint)_diff;
@end
