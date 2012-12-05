//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleBomb.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleBomb

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        [self loadCostume];
        
        costume.position = _location;
        
        timerFire = 0;
        delayFire = 0.1f;
	}
	return self;
}

- (void) update {
    if (!isActive) return;
    
    [costume setRotation:costume.rotation + rotationSpeed];
    if (costume.rotation > 360) costume.rotation -= 360; else
        if (costume.rotation < 0) costume.rotation += 360;
    
    timerFire += TIME_STEP;
    if (timerFire >= delayFire) {
        [fireSpr setOpacity:100 + int(CCRANDOM_0_1()*155)];
        //[fireSpr setVisible:!fireSpr.visible];
        timerFire = 0;
    }
    
    
    [super update];
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"bomb.png"];
	[costume retain];
    
    fireSpr = [CCSprite spriteWithSpriteFrameName:@"bombfire.png"];
    [fireSpr setPosition:ccp(50, 59)];
    [costume addChild:fireSpr];
}

- (void) addVelocity:(CGPoint)_value {
    if (_value.x > 0) rotationSpeed = CCRANDOM_0_1()*3;
    else rotationSpeed = -CCRANDOM_0_1()*3;
    [super addVelocity:_value];
}

@end
