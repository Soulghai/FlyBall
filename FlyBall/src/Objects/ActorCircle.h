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

@interface ActorCircle : ActorActiveObject {
    int armored;
    
    float timeGodMode;
    float delayGodMode;
    BOOL isGodMode;
    CCSprite *sprGodMode;
    
    CCParticleSystemQuad *emitterEngineFire;
}
-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) loadCostume;
- (void) addArmor;
- (void) setGodMode:(float)_godModeTime;
@end
