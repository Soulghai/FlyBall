//
//  ActorActiveObject.h
//  IncredibleBlox
//
//  Created by Mac Mini on 26.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import	"Actor.h"

@interface ActorActiveObject : Actor {
	BOOL isDying;
	
	unsigned int touchCounter;
    
    BOOL isEraserCollide;
    
    CGPoint velocity;
    float gravitation;
    
    CCParticleSystemQuad *emitterBoom;
}

@property (nonatomic, assign) BOOL isDying;
@property (nonatomic) CGPoint velocity;

-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) dealloc;
- (void) loadCostume;
- (void) createStuff;
- (void) deactivate;
- (void) eraserCollide;
- (void) outOfArea;
- (void) addVelocity:(CGPoint)_value;
- (void) removeCostume;
- (void) getAchievement;
- (void) touch;
- (void) addToField:(CGPoint)_point
          _velocity:(CGPoint)_velocity;
@end
