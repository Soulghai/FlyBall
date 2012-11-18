//
//  Statistics.m
//  Expand_It
//
//  Created by Mac Mini on 13.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Statistics.h"


@implementation Statistics

@synthesize totalLevelsComplite;
@synthesize totalLevelsStart;
@synthesize rateMeWindowShowValue;

static Statistics *instance_;

static void instance_remover() {
	[instance_ release];
}

+ (Statistics*)instance {
	@synchronized(self) {
		if( instance_ == nil ) {
			[[self alloc] init];
		}
	}
	
	return instance_;
}

- (id)init {
	self = [super init];
	instance_ = self;
	
	atexit(instance_remover);
	
	return self;
}

- (void)dealloc {
	[super dealloc];
}

@end
