//
//  ActorManager.h
//  IncredibleBlox
//
//  Created by Mac Mini on 25.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Actor.h"

@interface ActorManager : CCNode {
	NSMutableArray *actorsToRemove;
	int idCounter;
}

@property (nonatomic, assign) NSMutableArray *actorsAll;

- (id) init;
- (void) add:(Actor*)_a;
- (void) initCounterIds;
- (void) normalizeIds;
- (void) markRemoveActor:(Actor*)_a;
- (void) removeActors;
- (void) removeMarked;
- (void) removeAll:(id)_type
	   _exceptType:(NSString *)_exceptType;
- (void) update:(ccTime)dt;
- (void) deleteOutOfAreaActors;
- (void) show:(BOOL)_flag;

@end
