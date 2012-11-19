//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircle.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircle

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	

        [self loadCostume];
        
        costume.position = _location;
        
        timeGodMode = 0;
        delayGodMode = 0;
        armored = 0;
        isGodMode = 0;
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"player.png"];
	[costume retain];
    
    sprGodMode = [CCSprite spriteWithSpriteFrameName:@"playerglow.png"];
    [sprGodMode retain];
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
    [sprGodMode setScale:1.5f];
    CCLOG(@"[GOD MODE:ON]");
}

- (void) showGodModeSprite:(BOOL)_flag {
    if (_flag) {
        if (!sprGodMode.parent) [parentFrame addChild:sprGodMode z:costume.zOrder];
    } else {
        if (sprGodMode.parent) [sprGodMode removeFromParent];
    }
}

- (void) show:(BOOL)_flag {
    [super show:_flag];
    if (_flag) {
        if (isGodMode) [self showGodModeSprite:YES];
    } else 
        [self showGodModeSprite:NO];
}

- (void) deactivate {
    [self showGodModeSprite:NO];
    
    [super deactivate];
}

- (void) eraserCollide {
    if (isGodMode) return;
    if (armored > 0) {
        --armored;
        [self setArmorSprite];
        return;
    }
    
    [super eraserCollide];
}

- (void) childSpecUpdate {
    [super childSpecUpdate];
    
    if (isGodMode) {
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
}

@end
