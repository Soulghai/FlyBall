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
#import "BoomManager.h"

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
    
    /*timerFire += TIME_STEP;
    if (timerFire >= delayFire) {
        [fireSpr setOpacity:100 + int(CCRANDOM_0_1()*155)];
        timerFire = 0;
    }*/
}

- (void) loadCostume {
	costume = [CCSprite spriteWithSpriteFrameName:@"launchBomb_0.png"];
	[costume retain];
    
    /*fireSpr = [CCSprite spriteWithSpriteFrameName:@"bombfire.png"];
    [fireSpr setPosition:ccp(70, 79)];
    [costume addChild:fireSpr];*/
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
        
        [[BoomManager instance] add:costume.position _z:costume.zOrder];
        
        [self deactivate];
	}
}

- (void) getCurrentSprite {
    if (level != [Defs instance].launchBombLevel) {
        level = [Defs instance].launchBombLevel;
        CCSpriteFrame* frame = nil;
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"launchBomb_%i.png",level]];
        if (frame != nil) [costume setDisplayFrame:frame];
    }
}

- (void) activate {
    [super activate];
    
    isEraserCollide = NO;
    isOutOfArea = NO;
    
    [self getCurrentSprite];

    velocity = ccp(0, 7 + level*5);
    
    [self show:YES];
}

- (void) touch {
    [self eraserCollide];
}

@end
