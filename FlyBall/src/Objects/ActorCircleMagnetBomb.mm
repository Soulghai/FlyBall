//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleMagnetBomb.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleMagnetBomb

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        [self loadCostume];
        
        costume.position = _location;
        magnetDistance = SCREEN_WIDTH_HALF;
        magnetPower = 0.2f;
        currSpriteFrame = 0;
        isWorking = NO;
	}
	return self;
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"player_armor_3.png"];
	[costume retain];
}

- (void) setSpriteFrame:(int)_spriteFrame {
    if (currSpriteFrame == _spriteFrame) return;
    currSpriteFrame = _spriteFrame;
    
    CCSpriteFrame* _frame = nil;
    switch (currSpriteFrame) {
        case 0:
            _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bomb_circle.png"];
            break;
        case 1:
            _frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"player_armor_3.png"];
            break;
            
        default:
            break;
    }
    if (_frame) [costume setDisplayFrame:_frame];
}

- (CGPoint) magnetReaction:(CGPoint)_point {
    float _dist = [[Utils instance] distance:costume.position.x _y1:costume.position.y _x2:_point.x _y2:_point.y];
    if (_dist <= magnetDistance) {
        isWorking = YES;
        float _angle = CC_DEGREES_TO_RADIANS([Utils GetAngleBetweenPt1:costume.position andPt2:_point]);
        return _point = ccp(magnetPower*cos(_angle), magnetPower*sin(_angle));
    }
    isWorking = NO;
    return CGPointZero;
}

- (void) update {
    if (!isActive) return;
    
    [costume setRotation:costume.rotation + rotationSpeed];
    if (costume.rotation > 360) costume.rotation -= 360; else
        if (costume.rotation < 0) costume.rotation += 360;
    
    if (isWorking) [self setSpriteFrame:1]; else [self setSpriteFrame:0];
    
    [super update];
}

- (void) addVelocity:(CGPoint)_value {
    if (_value.x > 0) rotationSpeed = CCRANDOM_0_1()*3;
    else rotationSpeed = -CCRANDOM_0_1()*3;
    [super addVelocity:_value];
}

@end
