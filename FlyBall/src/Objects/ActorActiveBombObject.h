//
//  ActorActiveObject.h
//  IncredibleBlox
//
//  Created by Mac Mini on 26.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import	"ActorActiveObject.h"

@interface ActorActiveBombObject : ActorActiveObject {

}

-(id) init:(CCNode*)_parent
   _location:(CGPoint)_location;
- (void) eraserCollide;
- (void) getAchievement;
- (void) touch;
@end
