//
//  ActorManager.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 25.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActorManager.h"
#import "Actor.h"
#import "Defs.h"
#import "globalParam.h"
#import "ActorActiveObject.h"

@implementation ActorManager

@synthesize actorsAll;

- (id) init{
	if ((self = [super init])) {		
		actorsAll = [NSMutableArray arrayWithCapacity:50];
		[actorsAll retain];
		actorsToRemove = [NSMutableArray arrayWithCapacity:50];
		[actorsToRemove retain];
		idCounter = 0;
	}
	return self;
}

- (void) add:(Actor*)_a {
	[actorsAll addObject:_a];
	[_a setID:idCounter++];
	CCLOG(@"[ADD] actorCnt:%d",[actorsAll count]);
}

- (void) initCounterIds {
	idCounter = 0;
}

- (void) normalizeIds {
	int min = 10000;
	int max = 0;
	Actor* actor;
	int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		actor = [actorsAll objectAtIndex:i];
		if ([actor getID] < min) min = [actor getID];
		if ([actor getID] > max) max = [actor getID];
	}
	
	idCounter = max+1;
}

- (BOOL) findSameId:(NSArray*)_arr
				_id:(int)_id {
	int _cnt = [_arr count];
	Actor* a = nil;
	for (int i = 0; i < _cnt; i++) {
		a = [_arr objectAtIndex:i];
		if (a.itemID == _id) return YES;
	}
	return NO;
}

- (void) markRemoveActor:(Actor*)_a {
	if ([actorsToRemove indexOfObjectIdenticalTo:_a] == NSNotFound) {
		[actorsToRemove addObject:_a];
		[_a prepareToRemove];
	}
	
	/*if (![self findSameId:actorsToRemove _id:_a.itemID]) {
		[actorsToRemove addObject:_a];
		[_a prepareToRemove];
	}*/
}

// вызывается после апдейта текущей итерации
- (void) removeActors {
	Actor* removeMe;
	for (removeMe in actorsToRemove)
	{
		if (!removeMe) continue;
		[removeMe removeActor];
		int actorIndex = [actorsAll indexOfObjectIdenticalTo:removeMe];
		if (actorIndex != NSNotFound) [actorsAll removeObjectAtIndex:actorIndex];
		[removeMe release];
        removeMe = nil;
		//trace("[REMOVE] actorCnt:",actorsAll.length);
	}

	[actorsToRemove removeAllObjects];
	if ([actorsAll count] == 0) [self initCounterIds];
}

- (void) removeMarked {
	[self removeActors];
}

- (void) removeAll:(id)_type
	   _exceptType:(NSString *)_exceptType {
	Actor* actor;
	int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		actor = [actorsAll objectAtIndex:i];
		if (((_exceptType == nil) || (!([actor isKindOfClass:NSClassFromString(_exceptType)])))
			&& ((_type == nil) || ([actor isKindOfClass:[_type class]]))) {
			[self markRemoveActor:actor];
		}
	}
}

- (void) update:(ccTime)dt {
	Actor* actor;
	//int _count = [actorsAll count];
	for (actor in actorsAll) {
		//actor = [actorsAll objectAtIndex:i];
		[actor update:dt];
	}
	[self removeMarked];
}

- (void) deleteOutOfAreaActors {
	Actor* actor;
	int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		actor = [actorsAll objectAtIndex:i]; 
		if ([actor getOutOfArea]) {
			[self markRemoveActor:actor]; 
		}
	}
}		

- (void) show:(BOOL)_flag {
	Actor* actor;
	//int _count = [actorsAll count];
	for (actor in actorsAll) {
		//actor = [actorsAll objectAtIndex:i];
		[actor show:_flag];
	}
}

@end
