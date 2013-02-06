//
//  Statistics.m
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParalaxBackground.h"
#import "Defs.h"
#import "GameStandartFunctions.h"
#import "globalParam.h"
#import "MainScene.h"

@implementation ParalaxBackground


- (id)init {
	if ((self = [super init])) {
        cellHeight = 2048;
        cellScaleCoeff = 1.25f;
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        cellsHighMap = [NSArray arrayWithObjects:[CCSprite spriteWithFile:@"back_1.jpg"],
                        [CCSprite spriteWithFile:@"back_2.jpg"],
                        [CCSprite spriteWithFile:@"back_3.jpg"],
                        [CCSprite spriteWithFile:@"back_4.jpg"],
                        [CCSprite spriteWithFile:@"back_5.jpg"],nil];
        [cellsHighMap retain];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        CCSprite *_spr;
        for (int i = 0; i < [cellsHighMap count]; i++) {
            _spr = [cellsHighMap objectAtIndex:i];
            [_spr setAnchorPoint:CGPointZero];    
            [_spr setPosition:ccp(0,i*(cellHeight*cellScaleCoeff))];
            [_spr setScale:cellScaleCoeff];
        }
        
        leftBorders = [NSArray arrayWithObjects:[CCSprite spriteWithSpriteFrameName:@"wall.png"],
                        [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                        [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                        [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                        [CCSprite spriteWithSpriteFrameName:@"wall.png"],nil];
        [leftBorders retain];
        
        rightBorders = [NSArray arrayWithObjects:[CCSprite spriteWithSpriteFrameName:@"wall.png"],
                       [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                       [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                       [CCSprite spriteWithSpriteFrameName:@"wall.png"],
                       [CCSprite spriteWithSpriteFrameName:@"wall.png"],nil];
        [rightBorders retain];
        
        for (int i = 0; i < leftBorders.count; i++) {
            _spr = [leftBorders objectAtIndex:i];
            [_spr setAnchorPoint:ccp(0, 0)];
            [_spr setFlipX:YES];

            _spr = [rightBorders objectAtIndex:i];
            [_spr setAnchorPoint:ccp(1, 0)];
        }
        
        paralax_2 = [NSArray arrayWithObjects:
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_1.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_2.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_3.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_4.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_5.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_6.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_7.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_8.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_9.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_10.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_11.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_12.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_13.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_14.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_15.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_16.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_17.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_2_18.png"],
                       nil];
        [paralax_2 retain];
        
        for (int i = 0; i < paralax_2.count; i++) {
            _spr = [paralax_2 objectAtIndex:i];
            [_spr setScale:cellScaleCoeff];
            if (CCRANDOM_0_1() > 0.5f) [_spr setFlipX:YES];
        }
        
        paralax_2_distanceToNextObjectDefault = SCREEN_HEIGHT_HALF;
        paralax_2_distanceToNextObjectRandomCoeff = SCREEN_HEIGHT_HALF;
        paralax_2_distanceToNextObject = SCREEN_HEIGHT_HALF*2;
        
        //Паралакс слой под ногами
        paralax_1 = [NSArray arrayWithObjects:
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_1.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_2.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_3.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_4.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_5.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_6.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_7.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_8.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_9.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_10.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_11.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_12.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_13.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_14.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_15.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_16.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_17.png"],
                     [CCSprite spriteWithSpriteFrameName:@"layer_1_18.png"],
                     nil];
        [paralax_1 retain];
        
        for (int i = 0; i < paralax_1.count; i++) {
            _spr = [paralax_1 objectAtIndex:i];
            [_spr setScale:cellScaleCoeff];
            if (CCRANDOM_0_1() > 0.5f) [_spr setFlipX:YES];
        }
        
        paralax_1_distanceToNextObjectDefault = SCREEN_HEIGHT_HALF;
        paralax_1_distanceToNextObjectRandomCoeff = SCREEN_HEIGHT_HALF;
        paralax_1_distanceToNextObject = SCREEN_HEIGHT_HALF*2;
    }
	
	return self;
}

-(void) restartParameters {
    currentLevel = 0;
    oldLevel = 0;
    CCSprite* _spr = [cellsHighMap objectAtIndex:0];
    if (!_spr.parent) [[Defs instance].objectBackLayer addChild:_spr z:-1];
    
    for (int i = 0; i < leftBorders.count; i++) {
        _spr = [leftBorders objectAtIndex:i];
        [_spr setPosition:ccp(-224,i*128)];

        _spr = [rightBorders objectAtIndex:i];
        [_spr setPosition:ccp(544,i*128)];
    }
    
    paralax_2_distanceToNextObject = SCREEN_HEIGHT_HALF*2;
    
    paralax_1_distanceToNextObject = SCREEN_HEIGHT_HALF*2;
}

- (void) manageWalls {
    CCSprite *_spr;
    for (int i = 0; i < leftBorders.count; i++) {
        _spr = [leftBorders objectAtIndex:i];
        
        if (_spr.position.y + [Defs instance].objectFrontLayer.position.y < -128) {
            _spr.position = ccp(_spr.position.x, _spr.position.y + 5*128);
        } else
            if (_spr.position.y + [Defs instance].objectFrontLayer.position.y > 5*128 - 128) {
                _spr.position = ccp(_spr.position.x, _spr.position.y - + 5*128);
            }
        
        _spr = [rightBorders objectAtIndex:i];
        
        if (_spr.position.y + [Defs instance].objectFrontLayer.position.y < -128) {
            _spr.position = ccp(_spr.position.x, _spr.position.y + 5*128);
        } else
            if (_spr.position.y + [Defs instance].objectFrontLayer.position.y > 5*128 - 128) {
                _spr.position = ccp(_spr.position.x, _spr.position.y - 5*128);
            }
    }
}

- (void) addParalax2Object:(float)_posY {
    
    int _yCoeff = int([MainScene instance].game.player.position.y / 30000);
    
    if (_yCoeff > cellsHighMap.count) _yCoeff = cellsHighMap.count;
    
    int _ranID = _yCoeff*3 + int(round(CCRANDOM_0_1()*2));
    //if (_ranID > paralax_2.count-1) _ranID = paralax_2.count-1;
    CCSprite* _spr = [paralax_2 objectAtIndex:_ranID];
    // Если объект не на экране, то добавляем его
    // Если на экране, то просто пропускаем эту итерацию
    
    if (!_spr.parent) {
        if (CCRANDOM_0_1() > 0.5f) [_spr setFlipX:YES];
        [[Defs instance].spriteSheetParalax_2 addChild:_spr];
        [_spr setPosition:ccp([MainScene instance].game.player.position.x + CCRANDOM_MINUS1_1()*SCREEN_WIDTH_HALF, _posY + _spr.contentSize.height*0.5f)];
    }
    
    paralax_2_distanceToNextObject += paralax_2_distanceToNextObjectDefault + CCRANDOM_0_1()*paralax_2_distanceToNextObjectRandomCoeff;
}

- (void) addParalax1Object:(float)_posY {
    int _yCoeff = int([MainScene instance].game.player.position.y / 30000);
    
    if (_yCoeff > cellsHighMap.count) _yCoeff = cellsHighMap.count;
    
    int _ranID = _yCoeff*3 + int(round(CCRANDOM_0_1()*2));
    //if (_ranID > paralax_1.count-1) _ranID = paralax_1.count-1;
    CCSprite* _spr = [paralax_1 objectAtIndex:_ranID];
    // Если объект не на экране, то добавляем его
    // Если на экране, то просто пропускаем эту итерацию
    if (!_spr.parent) {
        if (CCRANDOM_0_1() > 0.5f) [_spr setFlipX:YES];
        [[Defs instance].spriteSheetParalax_1 addChild:_spr];
        [_spr setPosition:ccp([MainScene instance].game.player.position.x + CCRANDOM_MINUS1_1()*SCREEN_WIDTH_HALF, _posY + _spr.contentSize.height*0.5f)];
    }
    
    paralax_1_distanceToNextObject += paralax_1_distanceToNextObjectDefault + CCRANDOM_0_1()*paralax_1_distanceToNextObjectRandomCoeff;
}

- (void) update {
    [self manageWalls];
    //currentLevel = int((-[Defs instance].objectBackLayer.position.y + SCREEN_HEIGHT)/(cellHeight*cellScaleCoeff));
    
    CCSprite *_spr;
    for (int i = 0; i < cellsHighMap.count; i++) {
        _spr = [cellsHighMap objectAtIndex:i];
      
        if (!_spr.parent) {
            if ((-[Defs instance].objectBackLayer.position.y + SCREEN_HEIGHT >= _spr.position.y)
                &&(-[Defs instance].objectBackLayer.position.y <= _spr.position.y + (cellHeight*cellScaleCoeff))) {
                oldLevel = currentLevel;
                [[Defs instance].objectBackLayer addChild:_spr z:-1];
                //break;
            }
        }else {
            if (-[Defs instance].objectBackLayer.position.y >= _spr.position.y + (cellHeight*cellScaleCoeff)) {
                 [_spr removeFromParentAndCleanup:NO];
               // break;
            }
        }
    }
    
    // paralax 2
    if (-[Defs instance].spriteSheetParalax_2.position.y + SCREEN_HEIGHT >= paralax_2_distanceToNextObject) {
        [self addParalax2Object:-[Defs instance].spriteSheetParalax_2.position.y + SCREEN_HEIGHT];
    }
    
    for (int i = 0; i < paralax_2.count; i++) {
        _spr = [paralax_2 objectAtIndex:i];
        if (_spr.parent)
            if (-[Defs instance].spriteSheetParalax_2.position.y - SCREEN_HEIGHT_HALF > _spr.position.y + _spr.contentSize.height*0.5f) {
                [_spr removeFromParent];
            }
    }
    
    // paralax 1
    if ([MainScene instance].game.player.position.y + SCREEN_HEIGHT_HALF >= paralax_1_distanceToNextObject) {
        [self addParalax1Object:[MainScene instance].game.player.position.y + SCREEN_HEIGHT_HALF];
    }
    
    for (int i = 0; i < paralax_1.count; i++) {
        _spr = [paralax_1 objectAtIndex:i];
        if (_spr.parent)
        if ([MainScene instance].game.player.position.y - SCREEN_HEIGHT > _spr.position.y + _spr.contentSize.height*0.5f) {
            [_spr removeFromParent];
        }
    }
}

- (void) show:(BOOL)_flag{
    CCSprite *_spr;
    for (int i = 0; i < cellsHighMap.count; i++) {
        _spr = [cellsHighMap objectAtIndex:i];
        if (_flag){
           //if (!_spr.parent) [[Defs instance].objectFrontLayer addChild:_spr z:0];
        }else {
            if (_spr.parent) [_spr removeFromParentAndCleanup:YES];
        }
    }
    
    for (int i = 0; i < leftBorders.count; i++) {
        _spr = [leftBorders objectAtIndex:i];
        if (_flag){
            if (!_spr.parent) [[Defs instance].spriteSheetChars addChild:_spr z:0];
        }else {
            if (_spr.parent) [_spr removeFromParentAndCleanup:YES];
        }
        
        _spr = [rightBorders objectAtIndex:i];
        if (_flag){
            if (!_spr.parent) [[Defs instance].spriteSheetChars addChild:_spr z:0];
        }else {
            if (_spr.parent) [_spr removeFromParentAndCleanup:YES];
        }
    }
    
    for (int i = 0; i < paralax_1.count; i++) {
        _spr = [paralax_1 objectAtIndex:i];
        if (_flag){
            //if (!_spr.parent) [[Defs instance].spriteSheetParalax_2 addChild:_spr];
        }else {
            if (_spr.parent) [_spr removeFromParentAndCleanup:YES];
        }
    }
    
    for (int i = 0; i < paralax_2.count; i++) {
        _spr = [paralax_2 objectAtIndex:i];
        if (_flag){
            //if (!_spr.parent) [[Defs instance].spriteSheetParalax_2 addChild:_spr];
        }else {
            if (_spr.parent) [_spr removeFromParentAndCleanup:YES];
        }
    }
}

@end
