//
//  Statistics.h
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParalaxBackground : NSObject {
    int currentLevel;
    int oldLevel;
    int cellHeight;
    float cellScaleCoeff;
    NSArray* cellsHighMap;
    NSArray* leftBorders;
    NSArray* rightBorders;
    
    NSArray* paralax_2;
    float paralax_2_distanceToNextObjectDefault;
    float paralax_2_distanceToNextObjectRandomCoeff;
    float paralax_2_distanceToNextObject;
    
    NSArray* paralax_1;
    float paralax_1_distanceToNextObjectDefault;
    float paralax_1_distanceToNextObjectRandomCoeff;
    float paralax_1_distanceToNextObject;
}

-(void) restartParameters;
- (void) update;
- (void) show:(BOOL)_flag;

@end