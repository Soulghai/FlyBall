//
//  ActorActiveObject.m
//  IncredibleBlox
//
//  Created by Mac Mini on 26.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActorActiveObject.h"
#import "SimpleAudioEngine.h"
#import "globalParam.h"
#import "Defs.h"
#import "Utils.h"
#import "MainScene.h"
#import "GameCenter.h"

@implementation ActorActiveObject

@synthesize isDying;
@synthesize velocity;

-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location {
	
	if ((self = [super init])) {
		parentFrame = _parent;
		
		isDying = NO;
		
		touchCounter = 0;
        
        isEraserCollide = NO;
        
        velocity = CGPointZero;
        gravitation = GRAVITATION_DEFAULT;
	}
	
	return self;
}

- (void) dealloc {
    if (emitterBoom) {
        [emitterBoom resetSystem];
        [emitterBoom stopSystem];
        [emitterBoom removeFromParentAndCleanup:YES];
        emitterBoom = nil;
    }
    
    [super dealloc];
}

- (void) loadCostume {
}

- (void) createStuff {
	if (!costume) {				
		[self loadCostume];
		spriteWidth = costume.contentSize.width;
		spriteHeight = costume.contentSize.height;
	}
}

- (void) outOfArea {
	[super outOfArea];
	[self deactivate];
}

- (void) activate {
    [super activate];

}

- (void) deactivate {
    isVisible = NO;
    isActive = NO;
    velocity = CGPointZero;
    isEraserCollide = NO;
    isOutOfArea = NO;
    
    if (costume.parent) [costume removeFromParentAndCleanup:NO];
}

- (void) eraserCollide {
	if ((!isEraserCollide)&&(!isOutOfArea)&&(!isDying)){
        isEraserCollide = YES;
        ++[Defs instance].totalDeadBloxCounter;
        [self getAchievement];
		// play sound
        
        if (![Defs instance].isSoundMute) {
            switch ((int)round(CCRANDOM_0_1()*1)) {
                case 0:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"round_bomb_2.wav"];
                    break;
                case 1:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"round_bomb_3.wav"];
                    break;
                    
                default:
                    [[SimpleAudioEngine sharedEngine] playEffect:@"triangle_bomb_3.wav"];
                    break;
            }
        }
        emitterBoom = [CCParticleSystemQuad particleWithFile:@"bomb_explosion_yellow.plist"];
        emitterBoom.position = costume.position;
        //emitterBoom.autoRemoveOnFinish = YES;
        if ((emitterBoom)&&(emitterBoom.parent == nil))
            [[Defs instance].objectFrontLayer addChild:emitterBoom];
        
        [self deactivate];
	}	
}

- (void) addVelocity:(CGPoint)_value {
    velocity = ccp(velocity.x+_value.x, velocity.y+_value.y);
    //velocity = ccp(MAX(velocity.x, _value.x), MAX(velocity.y, _value.y));
}

- (void) update:(ccTime)dt {
    if (!isActive) return;
    
    costume.position = ccp(costume.position.x+velocity.x*dt, costume.position.y+velocity.y*dt);
    
    //Действуем на шарик гравитацией
    velocity.y -= gravitation*dt;
	
	[super update:dt];
}

- (void) removeCostume {
	[self show:NO];
	[super removeCostume];
}

- (void) getAchievement {
    if ((![Defs instance].achievement_Expand_10)&&([Defs instance].totalTouchBloxCounter >= 10)) {
        [Defs instance].achievement_Expand_10 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Expand_10" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Expand_100)&&([Defs instance].totalTouchBloxCounter >= 100)) {
        [Defs instance].achievement_Expand_100 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Expand_100" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Expand_1000)&&([Defs instance].totalTouchBloxCounter >= 1000)) {
        [Defs instance].achievement_Expand_1000 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Expand_1000" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Expand_2500)&&([Defs instance].totalTouchBloxCounter >= 2500)) {
        [Defs instance].achievement_Expand_2500 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Expand_2500" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Lost_100)&&([Defs instance].totalDeadBloxCounter >= 100)) {
        [Defs instance].achievement_Lost_100 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Lost_100" percentComplete:100];
    }
}

- (void) touch {

}

- (void) addToField:(CGPoint)_point
          _velocity:(CGPoint)_velocity {
    costume.position = _point;
    [self addVelocity:_velocity];
    
    if (emitterBoom) {
        [emitterBoom resetSystem];
        [emitterBoom stopSystem];
        if (emitterBoom.parent) [emitterBoom removeFromParentAndCleanup:YES];
        emitterBoom = nil;
    }
}

@end