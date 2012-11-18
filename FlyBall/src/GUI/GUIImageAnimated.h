//
//  GUIImageAnimated.h
//  Expand_It
//
//  Created by Mac Mini on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItem.h"

@interface GUIImageAnimated : GUIItem {
	CCSprite *spr;
}

@property (nonatomic, retain) CCSprite *spr;

- (id) init:(id)_def;
- (void) show:(BOOL)_flag;

@end