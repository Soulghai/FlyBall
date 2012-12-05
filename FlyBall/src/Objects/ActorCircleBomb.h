//
//  ActorCircle.h
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ActorActiveBombObject.h"

@interface ActorCircleBomb : ActorActiveBombObject {
    float rotationSpeed;
    CCSprite *fireSpr;
    float timerFire;
    float delayFire;
}
-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) loadCostume;
@end
