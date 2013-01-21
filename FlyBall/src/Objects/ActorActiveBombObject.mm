//
//  ActorActiveObject.m
//  IncredibleBlox
//
//  Created by Mac Mini on 26.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActorActiveBombObject.h"
#import "SimpleAudioEngine.h"
#import "globalParam.h"
#import "Defs.h"
#import "Utils.h"
#import "MainScene.h"
#import "GameCenter.h"
#import "BoomManager.h"

@implementation ActorActiveBombObject

-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location {
	
	if ((self = [super init:_parent _location:_location])) {
		parentFrame = _parent;
		
		isDying = NO;
		
		touchCounter = 0;
        
        isEraserCollide = NO;
	}
	
	return self;
}

- (void) eraserCollide {
	if ((!isEraserCollide)&&(!isOutOfArea)){
        isEraserCollide = YES;
        ++[Defs instance].totalDeadBloxCounter;
        
        [self getAchievement];
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
            [[MainScene instance].game addChild:emitterBoom z:150];
        
        [[BoomManager instance] add:costume.position _z:costume.zOrder];
        
        [self deactivate];
	}	
}

- (void) getAchievement {
    if ((![Defs instance].achievement_Bomb_1)&&([Defs instance].totalBombCounter == 1)) {
        [Defs instance].achievement_Bomb_1 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_Boom" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Bomb_10)&&([Defs instance].totalBombCounter == 10)) {
        [Defs instance].achievement_Bomb_10 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_BoomBang" percentComplete:100];
    }
    
    if ((![Defs instance].achievement_Bomb_100)&&([Defs instance].totalBombCounter == 100)) {
        [Defs instance].achievement_Bomb_100 = YES;
        //[[GameCenter instance] reportAchievementIdentifier:@"ExpandIt_BoomBangBoom" percentComplete:100];
    }
}

- (void) touch {
    [[MainScene instance].game bombExplosion:self];
    [self eraserCollide];
}

@end