//
//  GUIButtonDef.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItemDef.h"

@interface GUIButtonDef : GUIItemDef {
	NSString *sprDownName;
	NSString *sound;
	SEL func;
    
    BOOL isManyTouches;
}

@property (nonatomic,assign) NSString *sprDownName;
@property (nonatomic,assign) NSString *sound;
@property (nonatomic,assign) SEL func;
@property (nonatomic,readwrite) BOOL isManyTouches;

- (id) init;

@end
