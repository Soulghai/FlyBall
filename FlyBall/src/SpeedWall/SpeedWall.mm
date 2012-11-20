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
        
        delayWarning = 2;
        timeWaiting = 0;
        delayWaitingDefault = 4;
        delayWaiting = delayWaitingDefault + CCRANDOM_0_1()*0;
        timeShowing = 0;
        delayShowing = [Defs instance].speedWallDelayShowingCoeff;
        
        costume = [CCSprite spriteWithSpriteFrameName:@"speedWallBackground.jpg"];
        [costume retain];
        [costume setScaleY:3.75f];
        [costume setScaleX:10];
        [costume setOpacity:50];
        
        showingSpeed = -30;
        addSpeedCoeff = [Defs instance].speedWallAccelerationCoeff;
        
        positionChangeCoeff = CGPointZero;
	}
	return self;
}

- (void) setPosition:(CGPoint)_position {
    [costume setPosition:_position];
}

- (BOOL) getOutOfArea{
	return isOutOfArea;
}

- (void) deleteEmitter {
    if (emitterStars) {
        [emitterStars resetSystem];
        [emitterStars stopSystem];
        [emitterStars removeFromParentAndCleanup:YES];
        emitterStars = nil;
    }
}

- (void) deleteEmitterWarning {
    if (emitterWarning) {
        [emitterWarning resetSystem];
        [emitterWarning stopSystem];
        [emitterWarning removeFromParentAndCleanup:YES];
        emitterWarning = nil;
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
        
        if (isShowing||isHiding) {
            positionChangeCoeff = ccpAdd(positionChangeCoeff, ccp(-[MainScene instance].game.player.velocity.x, showingSpeed));
            costume.position = ccpAdd([MainScene instance].game.player.costume.position, positionChangeCoeff);
            if ((isShowing)&&(positionChangeCoeff.y <= 0)) {
                costume.position = ccp(costume.position.x, [MainScene instance].game.player.costume.position.y);
                positionChangeCoeff = ccp(positionChangeCoeff.x, 0);
                [self deleteEmitterWarning];
                isShowing = NO;
            } else
                if ((isHiding)&&(positionChangeCoeff.y <= -SCREEN_HEIGHT)) {
                    costume.position = ccp(costume.position.x, [MainScene instance].game.player.costume.position.y);
                    positionChangeCoeff = ccp(positionChangeCoeff.x, -SCREEN_HEIGHT);
                    isHiding = NO;
                    [self deactivate];
                }
        } else {
            positionChangeCoeff = ccpAdd(positionChangeCoeff, ccp(-[MainScene instance].game.player.velocity.x, 0));
            costume.position = ccpAdd([MainScene instance].game.player.costume.position, positionChangeCoeff);
        }
        
        if (emitterStars)
            emitterStars.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
        
        if (emitterWarning)
            emitterWarning.position = ccpAdd(costume.position, ccp(0, -SCREEN_HEIGHT_HALF));
        
    } else {
        timeWaiting += TIME_STEP;
        if ((timeWaiting >= delayWaiting - delayWarning)&&(emitterWarning == nil)) {
            if (addSpeedCoeff >= 0)
                emitterWarning = [CCParticleSystemQuad particleWithFile:@"speedWallPrepareAcc.plist"];
            else
                emitterWarning = [CCParticleSystemQuad particleWithFile:@"speedWallPrepareDecc.plist"];
            emitterWarning.positionType = kCCPositionTypeGrouped;
            emitterWarning.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
            if ((emitterWarning)&&(emitterStars.parent == nil))
                [[Defs instance].objectFrontLayer addChild:emitterWarning];
        }
        
        if (emitterWarning)
            emitterWarning.position = ccp([MainScene instance].game.player.costume.position.x, [MainScene instance].game.player.costume.position.y +SCREEN_HEIGHT_HALF);
        
        timeWaiting += TIME_STEP;
        if (timeWaiting >= delayWaiting) {
            timeWaiting = 0;
            delayWaiting = delayWaitingDefault + CCRANDOM_0_1()*5;
            isShowing = YES;
            [self deleteEmitter];
            
            float _ran = CCRANDOM_MINUS1_1();
            if (_ran >= 0) {
                addSpeedCoeff = [Defs instance].speedWallAccelerationCoeff;
                [costume setColor:ccc3(0, 255, 0)];
                emitterStars = [CCParticleSystemQuad particleWithFile:@"speedWallAcceleration.plist"];
                
            } else {
                addSpeedCoeff = [Defs instance].speedWallDeccelerationCoeff;
                [costume setColor:ccc3(255, 0, 0)];
                emitterStars = [CCParticleSystemQuad particleWithFile:@"speedWallDecceleration.plist"];
            }
            positionChangeCoeff = ccp(0, SCREEN_HEIGHT);
            costume.position = ccp(costume.position.x, [MainScene instance].game.player.costume.position.y-SCREEN_HEIGHT);
            emitterStars.positionType = kCCPositionTypeGrouped;
            emitterStars.position = ccpAdd(costume.position, ccp(0, SCREEN_HEIGHT_HALF));
            if ((emitterStars)&&(emitterStars.parent == nil))
                [[Defs instance].objectFrontLayer addChild:emitterStars];
            [self show:YES];
        }
    }
}

- (void) deactivate {
    timeShowing = 0;
    timeWaiting = 0;
    isShowing = NO;
    isHiding = NO;
    [self deleteEmitter];
    [self deleteEmitterWarning];
    [self show:NO];
}

- (void) outOfArea {
	isOutOfArea = YES;
}

- (CGPoint) checkToCollide:(CGPoint)_position {
    if (isVisible) {
        if ((_position.x + elementRadius > costume.position.x - SCREEN_WIDTH)
            &&(_position.x - elementRadius < costume.position.x + SCREEN_WIDTH)
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
	else
		if (costume.parent) [costume removeFromParentAndCleanup:YES];
	
	isVisible = _flag;
}

@end
