//
//  ActorManager.h
//  IncredibleBlox
//
//  Created by Mac Mini on 25.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BoomManager : CCNode {
}

@property (nonatomic, assign) NSMutableArray *actorsAll;

+ (BoomManager*) instance;
- (id) init;
- (void) add:(CGPoint)_pos
          _z:(int)_z;
- (void) inactiveAll;
- (void) removeAll;
- (void) update:(ccTime)dt;
- (void) show:(BOOL)_flag;

@end
