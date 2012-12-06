//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleBonus.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleBonus

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        bonusID = 0;
        [self loadCostume];
        
        costume.position = _location;
	}
	return self;
}

- (void) loadCostume {
    costume = [CCSprite spriteWithSpriteFrameName:@"bonus_speed.png"];
	[costume retain];
}

- (void) setCoins {
    bonusID = BONUS_COINS;
    CCSpriteFrame* frame = nil;
    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"coin.png"];
    if (frame != nil) [costume setDisplayFrame:frame];
}

- (void) setRandomBonus {
    CCSpriteFrame* frame = nil;
    int _ran = (int)round(CCRANDOM_0_1()*BONUS_RANDOM_RANGE);
    if (_ran <= BONUS_SLOWMOTION) {
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_slowmotion.png"];
        bonusID = BONUS_SLOWMOTION;
    } else
        if (_ran <= BONUS_ACCELERATION) {
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_speed.png"];
            bonusID = BONUS_ACCELERATION;
        } else
            if (_ran <= BONUS_APOCALYPSE) {
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_apocalypse.png"];
                bonusID = BONUS_APOCALYPSE;
            } else
                if (_ran <= BONUS_GODMODE) {
                    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_godmode.png"];
                    bonusID = BONUS_GODMODE;
                }

    if (frame != nil) [costume setDisplayFrame:frame];
}

- (void) eraserCollide {
	if ((!isEraserCollide)&&(!isOutOfArea)&&(!isDying)){
        isEraserCollide = YES;
        ++[Defs instance].totalDeadBloxCounter;
        [self getAchievement];
		// play sound
        
        if (![Defs instance].isSoundMute) {
            switch (bonusID) {
                case BONUS_COINS:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    break;
                case BONUS_SLOWMOTION:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    break;
                case BONUS_ACCELERATION:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    break;
                    
                case BONUS_APOCALYPSE:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"star.wav"];
                    break;
                    
                case BONUS_GODMODE:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"god_mode.wav"];
                    break;
                    
                default:
                    break;
            }
        }
        
        switch (bonusID) {
            case BONUS_COINS:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bonus_coin_get.plist"];
                break;
                
            case BONUS_SLOWMOTION:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bonus_armor_get.plist"];
            break;
                
            case BONUS_ACCELERATION:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bonus_acceleration_get.plist"];
                break;
                
            case BONUS_APOCALYPSE:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bonus_apocalypse_get.plist"];
                break;
                
            case BONUS_GODMODE:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bonus_godmode_get.plist"];
                break;
        }
        
        emitterBoom.position = ccpAdd(costume.position, [Defs instance].objectFrontLayer.position);
        if ((emitterBoom)&&(emitterBoom.parent == nil))
            [[MainScene instance].game addChild:emitterBoom];
        
        [self deactivate];
	}
}

- (void) touch {
    [[MainScene instance].game bonusTouchReaction:bonusID];
    if (emitterBoom) {
        [emitterBoom resetSystem];
        [emitterBoom stopSystem];
        if (emitterBoom.parent) [emitterBoom removeFromParentAndCleanup:YES];
        emitterBoom = nil;
    }
    [self eraserCollide];
}

@end
