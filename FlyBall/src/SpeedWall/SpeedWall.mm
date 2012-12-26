//
//  Actor.m
//  IncredibleBlox
//
//  Created by Mac Mini on 23.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import "SpeedWall.h"
#import "globalParam.h"
#import "Defs.h"
#import "MainScene.h"

@implementation SpeedWall

- (id) init:(CCNode*)_parentFrame {
	if ((self = [super init])) {		
		costume = nil;
		parentFrame = _parentFrame;
		
		isOutOfArea = NO;
		isVisible = NO;
        
        isShowing = NO;
        isHiding = NO;
        
        delayWarning = 3;
        timeWaiting = 0;
        delayWaitingDefault = 30;
        delayWaiting = delayWaitingDefault + CCRANDOM_0_1()*10;
        timeShowing = 0;
        delayShowing = [Defs instance].speedWallDelayShowingCoeff;
        
        costume = [CCSprite spriteWithSpriteFrameName:@"speedWallBackground_1.jpg"];
        [costume retain];
        [costume setScaleY:2.f];
        [costume setScaleX:2.0f];
        [costume setOpacity:150];
        
        halfWidth = costume.contentSize.width*0.5f*costume.scaleX;
        
        showingSpeed = -35;
        addSpeedCoeff = [Defs instance].speedWallAccelerationCoeff;
        addSpeedCoeffOld = -1;
        
        positionChangeCoeff = CGPointZero;
        
        emitterWarningAcc = [CCParticleSystemQuad particleWithFile:@"speedWallPrepareAcc.plist"];
        [emitterWarningAcc retain];
        emitterWarningDecc = [CCParticleSystemQuad particleWithFile:@"speedWallPrepareDecc.plist"];
        [emitterWarningDecc retain];
        
        emitterWarningAcc.positionType = kCCPositionTypeGrouped;
        [emitterWarningAcc unscheduleUpdate];
        emitterWarningDecc.positionType = kCCPositionTypeGrouped;
        [emitterWarningDecc unscheduleUpdate];
        
        emitterStarsAcc = [CCParticleSystemQuad particleWithFile:@"speedWallAcceleration.plist"];
        [emitterStarsAcc retain];
        emitterStarsAcc.positionType = kCCPositionTypeGrouped;
        [emitterStarsAcc unscheduleUpdate];
        emitterStarsDecc = [CCParticleSystemQuad particleWithFile:@"speedWallDecceleration.plist"];
        [emitterStarsDecc retain];
        emitterStarsAcc.positionType = kCCPositionTypeGrouped;
        [emitterStarsDecc unscheduleUpdate];
        
        isTrigger = NO;
	}
	return self;
}

- (void) setPosition:(CGPoint)_position {
    [costume setPosition:_position];
}

- (BOOL) getOutOfArea{
	return isOutOfArea;
}

- (void) hideEmitter {
    if (emitterStarsAcc.parent) {
        [emitterStarsAcc unscheduleUpdate];
        [emitterStarsAcc removeFromParentAndCleanup:YES];
    }
    if (emitterStarsDecc.parent) {
        [emitterStarsDecc unscheduleUpdate];
        [emitterStarsDecc removeFromParentAndCleanup:YES];
    }
}

- (void) hideEmitterWarning {
    if (emitterWarningAcc.parent)  {
        [emitterWarningAcc unscheduleUpdate];
        [emitterWarningAcc removeFromParentAndCleanup:YES];
    }
    
    if (emitterWarningDecc.parent) {
        [emitterWarningDecc unscheduleUpdate];
        [emitterWarningDecc removeFromParentAndCleanup:YES];
    }
}

- (void) update {
	if (isVisible) {
        if ((!isHiding)&&(!isShowing)) {
            timeShowing += TIME_STEP;
            if (timeShowing >= delayShowing) {
                isShowing = NO;
                isHiding = YES;
            }
        }
        
        int xPosition = MAX([MainScene instance].game.player.position.x, -64);
        xPosition = MIN(xPosition, 384);
        
        costume.position = ccpAdd(ccp(xPosition, -[Defs instance].objectFrontLayer.position.y + SCREEN_HEIGHT_HALF), positionChangeCoeff);
        
        if (isShowing||isHiding) {
            positionChangeCoeff = ccpAdd(positionChangeCoeff, ccp(0, showingSpeed));
            
            
            if ((isShowing)&&(positionChangeCoeff.y <= 0)) {
                costume.position = ccp(costume.position.x, -[Defs instance].objectFrontLayer.position.y + SCREEN_HEIGHT_HALF);
                positionChangeCoeff = ccp(positionChangeCoeff.x, 0);
                [self hideEmitterWarning];
                isShowing = NO;
            } else
                if ((isHiding)&&(positionChangeCoeff.y <= -SCREEN_HEIGHT)) {
                    costume.position = ccp(costume.position.x, -[Defs instance].objectFrontLayer.position.y + SCREEN_HEIGHT_HALF);
                    positionChangeCoeff = ccp(positionChangeCoeff.x, -SCREEN_HEIGHT);
                    isHiding = NO;
                    [self stopCurrentWall];
                }
        } else {
            positionChangeCoeff = ccpAdd(positionChangeCoeff, ccp(-[MainScene instance].game.player.velocity.x, 0));
            //costume.position = ccpAdd(ccp(xPosition, -[Defs instance].objectFrontLayer.position.y + SCREEN_HEIGHT_HALF), positionChangeCoeff);
        }
        
        if (emitterStarsAcc.parent)
            emitterStarsAcc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
        else
            if (emitterStarsDecc.parent)
                emitterStarsDecc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
        
        if (emitterWarningAcc.parent)
            
            emitterWarningAcc.position = ccpAdd(ccp(xPosition, costume.position.y), ccp(0, -SCREEN_HEIGHT_HALF));
        else
            if (emitterWarningDecc.parent)
                emitterWarningDecc.position = ccpAdd(ccp(xPosition, costume.position.y), ccp(0, -SCREEN_HEIGHT_HALF));
        
    } else {
        timeWaiting += TIME_STEP;
        if ((timeWaiting >= delayWaiting - delayWarning)&&((emitterWarningAcc.parent == nil)&&(emitterWarningDecc.parent == nil))) {
            isTrigger = !isTrigger;
            
            if (isTrigger) {
                addSpeedCoeff = [Defs instance].speedWallAccelerationCoeff;
                [emitterWarningAcc scheduleUpdate];
                emitterWarningAcc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
                if ((emitterWarningAcc)&&(emitterWarningAcc.parent == nil))
                    [[Defs instance].objectFrontLayer addChild:emitterWarningAcc z:60];
            } else {
                addSpeedCoeff = [Defs instance].speedWallDeccelerationCoeff;
                [emitterWarningDecc scheduleUpdate];
                emitterWarningDecc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
                if ((emitterWarningDecc)&&(emitterWarningDecc.parent == nil))
                    [[Defs instance].objectFrontLayer addChild:emitterWarningDecc z:60];
            }
        }
        
        int xPosition = MAX([MainScene instance].game.player.position.x, -64);
        xPosition = MIN(xPosition, 384);
        
        if (emitterWarningAcc.parent)
            emitterWarningAcc.position = ccp(xPosition, [MainScene instance].game.player.position.y +SCREEN_HEIGHT_HALF);
        else
            if (emitterWarningDecc.parent)
                emitterWarningDecc.position = ccp(xPosition, [MainScene instance].game.player.position.y +SCREEN_HEIGHT_HALF);
        
        timeWaiting += TIME_STEP;
        if (timeWaiting >= delayWaiting) {
            timeWaiting = 0;
            delayWaiting = delayWaitingDefault + CCRANDOM_0_1()*5;
            isShowing = YES;
            [self hideEmitter];

            positionChangeCoeff = ccp(0, SCREEN_HEIGHT);
            costume.position = ccp(costume.position.x, [MainScene instance].game.player.position.y-SCREEN_HEIGHT);
            
            if (addSpeedCoeff > 0) {
                if (addSpeedCoeff != addSpeedCoeffOld) {
                    CCSpriteFrame* frame;
                    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"speedWallBackground_1.jpg"];
                    [costume setDisplayFrame:frame];
                    //[costume setColor:ccc3(0, 255, 0)];
                }
            } else {
                if (addSpeedCoeff != addSpeedCoeffOld) {
                    CCSpriteFrame* frame;
                    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"speedWallBackground_2.jpg"];
                    [costume setDisplayFrame:frame];
                    //[costume setColor:ccc3(255, 0, 0)];
                }
            }
            addSpeedCoeffOld = addSpeedCoeff;
            
            if (addSpeedCoeff >= 0) {
                emitterStarsAcc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
                if ((emitterStarsAcc)&&(emitterStarsAcc.parent == nil))
                    [[Defs instance].objectFrontLayer addChild:emitterStarsAcc z:60];
                [emitterStarsAcc scheduleUpdate];
            } else {
                emitterStarsDecc.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
                if ((emitterStarsDecc)&&(emitterStarsDecc.parent == nil))
                    [[Defs instance].objectFrontLayer addChild:emitterStarsDecc z:60];
                [emitterStarsDecc scheduleUpdate];
            }
            
            
            [self show:YES];
        }
    }
}

- (void) deactivate {
    timeShowing = 0;
    timeWaiting = 0;
    isHiding = NO;
    isShowing= NO;
    addSpeedCoeffOld = 0;
    [self hideEmitter];
    [self hideEmitterWarning];
    [self show:NO];
    isTrigger = NO;
}

- (void) stopCurrentWall {
    BOOL _tmpIsTrigger = isTrigger;
    [self deactivate];
    isTrigger = _tmpIsTrigger;
}

- (void) outOfArea {
	isOutOfArea = YES;
}

- (CGPoint) checkToCollide:(CGPoint)_position {
    if (isVisible) {
        if ((_position.x + elementRadius > costume.position.x - halfWidth)
            &&(_position.x - elementRadius < costume.position.x + halfWidth)
            &&(_position.y + elementRadius > costume.position.y - SCREEN_HEIGHT_HALF)
            &&(_position.y - elementRadius < costume.position.y + SCREEN_HEIGHT_HALF)) {
                return ccp(0, addSpeedCoeff);
        }
    }
    return CGPointZero;
}

- (void) show:(BOOL)_flag {
	if (isVisible == _flag) return;
	
	if (_flag) {
		if (!costume.parent) [parentFrame addChild:costume];
	}
	else {
		if (costume.parent) [costume removeFromParentAndCleanup:YES];
        [self hideEmitter];
        [self hideEmitterWarning];
    }
	
	isVisible = _flag;
}

@end
