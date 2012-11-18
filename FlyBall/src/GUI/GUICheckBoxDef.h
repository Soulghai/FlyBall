//
//  GUICheckBoxDef.h
//  Expand_It
//
//  Created by Mac Mini on 11.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GUIItemDef.h"

@interface GUICheckBoxDef : GUIItemDef {
	NSString *sprTwoName;
	NSString *sprOneDownName;
	NSString *sprTwoDownName;
	NSString *sound;
	SEL func;
	BOOL checked;
}

@property (nonatomic,assign) NSString *sprTwoName;
@property (nonatomic,assign) NSString *sprOneDownName;
@property (nonatomic,assign) NSString *sprTwoDownName;
@property (nonatomic,assign) NSString *sound;
@property (nonatomic,assign) SEL func;
@property (nonatomic,assign) BOOL checked;

- (id) init;

@end
