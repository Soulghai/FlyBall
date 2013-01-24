//
//  Statistics.m
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeightLabels.h"
#import "Defs.h"
#import "GameStandartFunctions.h"
#import "globalParam.h"
#import "MainScene.h"

@implementation HeightLabels


- (id)init {
	if ((self = [super init])) {
        
        heightLabelsNames = [NSArray arrayWithObjects:@"height_1000",
                             @"height_1000",
                             @"height_1000",
                             @"height_1000",
                             @"height_1000",nil];
        [heightLabelsNames retain];
        
        heightLabels = [NSArray arrayWithObjects:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:0]]],
                        [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:1]]],
                        [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:2]]],
                        [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:3]]],
                        [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:4]]],nil];
        [heightLabels retain];
        
        heightLabelsPosition = [NSArray arrayWithObjects:[NSNumber numberWithInt:10000],
                                [NSNumber numberWithInt:25000],
                                [NSNumber numberWithInt:50000],
                                [NSNumber numberWithInt:100000],
                                [NSNumber numberWithInt:250000], nil];
        [heightLabelsPosition retain];
        
        heightLabelsActive = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],
                                [NSNumber numberWithBool:NO],
                                [NSNumber numberWithBool:NO],
                                [NSNumber numberWithBool:NO],
                                [NSNumber numberWithBool:NO], nil];
        [heightLabelsActive retain];
        
        
        for (int i = 0; i < heightLabelsPosition.count; i++) {
                CCSprite* _spr = [heightLabels objectAtIndex:i];
            [_spr setPosition:ccp(SCREEN_WIDTH_HALF,[[heightLabelsPosition objectAtIndex:i] intValue])];
        }
    }
	
	return self;
}

-(void) restartParameters {
    CCSprite* _spr;
    
    for (int i = 0; i < heightLabelsActive.count; i++) {
        [heightLabelsActive replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        
        _spr = [heightLabels objectAtIndex:i];
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@.png",[heightLabelsNames objectAtIndex:i]]];
        [_spr setDisplayFrame:frame];
    }
}

- (void) update {
    int _currValue;
    for (int i = 0; i < heightLabelsPosition.count; i++) {
        CCSprite* _spr = [heightLabels objectAtIndex:i];
        _currValue = [[heightLabelsPosition objectAtIndex:i] intValue];
        
        if (([MainScene instance].game.player.position.y + (SCREEN_HEIGHT - screenPlayerPositionY) >= _currValue - _spr.contentSize.height*0.5f)
            && ([MainScene instance].game.player.position.y - screenPlayerPositionY <= _currValue + _spr.contentSize.height*0.5f)) {
            [_spr setPosition:ccp([MainScene instance].game.player.position.x, _currValue)];
        }
        
        if (![[heightLabelsActive objectAtIndex:i] boolValue]) {
            if ([MainScene instance].game.player.position.y + (SCREEN_HEIGHT - screenPlayerPositionY) >= _currValue - _spr.contentSize.height*0.5f){
                if (!_spr.parent) [[Defs instance].spriteSheetHeightLabels addChild:_spr];
                
                if (([MainScene instance].game.player.position.y + 150 >= _currValue)
                    &&([MainScene instance].game.player.position.y <= _currValue)) {
                    float _timeScale = 0.3f - 0.05*i;
                    if (_timeScale < 0.1f) _timeScale = 0.1f;
                    [[MainScene instance].game bonusSlowMotionActivate:0.5f _timeScale:_timeScale];
                }
                
                if (([MainScene instance].game.player.position.y >= _currValue)
                    &&([MainScene instance].game.player.position.y - 150 <= _currValue)) {
                    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@_active.png",[heightLabelsNames objectAtIndex:i]]];
                    [_spr setDisplayFrame:frame];
                    [heightLabelsActive replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                }
                
                return;
            }
        } else {
            if (([MainScene instance].game.player.position.y - screenPlayerPositionY > _currValue + _spr.contentSize.height*0.5f)
                &&(_spr.parent)) { [_spr removeFromParent];
            }
        }
    }
}

- (void) show:(BOOL)_flag{
    CCSprite* _spr;
    
    if (!_flag)
    for (int i = 0; i < heightLabels.count; i++) {
        _spr = [heightLabels objectAtIndex:i];
        if (_spr.parent) [_spr removeFromParent];
    }
}

@end
