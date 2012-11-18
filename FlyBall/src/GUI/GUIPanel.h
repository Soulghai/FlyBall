//
//  GUIPanel.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"

@interface GUIPanel : GUIItem {
	CCSprite *spr;
}

@property (nonatomic, retain) CCSprite *spr;

- (id) init:(id)_def;
- (void) show:(BOOL)_flag;
- (void) touchReaction:(CGPoint)_touchPos;

@end
