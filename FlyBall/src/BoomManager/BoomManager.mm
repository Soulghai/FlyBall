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

static BoomManager *instance_;

static void instance_remover() {
	[instance_ release];
}

+ (BoomManager*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}

- (id) init{
	self = [super init];
	instance_ = self;
	
	atexit(instance_remover);
    
    actorsAll = [NSMutableArray arrayWithCapacity:15];
    [actorsAll retain];
    
    for (int i = 0; i < 15; i++) {
        [actorsAll addObject:[[Boom alloc] init]];
    }
    
	return self;
}

- (Boom*) findInActive {
    Boom *_b = nil;
    
    int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		_b = [actorsAll objectAtIndex:i];
		if (!_b.isActive) return _b;
    }
    
    return _b;
}

- (void) add:(CGPoint)_pos
          _z:(int)_z{
	Boom *_b = [self findInActive];
    if (!_b) {
        _b = [[Boom alloc] init];
        [actorsAll addObject:_b];
    }
    
    [_b activate];
    [_b setPosition:_pos _z:_z];
}

- (void) inactiveAll {
	Boom* _actor;
	int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		_actor = [actorsAll objectAtIndex:i];
		if (_actor.isActive) {
			[_actor deactivate];
        }
	}
}

- (void) removeAll {
	Boom* _actor;
	int _count = [actorsAll count];
	for (int i = 0; i < _count; i++) {
		_actor = [actorsAll objectAtIndex:i];
		if (_actor.isActive) {
			[_actor removeCostume];
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
