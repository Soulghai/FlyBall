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

- (id) init;
- (void) add:(CGPoint*)_pos;
- (void) removeActors;
- (void) update:(ccTime)dt;
- (void) show:(BOOL)_flag;

@end
