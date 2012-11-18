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
    costume = [CCSprite spriteWithSpriteFrameName:@"bonus_armor.png"];
	[costume retain];
}

- (void) setRandomBonus {
    
    CCSpriteFrame* frame;
    int _ran = (int)round(CCRANDOM_0_1()*BONUS_GODMODE);
    bonusID = _ran;
    if (bonusID <= BONUS_ARMOR) {
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_armor.png"];
        bonusID = BONUS_ARMOR;
    } else
        if (bonusID <= BONUS_ACCELERATION) {
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_speed.png"];
            bonusID = BONUS_ACCELERATION;
        } else
            if (bonusID <= BONUS_APOCALYPSE) {
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_apocalypse.png"];
                bonusID = BONUS_APOCALYPSE;
            } else
                if (bonusID <= BONUS_GODMODE) {
                    frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bonus_fire.png"];
                    bonusID = BONUS_GODMODE;
                }

    [costume setDisplayFrame:frame];
}

- (void) touch {
    [[MainScene instance].game bonusTouchReaction:bonusID];
    [self deactivate];
}

@end
