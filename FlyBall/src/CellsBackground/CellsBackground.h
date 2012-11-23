//
//  Statistics.h
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CellsBackground : NSObject {
    BOOL isVisible;
    
    NSMutableArray *cells;
    int cellCountX;
    int cellCountY;
    int cellWidth;
    int cellHeight;
    NSMutableArray* cellCurrentFrames;
    NSMutableArray* cellsHighMap;
}

-(void) restartParameters;
- (void) update;
- (void) show:(BOOL)_flag;

@end