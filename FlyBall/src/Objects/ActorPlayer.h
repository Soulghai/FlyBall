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
    float timeGodModeAfterCrash;
    
    CCSprite *bonusCell;
    NSMutableArray* bonusCellItemIDs;
    
    CCParticleSystemQuad *emitterEngineFire;
    
    float magnetDistance;
    float magnetPower;
}
-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) loadCostume;
- (void) addArmor;
- (void) setGodMode:(float)_godModeTime;
- (void) setBonusCell:(int)_bonusID;
- (CGPoint) magnetReaction:(CGPoint)_point;
@end
