//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorPlayer.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorPlayer

@synthesize isBonusSpeed;

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
        [self loadCostume];
        
        zCoord = ZCOORD_OBJECTS;
        
        costume.position = _location;
        
        timeGodMode = 0;
        delayGodMode = 0;
        armored = 0;
        isGodMode = 0;
        
        magnetDistance = [Defs instance].playerMagnetDistance;
        magnetPower = [Defs instance].playerMagnetPower;
        
        bonusCellItemIDs = [NSMutableArray arrayWithCapacity:5];
        [bonusCellItemIDs retain];
        
        emitterEngineFire = [CCParticleSystemQuad particleWithFile:@"shipFire.plist"];
        emitterEngineFire.positionType = kCCPositionTypeFree;
        emitterEngineFire.position = costume.position;
        [emitterEngineFire retain];
        [emitterEngineFire unscheduleUpdate];
        
        emitterBonusSpeedFire = [CCParticleSystemQuad particleWithFile:@"shipBonusSpeed.plist"];
        emitterBonusSpeedFire.positionType = kCCPositionTypeFree;
        emitterBonusSpeedFire.position = costume.position;
        [emitterBonusSpeedFire retain];
        [emitterBonusSpeedFire unscheduleUpdate];
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"player.png"];
	[costume retain];
    
    sprGodMode = [CCSprite spriteWithSpriteFrameName:@"playerglow.png"];
    [sprGodMode retain];
    
    bonusCell = [CCSprite spriteWithSpriteFrameName:@"bonus_apocalypse.png"];
    [bonusCell retain];
    [bonusCell setPosition:ccp(elementRadius, elementRadius)];
}

- (void) setArmorSprite {
    CCSpriteFrame* frame;
    if (armored == 0) {
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player.png"];
    } else
    if (armored > 3)
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_armor_3.png"];
    else
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"player_armor_%i.png", armored]];
    [costume setDisplayFrame:frame];
}

- (void) addArmor {
    ++armored;
    [self setArmorSprite];
}

- (void) setGodMode:(float)_godModeTime {
    isGodMode = YES;
    delayGodMode += _godModeTime;
    [self showGodModeSprite:YES];
    [sprGodMode setColor:ccc3(255, 180, 0)];
    [sprGodMode setScale:0.1f];
    CCLOG(@"[GOD MODE:ON]");
}

- (void) setSpeedBonus {
    isBonusSpeed = YES;
    timeBonusSpeed = 0;
    if (emitterBonusSpeedFire) {
        [emitterBonusSpeedFire scheduleUpdate];
        if (emitterBonusSpeedFire.parent == nil) {
            [[Defs instance].objectFrontLayer addChild:emitterBonusSpeedFire z:50];
        }
    }
}

- (void) setBonusCell:(int)_bonusID {
    [bonusCellItemIDs addObject:[NSNumber numberWithInteger:_bonusID]];
    [self showBonusCell:YES];
}

- (void) showBonusCell:(BOOL)_flag {
    if (_flag) {
        if (([bonusCellItemIDs count] > 0)&&(!bonusCell.parent)) [costume addChild:bonusCell z:costume.zOrder];
    } else {
        if (bonusCell.parent) [bonusCell removeFromParent];
    }
}

- (void) showGodModeSprite:(BOOL)_flag {
    if (_flag) {
        if ((isGodMode)&&(!sprGodMode.parent)) [parentFrame addChild:sprGodMode z:costume.zOrder-1];
    } else {
        if (sprGodMode.parent) [sprGodMode removeFromParent];
    }
}

- (void) show:(BOOL)_flag {
    [super show:_flag];
    
    if (_flag) {
        if (emitterEngineFire) {
            [emitterEngineFire scheduleUpdate];
            if (emitterEngineFire.parent == nil) {
                [[Defs instance].objectFrontLayer addChild:emitterEngineFire z:50];
            }
        }
    } else {
        if (emitterEngineFire) {
            [emitterEngineFire unscheduleUpdate];
            if (emitterEngineFire.parent) [emitterEngineFire removeFromParentAndCleanup:NO];
        }
        
        if (emitterBonusSpeedFire) {
            [emitterBonusSpeedFire unscheduleUpdate];
            if (emitterBonusSpeedFire.parent) [emitterBonusSpeedFire removeFromParentAndCleanup:NO];
        }
    }
    
    [self showGodModeSprite:_flag];
    [self showBonusCell:_flag];
}

- (void) activate {
    [super activate];
    
    isBonusSpeed = NO;
    timeBonusSpeed = 0;
}

- (void) deactivate {
    [self showGodModeSprite:NO];
    [self showBonusCell:NO];
    [bonusCellItemIDs removeAllObjects];
    armored = 0;
    [self setArmorSprite];
    
    [super deactivate];
}

- (void) eraserCollide {
    if (isGodMode) return;
    if (armored > 0) {
        --armored;
        [self setArmorSprite];
        [self setGodMode:[Defs instance].playerGodModeAfterCrashTime];
        return;
    }
    
    [super eraserCollide];
}

- (void) update {
    CGPoint _oldPosition = costume.position;
    [super update];
    
    if (emitterEngineFire) {
        emitterEngineFire.position = costume.position;
        emitterEngineFire.speed = 30*[[Utils instance] distance:costume.position.x _y1:costume.position.y _x2:_oldPosition.x _y2:_oldPosition.y];
        emitterEngineFire.angle = [Utils GetAngleBetweenPt1:_oldPosition andPt2:costume.position];
    }
    
    if (isGodMode) {
        if (sprGodMode.scale < 1.2f) {
            sprGodMode.scale += 0.1f;
        }
        
        [sprGodMode setPosition:costume.position];
        sprGodMode.rotation += 5;
        if (sprGodMode.rotation > 360) sprGodMode.rotation -= 360;
        
        timeGodMode += TIME_STEP;
        if (timeGodMode >= delayGodMode) {
            timeGodMode = 0;
            isGodMode = NO;
            delayGodMode = 0;
            [self showGodModeSprite:NO];
            CCLOG(@"[GOD MODE:OFF]");
        }
    }
    
    if (isBonusSpeed) {
        [self addVelocity:ccp(0, [Defs instance].bonusAccelerationValue)];
        
        if (emitterBonusSpeedFire) {
            if (emitterEngineFire) {
                emitterBonusSpeedFire.position = costume.position;
                emitterBonusSpeedFire.speed = emitterEngineFire.speed;
                emitterBonusSpeedFire.angle = emitterEngineFire.angle;
            }
        }
        
        timeBonusSpeed += TIME_STEP;
        if (timeBonusSpeed >= [Defs instance].bonusAccelerationDelay) {
            isBonusSpeed = NO;
            timeBonusSpeed = 0;
            if (emitterBonusSpeedFire) {
                [emitterBonusSpeedFire unscheduleUpdate];
                if (emitterBonusSpeedFire.parent) [emitterBonusSpeedFire removeFromParentAndCleanup:NO];
            }
        }
    }

}

- (CGPoint) magnetReaction:(CGPoint)_point {
    float _dist = [[Utils instance] distance:costume.position.x _y1:costume.position.y _x2:_point.x _y2:_point.y];
    if (_dist < magnetDistance) {
        float _angle = CC_DEGREES_TO_RADIANS([Utils GetAngleBetweenPt1:costume.position andPt2:_point]);
        return _point = ccp(magnetPower*cos(_angle), magnetPower*sin(_angle));
    }
    return CGPointZero;
}

- (void) touch {
    if ([bonusCellItemIDs count] > 0) {
        [[MainScene instance].game doBonusEffect:[[bonusCellItemIDs objectAtIndex:0] integerValue]];
        [bonusCellItemIDs removeObjectAtIndex:0];
        if ([bonusCellItemIDs count] == 0) [self showBonusCell:NO];
    }
}

@end
