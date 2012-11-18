//
//  Statistics.m
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellsBackground.h"
#import "Defs.h"
#import "GameStandartFunctions.h"
#import "globalParam.h"

@implementation CellsBackground

static CellsBackground *instance_;

static void instance_remover() {
	[instance_ release];
}

+ (CellsBackground*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}

- (id)init {
	self = [super init];
	instance_ = self;
	
	atexit(instance_remover);
    
    cells = [NSMutableArray arrayWithCapacity:6*8];
    [cells retain];
    
    cellCountX = 6;
    cellCountY = 5;
    cellWidth = 64;
    cellHeight = 128;
    
    cellsHighMap = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SCREEN_HEIGHT_HALF],
                    [NSNumber numberWithInt:2000],
                    [NSNumber numberWithInt:5000],
                    [NSNumber numberWithInt:10000],nil];
    [cellsHighMap retain];
    
    cellCurrentFrames = [NSMutableArray arrayWithCapacity:cellCountX*cellCountY];
    for (int i = 0; i < cellCountX*cellCountY; i++) {
        [cellCurrentFrames addObject:[NSNumber numberWithInteger:0]];
    }
    [cellCurrentFrames retain];
    
    CCSprite *_spr;
    for (int i = 0; i < cellCountX; i++) {
        for (int j = 0; j < cellCountY; j++) {
            _spr = [CCSprite spriteWithSpriteFrameName:@"cell_0.jpg"];
            [_spr setAnchorPoint:CGPointZero];
            [cells addObject:_spr];
        }
    }
	
	return self;
}

-(void) restartParameters {
    CCSprite *_spr;
    CCSpriteFrame* frame;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        [_spr setPosition:ccp((i % cellCountX)*cellWidth, (int)round(i / cellCountX)*cellHeight)];
        frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cell_0.jpg"];
        [_spr setDisplayFrame:frame];
    }
    
    for (int i = 0; i < cellCurrentFrames.count; i++) {
        [cellCurrentFrames replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:0]];
    }
}

- (void) update {
    CCSprite *_spr;
    CCSpriteFrame* frame;
    for (int i = 0; i < cells.count; i++) {
        _spr = [cells objectAtIndex:i];
        if (_spr.position.y + [Defs instance].objectFrontLayer.position.y < -cellHeight) _spr.position = ccp(_spr.position.x, _spr.position.y + cellCountY*cellHeight); else
            if (_spr.position.y + [Defs instance].objectFrontLayer.position.y > cellCountY*cellHeight - cellHeight) _spr.position = ccp(_spr.position.x, _spr.position.y - + cellCountY*cellHeight);
        if (_spr.position.x + [Defs instance].objectFrontLayer.position.x < -cellWidth) _spr.position = ccp(_spr.position.x + cellCountX*cellWidth, _spr.position.y); else
            if (_spr.position.x + [Defs instance].objectFrontLayer.position.x > cellCountX*cellWidth - cellWidth) _spr.position = ccp(_spr.position.x - cellCountX*cellWidth, _spr.position.y);
        
        
        
        int _cellCurrentFrameValue = [[cellCurrentFrames objectAtIndex:i] intValue];
        
        int _currHighLevel = cellsHighMap.count - 1;   // если вдруг мы добрались до самого верха, то всегда будем видеть последнюю текстуру
        for (int i = 0; i < cellsHighMap.count; i++) {
            if (_spr.position.y < [[cellsHighMap objectAtIndex:i] intValue]) {
                _currHighLevel  = i;
                break;
            }
        }
        
        if (_cellCurrentFrameValue != _currHighLevel) {
            _cellCurrentFrameValue = _currHighLevel;
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"cell_%i.jpg",_cellCurrentFrameValue]];
            [_spr setDisplayFrame:frame];
            [cellCurrentFrames replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:_cellCurrentFrameValue]];
        }
    }
}

- (void) show:(BOOL)_flag{
	if (isVisible != _flag) {
        
		isVisible = _flag;
        
        CCSprite *_spr;
        for (int i = 0; i < cells.count; i++) {
            _spr = [cells objectAtIndex:i];
            if (isVisible){
                if (!_spr.parent) [[Defs instance].spriteSheetCells addChild:_spr z:0 tag:i];
            }else {
                if (_spr.parent) [_spr removeFromParent];
            }
        }
	}
}

@end
