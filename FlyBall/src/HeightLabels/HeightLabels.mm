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
        
        heightLabel = [CCSprite spriteWithSpriteFrameName:@"height_1000.png"];
        [heightLabel retain];
        
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
        
        flasher = [CCSprite spriteWithSpriteFrameName:@"flasher.png"];
        [flasher retain];
        
        pointFlasherOne = ccp(-140,42);
        pointFlasherTwo = ccp(133, 42);
        
        timeFlasher = 0;
        delayFlasher = 0.15f;
        isPointOneActive = NO;
        
        
        GUILabelTTFOutlinedDef *_labelTTFOutlinedDef = [GUILabelTTFOutlinedDef node];
        _labelTTFOutlinedDef.group = GAME_STATE_NONE;
        _labelTTFOutlinedDef.text = @"";
        _labelTTFOutlinedDef.parentFrame = [Defs instance].objectFrontLayer;
        _labelTTFOutlinedDef.zIndex = 52;
        labelHeight = [[MainScene instance].gui addItem:(id)_labelTTFOutlinedDef _pos:CGPointZero];
    }
	
	return self;
}

-(void) restartParameters {
    for (int i = 0; i < heightLabelsActive.count; i++) {
        [heightLabelsActive replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
    }
    
    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"height_1000.png"];
    [heightLabel setDisplayFrame:frame];
}

- (void) update {
    int _currValue;
    for (int i = 0; i < heightLabelsPosition.count; i++) {
        //CCSprite* _spr = [heightLabels objectAtIndex:i];
        _currValue = [[heightLabelsPosition objectAtIndex:i] intValue];
        
        if (([MainScene instance].game.player.position.y + (SCREEN_HEIGHT - screenPlayerPositionY) >= _currValue - heightLabel.contentSize.height*0.5f)
            && ([MainScene instance].game.player.position.y - screenPlayerPositionY <= _currValue + heightLabel.contentSize.height*0.5f)) {
            float _posX = [MainScene instance].game.player.position.x;
            if (_posX < -64) _posX = -64; else
                if (_posX > 384) _posX = 384;
            [heightLabel setPosition:ccp(_posX, _currValue)];
            
            [labelHeight setPosition:ccp(heightLabel.position.x, heightLabel.position.y - 22)];
        }
        
        if (![[heightLabelsActive objectAtIndex:i] boolValue]) {
            if ([MainScene instance].game.player.position.y + (SCREEN_HEIGHT - screenPlayerPositionY) >= _currValue - heightLabel.contentSize.height*0.5f){
                if (!heightLabel.parent) {
                    if (!heightLabel.parent) [[Defs instance].spriteSheetHeightLabels addChild:heightLabel];
                    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"height_1000.png"];
                    [heightLabel setDisplayFrame:frame];
                    
                    [labelHeight show:YES];
                    [labelHeight setText:[NSString stringWithFormat:@"%i",_currValue]];
                }
                
                if (([MainScene instance].game.player.position.y + 150 >= _currValue)
                    &&([MainScene instance].game.player.position.y <= _currValue)) {
                    float _timeScale = 0.3f - 0.05*i;
                    if (_timeScale < 0.1f) _timeScale = 0.1f;
                    [[MainScene instance].game bonusSlowMotionActivate:0.5f _timeScale:_timeScale];
                }
                
                if (([MainScene instance].game.player.position.y + 50 >= _currValue)
                    &&([MainScene instance].game.player.position.y - 100 <= _currValue)) {
                    CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"height_1000_active.png"];
                    [heightLabel setDisplayFrame:frame];
                    [heightLabelsActive replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
                    if (!flasher.parent) [[Defs instance].spriteSheetHeightLabels addChild:flasher z:10];
                }
                
                return;
            }
        } else {
            if (([MainScene instance].game.player.position.y - screenPlayerPositionY > _currValue + heightLabel.contentSize.height*0.5f)
                &&([MainScene instance].game.player.position.y - screenPlayerPositionY < _currValue + 200)
                &&(heightLabel.parent)) {
                if (heightLabel.parent) [heightLabel removeFromParent];
                if (flasher.parent) [flasher removeFromParent];
                [labelHeight show:NO];
            } else {
                timeFlasher += TIME_STEP;
                if (timeFlasher >= delayFlasher) {
                    if (isPointOneActive) {
                        isPointOneActive = NO;
                    } else {
                        isPointOneActive = YES;
                    }
                    timeFlasher = 0;
                }
                
                if (isPointOneActive) {
                    [flasher setPosition:ccpAdd(heightLabel.position, pointFlasherTwo)];
                } else {
                    [flasher setPosition:ccpAdd(heightLabel.position, pointFlasherOne)];
                }
            }
        }
    }
}

- (void) show:(BOOL)_flag{
    if (heightLabel.parent) [heightLabel removeFromParent];
}

@end
