//
//  Statistics.h
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUILabelTTFOutlined.h"

@interface HeightLabels : NSObject {
    CCSprite* heightLabel;
    NSArray* heightLabelsPosition;
    NSMutableArray* heightLabelsActive;
    
    CCSprite *flasher;
    CGPoint pointFlasherOne;
    CGPoint pointFlasherTwo;
    float timeFlasher;
    float delayFlasher;
    BOOL isPointOneActive;
    
    GUILabelTTFOutlined* labelHeight;
}

- (void) update;
-(void) restartParameters;
- (void) show:(BOOL)_flag;

@end