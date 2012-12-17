//
//  Actor.h
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpeedWall : NSObject {
	CCSprite *costume;
	CCNode *parentFrame;
    
    BOOL isTrigger;
    
    float halfWidth;
	
    BOOL isShowing;
    BOOL isHiding;
	BOOL isVisible;
	BOOL isOutOfArea;
    
    float delayWarning;
    float timeWaiting;
    float delayWaitingDefault;
    float delayWaiting;
    float timeShowing;
    float delayShowing;
    
    float showingSpeed;
    float addSpeedCoeff;
    float addSpeedCoeffOld;
    CGPoint positionChangeCoeff;
    
    CCParticleSystemQuad *emitterStarsAcc;
    CCParticleSystemQuad *emitterStarsDecc;
    CCParticleSystemQuad *emitterWarningAcc;
    CCParticleSystemQuad *emitterWarningDecc;
}

- (id) init:(CCNode*)_parentFrame;
- (void) setPosition:(CGPoint)_position;
- (void) update;
- (void) deactivate;
- (void) outOfArea;
- (CGPoint) checkToCollide:(CGPoint)_position;
- (void) show:(BOOL)_flag;

@end
