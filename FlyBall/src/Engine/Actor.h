//
//  Actor.h
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Actor : NSObject {
	int itemID;
	CCSprite *costume;
	CCNode *parentFrame;
	BOOL isWaitRemove;
	
    BOOL isActive;
	BOOL isVisible;
	BOOL isOutOfArea;
	int spriteWidth;
	int spriteHeight;
	int zCoord;
}

@property (nonatomic, assign) int itemID;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL isOutOfArea;
@property (nonatomic, assign) BOOL isWaitRemove;
@property (nonatomic, assign) CCSprite *costume;

- (id) init;
- (void) dealloc;
- (int) getID;
- (void) setID:(int)_value;
- (void) createStuff;
- (BOOL) getOutOfArea;
- (void) prepareToRemove;
- (void) update:(ccTime)dt;
- (void) activate;
- (void) deactivate;
- (void) outOfArea;
- (void) removeActor;
- (void) removeCostume;
- (void) show:(BOOL)_flag;
- (void) touch;

@end
