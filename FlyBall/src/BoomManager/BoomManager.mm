//
//  ActorManager.mm
//  IncredibleBlox
//
//  Created by Mac Mini on 25.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoomManager.h"
#import "Boom.h"
#import "Defs.h"
#import "globalParam.h"
#import "ActorActiveObject.h"

@implementation BoomManager

@synthesize actorsAll;

- (id) init{
	if ((self = [super init])) {		
		actorsAll = [NSMutableArray arrayWithCapacity:15];
		[actorsAll retain];
        
        for (int i = 0; i < 15; i++) {
            <#statements#>
        }
	}
	return self;
}

- (void) add:(CGPoint*)_pos {
	[actorsAll addObject:_a];
	CCLOG(@"[ADD] actorCnt:%d",[actorsAll count]);
}

- (void) removeAll {
	Boom* actor;
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
	for (actor in actorsAll) [actor update:dt];
}		

- (void) show:(BOOL)_flag {
	Actor* actor;
	for (actor in actorsAll) [actor show:_flag];
}

@end
