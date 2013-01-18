//
//  ActorCircle.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 29.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ActorCircleLaunchBomb.h"
#import "Utils.h"
#import "Defs.h"
#import "globalParam.h"
#import "MainScene.h"
#import "SimpleAudioEngine.h"

@implementation ActorCircleLaunchBomb

-(id) init:(CCNode*)_parent
 _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
	
        [self loadCostume];
        
        costume.position = _location;
        
        timerFire = 0;
        delayFire = 0.1f;
        
        level = 0;
	}
	return self;
}

- (void) update:(ccTime)dt {
    if (!isActive) return;
    
    timerFire += TIME_STEP;
    if (timerFire >= delayFire) {
        [fireSpr setOpacity:100 + int(CCRANDOM_0_1()*155)];
        //[fireSpr setVisible:!fireSpr.visible];
        timerFire = 0;
    }
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"launchBomb_0.png"];
	[costume retain];
    
    fireSpr = [CCSprite spriteWithSpriteFrameName:@"bombfire.png"];
    [fireSpr setPosition:ccp(70, 79)];
    [costume addChild:fireSpr];
}

- (void) eraserCollide {
	if (!isEraserCollide){
        isEraserCollide = YES;
        
		// play sound
        
        if (![Defs instance].isSoundMute) {
            switch ((int)round(CCRANDOM_0_1()*2)) {
                case 0:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"square_bomb_1.wav"];
                    break;
                case 1:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"square_bomb_2.wav"];
                    break;
                    
                default:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"square_bomb_3.wav"];
                    break;
            }
        }
        
        int _ran = round(CCRANDOM_0_1()*7);
        switch (_ran) {
            case 0:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion.plist"];
                break;
                
            case 1:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_115.plist"];
                break;
                
            case 2:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_155.plist"];
                break;
                
            case 3:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_yellow.plist"];
                break;
                
            case 4:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_055.plist"];
                break;
                
            case 5:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_005.plist"];
                break;
                
            case 6:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_010.plist"];
                break;
                
            default:
                emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_purple.plist"];
                break;
        }
        
        emitterBoom.position = ccpAdd(costume.position, [Defs instance].objectFrontLayer.position);
        if ((emitterBoom)&&(emitterBoom.parent == nil))
            [[MainScene instance].game addChild:emitterBoom];
        
        [self deactivate];
	}
}

- (void) getCurrentSprite {
    if (level != [Defs instance].launchBombLevel) {
        level = [Defs instance].launchBombLevel;
        CCSpriteFrame* frame = nil;
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"launchBomb_0.png"];
        if (frame != nil) [costume setDisplayFrame:frame];
    }
}

- (void) activate {
    [super activate];
    
    isEraserCollide = NO;
    isOutOfArea = NO;
    
    [self getCurrentSprite];

    velocity = ccp(0, 4 + level*4);
    
    [self show:YES];
}

- (void) touch {
    [self eraserCollide];
}

@end
