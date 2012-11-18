//
//  GUICheckBoxDef.mm
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GUICheckBoxDef.h"

@implementation GUICheckBoxDef

@synthesize sprTwoName;
@synthesize sprOneDownName;
@synthesize sprTwoDownName;
@synthesize sound;
@synthesize func;
@synthesize checked;

- (id) init{
	if ((self = [super init])) {		
		
		checked = NO;
		enabled = YES;
	}
	return self;
}

@end
