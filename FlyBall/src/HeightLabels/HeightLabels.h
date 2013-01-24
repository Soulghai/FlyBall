//
//  Statistics.h
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HeightLabels : NSObject {
    NSArray* heightLabelsNames;
    NSArray* heightLabels;
    NSArray* heightLabelsPosition;
    NSMutableArray* heightLabelsActive;
}

- (void) update;
-(void) restartParameters;
- (void) show:(BOOL)_flag;

@end