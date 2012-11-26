//
//  ActorCircle.h
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActorActiveObject.h"

@interface ActorPlayer : ActorActiveObject {
    int armored;
    
    float timeGodMode;
    float delayGodMode;
    BOOL isGodMode;
    CCSprite *sprGodMode;
    
    BOOL isBonusSpeed;
    float timeBonusSpeed;
    float delayBonusSpeed;
    
    CCSprite *bonusCell;
    NSMutableArray* bonusCellItemIDs;
    
    CCParticleSystemQuad *emitterEngineFire;
    CCParticleSystemQuad *emitterBonusSpeedFire;
    
    float magnetDistance;
    float magnetPower;
}

@property(nonatomic, readonly) BOOL isBonusSpeed;

-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) loadCostume;
- (void) addArmor;
- (void) setGodMode:(float)_godModeTime;
- (void) setSpeedBonus:(float)_bonusSpeedTime;
- (void) setBonusCell:(int)_bonusID;
- (CGPoint) magnetReaction:(CGPoint)_point;
@end
