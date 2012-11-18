//
//  GUIItemDef.h
//  Expand_It
//
//  Created by Mac Mini on 27.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GUIItemDef : CCNode {
    BOOL enabled;
	unsigned int group;
	CCNode *parentFrame;
	NSString *sprName;
    NSString *sprFileName;
	id objCreator;
    int zIndex;
}

@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) unsigned int group;
@property (nonatomic,assign) CCNode *parentFrame;
@property (nonatomic,assign) NSString *sprName;
@property (nonatomic,assign) NSString *sprFileName;
@property (nonatomic,assign) id objCreator;
@property (nonatomic,assign) int zIndex;

- (id) init;

@end
