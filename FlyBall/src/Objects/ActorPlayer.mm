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

@synthesize position;
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
        
        timeBonusSpeed = 0;
        delayBonusSpeed = 0;
        
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
        
        friction = 0.02f;
        
        isMayBlink = YES;
        blinkDelay = 1;
        blinkTime = 0;
        isEyeOpen = YES;
        
        isCrazyFace = NO;
        
        currShoesID = 0;
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"player_1.png"];
	[costume retain];
    
    sprArmor = [CCSprite spriteWithSpriteFrameName:@"helmet_1.png"];
    [sprArmor setAnchorPoint:ccp(0.5f,1)];
    [sprArmor setPosition:ccp(costume.contentSize.width*0.5f, costume.contentSize.height)];
    [sprArmor retain];
    
    sprShoes = [CCSprite spriteWithSpriteFrameName:@"boots_1.png"];
    [sprShoes setAnchorPoint:ccp(0.5f,0)];
    [sprShoes setPosition:ccp(costume.contentSize.width*0.5f, 0)];
    [sprShoes retain];
    
    sprGodMode = [CCSprite spriteWithSpriteFrameName:@"playerglow.png"];
    [sprGodMode retain];
    
    bonusCell = [CCSprite spriteWithSpriteFrameName:@"bonus_apocalypse.png"];
    [bonusCell retain];
    [bonusCell setPosition:ccp(costume.contentSize.width*0.5f, 20)];
    [bonusCell setScale:0.7f];
}

- (void) setCurrentBodySprite {
    CCSpriteFrame* frame = nil;
    if (bonusCell.parent) return;
    
    if (isCrazyFace) {
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_speed.png"];
    } else
    
    if (isEyeOpen)
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_1.png"];
    else
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_sleep_1.png"];
    
    if (frame) [costume setDisplayFrame:frame];
}

- (void) setArmorSprite {
    if (armored == 0) {
        if (sprArmor.parent) {
            [sprArmor removeFromParentAndCleanup:YES];
        }
    } else {
        [self showArmorSprite:YES];
        CCSpriteFrame* frame = nil;
        if (armored > 5)
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"helmet_5.png"];
        else
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"helmet_%i.png", armored]];
        if (frame) [sprArmor setDisplayFrame:frame];
    }
}

- (void) setShoesSprite {
    if (currShoesID == [Defs instance].playerSpeedLimitLevel) return;
    currShoesID = [Defs instance].playerSpeedLimitLevel;
    CCSpriteFrame* frame = nil;
    if (currShoesID > 0) {
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"boots_%i.png", [Defs instance].playerSpeedLimitLevel]];
    }
    if (frame) [sprShoes setDisplayFrame:frame];
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

- (void) setSpeedBonus:(float)_bonusSpeedTime {
    isBonusSpeed = YES;
    delayBonusSpeed += _bonusSpeedTime;
    if (emitterBonusSpeedFire) {
        if (!emitterBonusSpeedFire.parent) {
            [emitterBonusSpeedFire resetSystem];
            [emitterBonusSpeedFire setPosition:position];
            [emitterBonusSpeedFire scheduleUpdate];
            if (emitterBonusSpeedFire.parent == nil) {
                [[Defs instance].objectFrontLayer addChild:emitterBonusSpeedFire z:50];
            }
        }
    }
}

- (void) setBonusCell:(int)_bonusID {
    [bonusCellItemIDs addObject:[NSNumber numberWithInteger:_bonusID]];
    [self showBonusCell:YES];
}

- (void) showShoesSprite:(BOOL)_flag {
    if (_flag) {
        if ((currShoesID > 0)&&(!sprShoes.parent)) [costume addChild:sprShoes];
    } else {
        if (sprShoes.parent) [sprShoes removeFromParent];
    }
}

- (void) showArmorSprite:(BOOL)_flag {
    if (_flag) {
        if ((armored > 0)&&(!sprArmor.parent)) [costume addChild:sprArmor];
    } else {
        if (sprArmor.parent) [sprArmor removeFromParent];
    }
}

- (void) showBonusCell:(BOOL)_flag {
    if (_flag) {
        if (([bonusCellItemIDs count] > 0)&&(!bonusCell.parent)) {
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_bonus_apocalipsys.png"];
            if (frame) [costume setDisplayFrame:frame];
            [costume addChild:bonusCell z:costume.zOrder];
        }
    } else {
        if (bonusCell.parent) {
            [bonusCell removeFromParent];
        }
    }
}

- (void) showGodModeSprite:(BOOL)_flag {
    if (_flag) {
        if ((isGodMode)&&(!sprGodMode.parent)) [parentFrame addChild:sprGodMode z:costume.zOrder-1];
    } else {
        if (sprGodMode.parent) [sprGodMode removeFromParent];
    }
}


- (void) setCrazyFace {
    isCrazyFace = YES;
    timeCrazyFace = 0;
    
    [self setCurrentBodySprite];
}

- (void) hideBonusSpeedFire {
    if (emitterBonusSpeedFire) {
        [emitterBonusSpeedFire unscheduleUpdate];
        if (emitterBonusSpeedFire.parent) [emitterBonusSpeedFire removeFromParentAndCleanup:NO];
    }
}

- (void) show:(BOOL)_flag {
    [super show:_flag];
    
    if (_flag) {
        if (!emitterEngineFire.parent) {
            [emitterEngineFire scheduleUpdate];
            if (emitterEngineFire.parent == nil) {
                [[Defs instance].objectFrontLayer addChild:emitterEngineFire z:50];
            }
        }
    } else {
        if (emitterEngineFire.parent) {
            [emitterEngineFire unscheduleUpdate];
            if (emitterEngineFire.parent) [emitterEngineFire removeFromParentAndCleanup:NO];
        }
        
        [self hideBonusSpeedFire];
    }
    
    [self showGodModeSprite:_flag];
    [self showBonusCell:_flag];
    [self showShoesSprite:_flag];
    [self showArmorSprite:_flag];
}

- (void) setStartAmmunition {
    [self setShoesSprite];
}

- (void) activate {
    [super activate];
    [self hideBonusSpeedFire];
    
    costume.position = ccp(SCREEN_WIDTH_HALF, SCREEN_HEIGHT_HALF);
    position = costume.position;
    costume.rotation = 0;
    
    emitterEngineFire.position = position;
    emitterEngineFire.speed = 0;
    
    isBonusSpeed = NO;
    timeBonusSpeed = 0;
    
    isGodMode = NO;
    isCrazyFace = NO;
    timeCrazyFace = 0;
    
    isMayBlink = YES;
    blinkDelay = 1;
    blinkTime = 0;
    isEyeOpen = YES;
    [self setCurrentBodySprite];
    [self setShoesSprite];
}

- (void) deactivate {
    isGodMode = NO;
    [self showGodModeSprite:NO];
    [self showBonusCell:NO];
    [bonusCellItemIDs removeAllObjects];
    armored = [Defs instance].playerArmorLevel;
    [self setArmorSprite];
    
    [super deactivate];
}

- (void) setPosition:(CGPoint)_position {
    position = _position;
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

- (void) addVelocity:(CGPoint)_value {
    [super addVelocity:_value];
    
    if (velocity.y > [Defs instance].playerSpeedLimit) velocity.y = [Defs instance].playerSpeedLimit;
    
    if (_value.y > 4) [self setCrazyFace];
}

- (void) update {
    if (isBonusSpeed) {
        [self addVelocity:ccp(0, [Defs instance].bonusAccelerationPower)];
    }
    
    CGPoint _oldPosition = position;
    costume.position = position;
    [super update];
    
    position = costume.position;
    
    if (velocity.y < -3) velocity.y = -3;
    
    if (velocity.x > friction) velocity.x -= friction; else
        if (velocity.x < -friction) velocity.x += friction;
    
    if ((position.x < -204 + elementRadius)||(position.x > 524 - elementRadius)) velocity.x = -velocity.x*0.7f;
    
    if ((position.x < -194 + elementRadius)&&(velocity.x < 0.5f)) velocity.x = 0.5f;
    if ((position.x > 514 - elementRadius)&&(velocity.x > -0.5f)) velocity.x = -0.5f;
    
    // Visual part
    
    costume.rotation = -[Utils GetAngleBetweenPt1:_oldPosition andPt2:position]-90;
    
    if (emitterEngineFire) {
        emitterEngineFire.position = position;
        emitterEngineFire.speed = 30*[[Utils instance] distance:position.x _y1:position.y _x2:_oldPosition.x _y2:_oldPosition.y];
        if (emitterEngineFire.speed < 50) emitterEngineFire.speed = 50; else
            if (emitterEngineFire.speed > 1500) emitterEngineFire.speed = 1500;
        emitterEngineFire.angle = [Utils GetAngleBetweenPt1:_oldPosition andPt2:position];
    }
    
    if (isGodMode) {
        if (sprGodMode.scale < 1.2f) {
            sprGodMode.scale += 0.1f;
        }
        
        [sprGodMode setPosition:position];
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
        costume.position = ccp(position.x + CCRANDOM_MINUS1_1()*[Defs instance].bonusAccelerationPower*6, position.y + CCRANDOM_MINUS1_1()*[Defs instance].bonusAccelerationPower*6);
        
        if (emitterBonusSpeedFire) {
            if (emitterEngineFire) {
                emitterBonusSpeedFire.position = position;
                emitterBonusSpeedFire.speed = emitterEngineFire.speed;
                emitterBonusSpeedFire.angle = emitterEngineFire.angle;
            }
        }
        
        timeBonusSpeed += TIME_STEP;
        if (timeBonusSpeed >= delayBonusSpeed) {
            isBonusSpeed = NO;
            timeBonusSpeed = 0;
            delayGodMode = 0;
            delayBonusSpeed = 0;
            [self hideBonusSpeedFire];
        }
    }
    
    if (isCrazyFace) {
        timeCrazyFace += TIME_STEP;
        if (timeCrazyFace >= 0.4f) {
            isCrazyFace = NO;
            [self setCurrentBodySprite];
        }
    } else
        if (isMayBlink ) {
            blinkTime += TIME_STEP;
            if (blinkTime >= blinkDelay) {
                isEyeOpen = !isEyeOpen;
                if (isEyeOpen) blinkDelay = 1 + CCRANDOM_0_1()*3; else blinkDelay = 0.2f + CCRANDOM_0_1()*0.4f;
                [self setCurrentBodySprite];
                blinkTime = 0;
            }
        }
}

- (CGPoint) magnetReaction:(CGPoint)_point {
    float _dist = [[Utils instance] distance:position.x _y1:position.y _x2:_point.x _y2:_point.y];
    if (_dist <= [Defs instance].playerMagnetDistance) {
        float _angle = CC_DEGREES_TO_RADIANS([Utils GetAngleBetweenPt1:position andPt2:_point]);
        return _point = ccp(magnetPower*cos(_angle), magnetPower*sin(_angle));
    }
    return CGPointZero;
}

- (void) touch {
    if ([bonusCellItemIDs count] > 0) {
        [[MainScene instance].game doBonusEffect:[[bonusCellItemIDs objectAtIndex:0] integerValue]];
        [bonusCellItemIDs removeObjectAtIndex:0];
        if ([bonusCellItemIDs count] == 0) {
            [self showBonusCell:NO];
            [self setCurrentBodySprite];
        }
    }
}

@end
