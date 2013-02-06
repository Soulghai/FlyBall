//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleTimeBomb.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleTimeBomb

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        [self loadCostume];
        
        costume.position = _location;
        timeBomb = 0;
        delayBomb = 2;
        currSpriteFrame = 0;
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"bombtime_1.png"];
	[costume retain];
}

- (void) activate {
    timeBomb = 0;
    [super activate];
}

- (void) setSpriteFrame:(int)_spriteFrame {
    if ((currSpriteFrame == _spriteFrame)||(currSpriteFrame == int(delayBomb))) return;
    currSpriteFrame = _spriteFrame;
    
    CCSpriteFrame* _frame = nil;
    switch (currSpriteFrame) {
        case 0:
            _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bombtime_1.png"];
            break;
        case 1:
            _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bombtime_2.png"];
            break;
        case 2:
            _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bombtime_3.png"];
            break;
            
        default:
            break;
    }
    if (_frame) [costume setDisplayFrame:_frame];
}

- (void) update:(ccTime)dt {
    if (!isActive) return;
    
    [costume setRotation:costume.rotation + rotationSpeed];
    if (costume.rotation > 360) costume.rotation -= 360; else
        if (costume.rotation < 0) costume.rotation += 360;
    
    timeBomb += TIME_STEP;
    if (timeBomb >= delayBomb) {
        [self touch];
        timeBomb = 0;
        return;
    }
    [self setSpriteFrame:(int)timeBomb];
    
    [super update:dt];
}

- (void) addVelocity:(CGPoint)_value {
    if (_value.x > 0) rotationSpeed = CCRANDOM_0_1()*3;
    else rotationSpeed = -CCRANDOM_0_1()*3;
    [super addVelocity:_value];
}

@end
